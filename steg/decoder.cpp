#include <iostream>
#include <fstream>
#include <vector>

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cerr << "Uso: " << argv[0] << " <arquivo.bmp>" << std::endl;
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

    auto curr = file.seekg(header_size).tellg();
    auto size = file.seekg(0, std::ios::end).tellg();
    std::vector<char> pixels(size - curr);
    file.seekg(curr);
    file.read(pixels.data(), pixels.size());
    file.close();

    std::string extracted_message;
    uint p = 0;

    while (true) {
        char extracted_char = 0;
        for (int i = 7; i >= 0; --i) {
            bool bit = pixels[p] & 1;
            extracted_char = (extracted_char << 1) | bit;
            p++;
        }
        if (extracted_char == '\0') break;
        extracted_message += extracted_char;
    }

    std::cout << "Mensagem extraída: " << extracted_message << std::endl;

    return 0;
}