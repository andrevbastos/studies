#include <iostream>
#include <iomanip>

// argc (argument count): um inteiro que representa o número de argumentos passados, incluindo o nome do programa.
// argv (argument vector): um array de strings que contém os argumentos passados para o programa.
int main(int argc, char* argv[]) {
    std::cout << "Número de argumentos: " << argc << std::endl;
    for (int i = 0; i < argc; i++) {
        std::cout << "Argumento " << i << ": " << argv[i] << std::endl;
    }

    std::string file;

    for (int i = 0; i < argc; i++) {
        auto arg = std::string(argv[i]);

        // Verifica se o usuário solicitou ajuda.
        if (arg == "-h" || arg == "--help") {
            std::cout << "Uso: " << argv[0] << " [opções]" << std::endl;
            std::cout << "Opções:" << std::endl;
            std::cout << "\t-h, --help" << std::setw(15) << "Exibe esta mensagem de ajuda" << std::endl;
            std::cout << "\t-f, --file" << std::setw(15) << "Especifica o arquivo a ser processado" << std::endl;
            return 0;
        }

        // Verifica se o usuário especificou um arquivo.
        // O usuário pode especificar o arquivo de duas maneiras:
        // 1. Usando a opção -f ou --file seguida do nome do arquivo.
        // 2. Usando a opção -f= ou --file= seguida do nome do arquivo.
        if (arg == "-f" || arg == "--file") {
            if (i + 1 >= argc) {
                std::cerr << "Erro: Nenhum arquivo especificado após a opção -f/--file." << std::endl;
                return 1;
            }
            file = argv[i + 1];
            i++;
        }
        if (arg.starts_with("-f=") || arg.starts_with("--file=")) {
            file = arg.substr(arg.find('=') + 1);
        }
    }
    
    if (file.empty()) {
        std::cerr << "Erro: Nenhum arquivo especificado. Use -f ou --file para especificar um arquivo." << std::endl;
        return 1;
    }
    std::cout << "Arquivo: " << file << std::endl;

    return 0;
}