#include <iostream>
#include <CLI11.hpp>
#include <filesystem>

int main(int argc, char* argv[]) {
    // Cria um objeto CLI::App com uma descrição do programa
    CLI::App app{"CLI11 Example"};

    std::string file;
    std::string output = "./output.txt";
    bool verbose = false;

    // Adiciona uma opção para especificar o arquivo a ser processado
    // A opção pode ser especificada usando -f, --file ou apenas o nome do arquivo
    auto fileopt = app.add_option("file,-f,--file", file, "Specify the file to process");
    // Define a opção de arquivo como obrigatória
    fileopt->required();
    // Adiciona uma validação para verificar se o arquivo especificado existe
    // usando um validador interno do CLI11
    fileopt->check(CLI::ExistingFile);

    // Adiciona uma opção para especificar o arquivo de saída
    // A opção pode ser especificada usando -o, --output ou apenas o nome do arquivo
    // Como foi chamado depois da opção de arquivo, ela será processada depois da opção de arquivo
    // se passada de forma posicional, ou seja, sem o -o ou --output
    auto outputopt = app.add_option("output,-o,--output", output, "Specify the output file");
    // Adiciona uma validação customizada para verificar se o diretório pai do arquivo de saída existe
    outputopt->check([](const std::string &filename) -> std::string {
        std::filesystem::path path(filename);
        if (path.has_parent_path()) {
            std::filesystem::path parent = path.parent_path();
            if (!std::filesystem::exists(parent)) {
                return "Parent directory does not exist: " + parent.string();
            }
        }
        return "";
    });

    // Adiciona uma flag para habilitar a saída detalhada
    app.add_flag("-v,--verbose", verbose, "Enable verbose output");

    // Adiciona uma opção para especificar um arquivo de configuração .toml ou .ini,
    // o arquivo de configuração deve conter as opções do programa e será processado antes das opções da linha de comando
    app.set_config("-c,--config", "Specify a configuration file to load options from");

    // Inicia o parsing dos argumentos da linha de comando
    CLI11_PARSE(app, argc, argv);

    if (verbose) {
        std::cout << "Argumentos: " << std::endl;
        for (int i = 0; i < argc; i++) {
            std::cout << "Argumento " << i << ": " << argv[i] << std::endl;
        }
    }

    std::cout << "Arquivo: " << file << std::endl;
    std::cout << "Arquivo de saída: " << output << std::endl;

    return 0;
}