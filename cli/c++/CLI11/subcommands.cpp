#include <iostream>
#include <CLI11.hpp>
#include <filesystem>

int main(int argc, char* argv[]) {
    // Cria um objeto CLI::App com uma descrição do programa
    CLI::App app{"CLI11 Example"};

    std::string file;
    bool fast_mode = false;

    // Cria um subcomando chamado "analyse" com uma descrição
    auto cmd_analyse = app.add_subcommand("analyse", "Analyse a file");

    cmd_analyse->add_option("file,-f,--file", file, "Specify the file to analyse")->check(CLI::ExistingFile)->required();

    // Adiciona uma flag que existe apenas no subcomando "analyse"
    cmd_analyse->add_flag("--fast", fast_mode, "Enable fast mode");

    // Inicia o parsing dos argumentos da linha de comando
    CLI11_PARSE(app, argc, argv);

    // Verifica se o subcomando "analyse" foi chamado e se a flag "--fast" foi ativada
    if (cmd_analyse->parsed()) {
        std::cout << "Arquivo: " << file << std::endl;
        std::cout << "Iniciando análise..." << std::endl;
        if (fast_mode) {
            std::cout << "Modo rápido ativado." << std::endl;
        }
    }

    return 0;
}