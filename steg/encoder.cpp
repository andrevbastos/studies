#include <iostream>
#include <fstream>
#include <vector>
#include <filesystem>

int main(int argc, char* argv[]) {
    if (argc < 3) {
        std::cerr << "Uso: " << argv[0] << " <arquivo.bmp> <arquivo.txt> | <mensagem>" << std::endl;
        return 1;
    }

    auto file = std::ifstream(argv[1], std::ios::binary);
    if (!file) {
        std::cerr << "Erro ao abrir o arquivo." << std::endl;
        return 1;
    }

    file.seekg(10);
    std::vector<char> header_size_data(4);
    file.read(header_size_data.data(), 4);
    uint header_size = *reinterpret_cast<int*>(header_size_data.data());
    file.seekg(0);

    std::vector<char> header(header_size);
    file.read(header.data(), header_size);

    auto curr = file.tellg();
    auto size = file.seekg(0, std::ios::end).tellg();
    std::vector<char> pixels(size - curr);

    file.seekg(curr);
    file.read(pixels.data(), pixels.size());
    file.close();
    
    std::string message;
    if (std::filesystem::path(argv[2]).extension() == ".txt") {
        std::ifstream text_file(argv[2]);
        if (!text_file) {
            std::cerr << "Erro ao abrir o arquivo de texto." << std::endl;
            return 1;
        }
        std::string line;
        while (std::getline(text_file, line)) {
            message += line + '\n';
        }
        text_file.close();
        message = message.substr(0, message.size() - 1);
    } else {
        message = argv[2];
    }

    message += '\0';
    
    uint p = 0;
    for (char m : message) {
        for (int i = 7; i >= 0; --i) {
            bool bit = (m >> i) & 1;
            pixels[p] = (pixels[p] & 0b11111110) | bit;
            p++;
        }
    }

    std::ofstream output("output.bmp", std::ios::binary);
    output.write(header.data(), header.size());
    output.write(pixels.data(), pixels.size());
    output.close();

    return 0;
}