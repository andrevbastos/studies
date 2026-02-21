#include <iostream>
#include <algorithm>
#include <ranges>
#include <optional>
#include <vector>
#include <memory>

#include "buffer.hpp"

struct Config {
    int id;
    float sensitivity;
};

struct Jogador1 {
    std::string nome;
    int pontuacao;
};

struct Jogador2 {
    std::string nome;
    int pontuacao;

    bool operator<(const Jogador2& other) const {
        return pontuacao < other.pontuacao;
    }
};

// Função para buscar um Config por ID usando std::optional
std::optional<Config> buscar_por_id(const std::vector<Config>& lista, int id_procurado) {
    for (const auto& item : lista) {
        if (item.id == id_procurado) {
            return item; // Retorna o Config encontrado
        }
    }
    return std::nullopt; // Retorna vazio se não encontrar
}

// Exemplo de classe para demonstrar o uso de std::unique_ptr
class Motor {
public:
    Motor() { std::cout << "Motor ligado!" << std::endl; }
    ~Motor() { std::cout << "Motor destruído com segurança." << std::endl; }
    void status() { std::cout << "Operando a 100%." << std::endl; }
};

// Exemplo de classes com referência circular usando std::shared_ptr
struct B; // forward declaration
struct A { std::shared_ptr<B> ptr_b; };
struct B { std::shared_ptr<A> ptr_a; };

// Exemplo de classe para demonstrar Move Semantics
class Buffer1 {
    int* data;
    size_t size;
public:
    Buffer1(size_t s) : size(s), data(new int[s]) {}
    ~Buffer1() { delete[] data; }

    // Copy Constructor (O modo lento e caro)
    Buffer1(const Buffer1& other) {
        // Copia o tamanho do buffer
        this->size = other.size;
        // Criação de uma nova cópia dos dados
        this->data = new int[other.size];
        // Copia os dados do outro objeto para o novo objeto
        for (size_t i = 0; i < other.size; ++i) {
            this->data[i] = other.data[i];
        }
    }

    // Move Constructor (O modo moderno e rápido)
    Buffer1(Buffer1&& other) noexcept {
        this->size = other.size;
        // "Rouba" os dados do outro objeto
        this->data = other.data;
        // Deixa o outro objeto vazio para evitar dupla liberação de memória
        other.size = 0;
        other.data = nullptr;
    }

    // Move Assignment Operator (O modo moderno e rápido para atribuição)
    Buffer1& operator=(Buffer1&& other) noexcept {
        // Verifica auto-atribuição
        if (this == &other) return *this;

        // Libera os recursos atuais antes de assumir os novos
        delete[] this->data;

        // "Rouba" os dados do outro objeto
        this->size = other.size;
        this->data = other.data;
        other.size = 0;
        other.data = nullptr;

        // Retorna a referência para o objeto atual
        return *this;
    }
};

// Exemplo de classe para demonstrar Copy-and-Swap
class Buffer2 {
    int* data;
    size_t size;
public:
    Buffer2(size_t s) : size(s), data(new int[s]) {}
    ~Buffer2() { delete[] data; }

    // Copy Constructor
    Buffer2(const Buffer2& other) 
        : size(other.size), data(new int[other.size]) {
            std::copy(other.data, other.data + other.size, this->data);
    }

    // Move Constructor
    Buffer2(Buffer2&& other) noexcept 
        // Inicializa os membros do objeto atual com valores vazios antes de trocar os dados
        : data(nullptr), size(0) {
            // Troca os dados entre o objeto atual e o outro objeto, deixando o outro objeto vazio
            std::swap(this->data, other.data);
            std::swap(this->size, other.size);
    }

    // Unified Assignment Operator (Usando Copy-and-Swap para ambos Copy e Move)
    // Note que o other é enviado como rvalue, permitindo que os valores antigos da 
    // instância atual seja descartada de forma segura.
    Buffer2& operator=(Buffer2 other) noexcept {
        // Troca os dados entre o objeto atual e o outro objeto, 
        // deixando o other em formato de rvalue vazio
        std::swap(this->data, other.data);
        std::swap(this->size, other.size);
        return *this;
    }
};

int main() {
    // Inicialização legado, permite conversão implícita de tipos, o que pode levar a erros sutis
    int temp_A = 36.6;

    // Inicialização uniforme, previne conversões implícitas e é mais segura
    // int temp_B = 36.6; // Erro de compilação: não é possível converter double para int
    float temp_B{36.6}; // Correto: temp_B é inicializado como float, tipo deduzido pelo compilador

    auto var1 = 10;   // Inicializada como int, tipo deduzido pelo compilador
    auto var2{10};    // Inicializada como int, tipo deduzido pelo compilador
    auto var3 = {10}; // Inicializada como std::initializer_list<int>

    // Lista inicializada como std::initializer_list<int>
    auto list = {10, 20, 30, 40};
    // Valor int definido para comparação dentro do lambda
    auto limit{25};

    // Uso de lambda para imprimir valores maiores que 'limit'
    std::for_each(list.begin(), list.end(), [limit](int value) {
        if (value > limit) {
            std::cout << value << std::endl;
        }
    });

    // Vetor de Configurações
    auto configs = std::vector<Config>{
        {1, 0.5f},
        {2, 0.8f},
        {3, 0.3f}
    };
    // ID a ser procurado
    auto id_procurado{2};
    // Busca pelo Config com o ID especificado
    auto resultado = buscar_por_id(configs, id_procurado);
    // Se encontrado, imprime a sensibilidade
    if (resultado) {
        std::cout << resultado->sensitivity << std::endl;
    }

    // Desestruturação de objetos usando auto
    Config c{10, 0.99};
    auto [id, sens]{c};
    
    {
        // Uso de std::unique_ptr para gerenciamento automático de memória
        auto motor{std::make_unique<Motor>()};
        
        // auto motor2{motor}; // Erro de compilação: std::unique_ptr não pode ser copiado
        auto motor2{std::move(motor)}; // Correto: transfere a propriedade do motor para motor2

        // motor->status(); // Erro de execução: motor foi movido, agora é nullptr
        motor2->status(); // Correto: motor2 é o novo proprietário do Motor
    }

    auto a = std::make_shared<A>();
    auto b = std::make_shared<B>();
    a->ptr_b = b; // A possui um ponteiro para B
    b->ptr_a = a; // B possui um ponteiro para A, criando uma referência circular

    auto weak_a = std::weak_ptr<A>(a); // weak_ptr para evitar referência circular
    auto weak_b = std::weak_ptr<B>(b); // weak_ptr para evitar referência circular
    weak_a.lock()->ptr_b; // Acessa B através de A, verificando se A ainda existe
    weak_b.lock()->ptr_a; // Acessa A através de B, verificando se B ainda existe

    // Exemplo de uso da classe Buffer com template
    Buffer<int> buffer(3);
    buffer.begin()[0] = 10;
    buffer.begin()[1] = 20;
    buffer.begin()[2] = 30;

    // Itera sobre os elementos do buffer usando range-based for loop
    // só é possível porque Buffer implementa os métodos begin() e end() 
    // que retornam ponteiros para o início e fim dos dados.
    std::cout << "Iterando pelo buffer:" << std::endl;
    for (const auto& valor : buffer) {
        std::cout << valor << " ";
    }
    std::cout << std::endl;

    // Uso de std::ranges para manipular o buffer, por exemplo, invertendo a ordem dos elementos
    std::ranges::reverse(buffer);
    std::cout << "Buffer invertido:" << std::endl;
    for (const auto& valor : buffer) {
        std::cout << valor << " ";
    }
    std::cout << std::endl;

    // Criando um Buffer de Jogadores e ordenando-os por pontuação usando std::ranges e Lambda
    Buffer<Jogador1> jogadores1(3);
    jogadores1.begin()[0] = {"Ana", 200};
    jogadores1.begin()[1] = {"Bea", 150};
    jogadores1.begin()[2] = {"Cia", 180};
    
    // Ordena os jogadores por pontuação usando um lambda como critério de comparação
    std::ranges::sort(jogadores1, [](const Jogador1& a, const Jogador1& b) {
        return a.pontuacao < b.pontuacao;
    });
    std::cout << "Jogadores ordenados por pontuação:" << std::endl;
    for (const auto& jogador : jogadores1) {
        std::cout << jogador.nome << ": " << jogador.pontuacao << std::endl;
    }

    // Criando um Buffer de Jogadores e ordenando-os por pontuação usando std::ranges e operator<
    Buffer<Jogador2> jogadores2(3);
    jogadores2.begin()[0] = {"João", 100};
    jogadores2.begin()[1] = {"José", 150};
    jogadores2.begin()[2] = {"Joseph", 120};

    // Ordena os jogadores por pontuação usando o operador< definido na struct Jogador2
    // Como parâmetro de comparação, passamos um lambda vazio, indicando que a comparação deve ser feita usando o operador< da struct Jogador2.
    // O terceiro parâmetro é um ponteiro para o membro nome, indicando que a ordenação deve ser feita com base na pontuação dos jogadores.
    std::ranges::sort(jogadores2, {}, &Jogador2::pontuacao);
    std::cout << "Jogadores ordenados por pontuação:" << std::endl;
    for (const auto& jogador : jogadores2) {
        std::cout << jogador.nome << ": " << jogador.pontuacao << std::endl;
    }

    return 0;
}