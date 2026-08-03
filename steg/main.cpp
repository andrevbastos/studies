#include <iostream>
#include <fstream>
#include <vector>

int main() {
    // 1. I/O Binário

    // Lê os bytes de um arquivo BMP (Bitmap), sem interpretar o conteúdo.
    auto file = std::ifstream("image.bmp", std::ios::binary);
    if (!file) {
        std::cerr << "Erro ao abrir o arquivo." << std::endl;
        return 1;
    }

    // Lê o tamanho do cabeçalho do arquivo BMP (em bytes) do offset 10 até 13.
    file.seekg(10);
    std::vector<char> header_size_data(4);
    file.read(header_size_data.data(), 4);
    uint header_size = *reinterpret_cast<int*>(header_size_data.data());
    file.seekg(0);
    
    // Lê os primeiros header_size bytes do arquivo BMP (cabeçalho).
    // Com isso o ponteiro de leitura do arquivo avança 54 bytes,
    // restando apenas a matriz de pixels para ser lida.
    std::vector<char> header(header_size);
    file.read(header.data(), header_size);

    // Lê o restante do arquivo (matriz de pixels).    
    // Descobrimos onde o ponteiro de leitura está atualmente, e qual é o tamanho do arquivo,
    // então podemos calcular quantos bytes restam para serem lidos e redimensionar o vetor de pixels.
    auto curr = file.tellg();
    auto size = file.seekg(0, std::ios::end).tellg();
    std::vector<char> pixels(size - curr);
    file.seekg(curr);
    file.read(pixels.data(), pixels.size());
    file.close();

    // 2. Operações Bitwise
    
    // Pega um pixel e realiza operações bitwise para manipular seus bits.
    // Cria uma máscara para limpar o bit menos significativo (LSB) do pixel
    // e depois o define como o valor alvo.
    unsigned char pixel = 0b10101011;
    pixel = pixel & 0b11111110;
    
    unsigned char target = 1;
    pixel = pixel | target;

    // Converte um caractere em bits e armazena em um vetor de booleanos
    char c = 'A';
    std::vector<bool> bits;
    for (int i = 7; i >= 0; --i) {
        bits.push_back((c >> i) & 1);
    }

    // 3. Steganography

    // Nossa mensagem secreta será armazenada nos bits menos significativos (LSB) dos pixels da imagem.
    // Adiciona um caractere nulo ao final da mensagem para indicar o fim da mensagem.
    std::string message = "Mensagem secreta!";
    message += '\0';
    
    // Itera sobre cada caractere da mensagem e cada bit do caractere, e armazena o bit no LSB do pixel correspondente.
    uint p = 0;
    for (char m : message) {
        for (int i = 7; i >= 0; --i) {
            bool bit = (m >> i) & 1;
            pixels[p] = (pixels[p] & 0b11111110) | bit;
            p++;
        }
    }

    // 4. Encoding

    std::ofstream output("output.bmp", std::ios::binary);
    output.write(header.data(), header.size());
    output.write(pixels.data(), pixels.size());
    output.close();

    // 5. Deconding
    auto output_file = std::ifstream("output.bmp", std::ios::binary);
    if (!output_file) {
        std::cerr << "Erro ao abrir o arquivo de saída." << std::endl;
        return 1;
    }

    auto out_curr = output_file.seekg(header_size).tellg();
    auto out_size = output_file.seekg(0, std::ios::end).tellg();
    std::vector<char> output_pixels(out_size - out_curr);
    output_file.seekg(out_curr);
    output_file.read(output_pixels.data(), output_pixels.size());
    output_file.close();

    // Extrai a mensagem escondida nos bits menos significativos (LSB) dos pixels da imagem.
    std::string extracted_message;
    uint q = 0;

    while (true) {
        char extracted_char = 0;
        for (int i = 7; i >= 0; --i) {
            bool bit = output_pixels[q] & 1;
            extracted_char = (extracted_char << 1) | bit;
            q++;
        }
        if (extracted_char == '\0') break;
        extracted_message += extracted_char;
    }

    std::cout << "Mensagem extraída: " << extracted_message << std::endl;

    return 0;
}