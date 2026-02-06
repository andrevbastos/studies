#include <iostream>
#include <filesystem>

namespace fs = std::filesystem;

int main() {
    fs::path caminho_fonte = "src/main.cpp";

    std::cout << "Caminho armazenado: " << caminho_fonte << std::endl;
    std::cout << "Nome do arquivo: " << caminho_fonte.filename() << std::endl;
    std::cout << "Nome sem extensão: " << caminho_fonte.stem() << std::endl;
    std::cout << "Extensão do arquivo: " << caminho_fonte.extension() << std::endl;

    fs::path raiz = "/home/andre";
    fs::path projeto = "projects/filesystem";

    fs::path caminho_completo = raiz / projeto; 

    std::cout << "Caminho montado: " << caminho_completo << std::endl;

    fs::path pasta_src = "src";
    pasta_src /= "config.json";

    std::cout << "Caminho montado: " << pasta_src << std::endl;

    fs::path home = fs::path(getenv("HOME"));
    fs::path teste = home / "teste_fs";
    fs::create_directory(teste);
    
    fs::path armazem = "armazem_projetos";
    armazem = teste / armazem;
    fs::create_directory(armazem);
    fs::path alpha = "projeto_alpha";
    alpha = teste / alpha;
    fs::create_directory(alpha);
    fs::create_directory(alpha / "src");
    fs::create_directory(alpha / "include");
    fs::create_directory(alpha / "CMakeFiles.txt");

    fs::create_directory_symlink(alpha, armazem / "link_projeto_alpha");

    for (auto parte : fs::directory_iterator(armazem)) {
        if (parte.is_directory())
            std::cout << "[DIR] " << parte.path().filename() << std::endl;
        else
            std::cout << "[ARQ] " << parte.path().filename() << std::endl;
    }

    std::cout << std::endl;

    for (auto parte : fs::recursive_directory_iterator(teste)) {
        if (parte.is_directory())
            std::cout << "[DIR] " << parte.path().filename() << std::endl;
        else
            std::cout << "[ARQ] " << parte.path().filename() << std::endl;
    }

    std::cout << std::endl;

    fs::path backup = teste / "backup_projetos";
    fs::create_directory(backup);
    fs::rename(alpha, backup / "alpha_backup");
    for (auto parte : fs::recursive_directory_iterator(backup)) {
        if (parte.is_directory())
            std::cout << "[DIR] " << parte.path().filename() << std::endl;
        else
            std::cout << "[ARQ] " << parte.path().filename() << std::endl;
    }

    fs::remove_all(teste);

    return 0;
}