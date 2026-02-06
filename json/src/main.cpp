#include <iostream>
#include <nlohmann/json.hpp>
#include <fstream>
#include <vector>

using json = nlohmann::json;

struct Book {
    std::string title;
    std::string author;
    int year;
};
NLOHMANN_DEFINE_TYPE_NON_INTRUSIVE(Book, title, author, year);

struct Person {
    std::string name;
    int age;
    bool is_student;
    std::vector<Book> books;
};
NLOHMANN_DEFINE_TYPE_NON_INTRUSIVE(Person, name, age, is_student, books);

void basic_example() {
    Book b1{"1984", "George Orwell", 1949};
    Book b2{"To Kill a Mockingbird", "Harper Lee", 1960};
    Book b3{"The Great Gatsby", "F. Scott Fitzgerald", 1925};

    std::vector<Person> p;
    p.push_back({"John Doe", 30, false, {b1, b2}});
    p.push_back({"Jane Doe", 25, true, {b3}});

    json j = p;

    std::ofstream arquivo_o("dados.json");
    arquivo_o << j.dump(4);
    arquivo_o.close();

    json j2;
    std::ifstream arquivo_i("dados.json");
    arquivo_i >> j2;
    arquivo_i.close();

    auto p2 = j2.get<std::vector<Person>>();

    std::cout << j2.dump() << std::endl;
    for (const auto& person : p2) {
        std::cout << person.name << ", " << person.age << ", " << (person.is_student ? "true" : "false") << std::endl;
        for (const auto& book : person.books) {
            std::cout << "\t| " << book.title << " by " << book.author << " (" << book.year << ")" << std::endl;
        }
    }   
}

void error_handling_example() {
    std::ofstream arq("config.json");
    arq << "{ \"app_name\": \"Sistema\" "; // Faltou fechar chaves!
    arq.close();

    try {
        std::ifstream input("config.json");
        json j;
        input >> j;
    } catch (json::parse_error& e) {
        std::cerr << "Erro de sintaxe no JSON: " << e.what() << std::endl;
    }

    json config = { {"app_name", "Sistema"} };

    // Se "versao" não existir, usa 1.0 como padrão
    double versao = config.value("versao", 1.0); 
    std::cout << "Versão carregada: " << versao << std::endl;

    if (config.contains("debug_mode")) {
    // faz algo
    } else {
        std::cout << "Modo debug não configurado." << std::endl;
    }
}

int main() {
    // basic_example();
    // error_handling_example();

    return 0;
}