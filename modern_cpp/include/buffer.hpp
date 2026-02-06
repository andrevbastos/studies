#pragma once
#include <algorithm>

// Exemplo de classe para demonstrar Templates
template<typename T>
class Buffer {
    T* data;
    size_t size;
public:
    // No C++20, dentro do escopo da própria classe, o nome do construtor/destrutor deve ser apenas o nome da classe, sem o <T>.
    Buffer(size_t s);
    ~Buffer();

    // Enquanto nos parâmetros do construtor e do operador de atribuição, 
    // o tipo completo Buffer<T> é necessário para evitar ambiguidade.
    Buffer(const Buffer<T>& other);

    Buffer(Buffer<T>&& other) noexcept;

    Buffer& operator=(Buffer<T> other) noexcept;

    // Métodos para acessar os dados do buffer
    const T* begin() const;
    const T* end() const;

    // Versões não-const para permitir modificação dos dados
    T* begin();
    T* end();
};

// Implementação dos métodos da classe Buffer com template
template<typename T>
Buffer<T>::Buffer(size_t s) : size(s), data(new T[s]) {}

template<typename T>
Buffer<T>::~Buffer() { delete[] data; }

template<typename T>
Buffer<T>::Buffer(const Buffer<T>& other) 
    : size(other.size), data(new T[other.size]) {
        std::copy(other.data, other.data + other.size, this->data);
}

template<typename T>
Buffer<T>::Buffer(Buffer<T>&& other) noexcept 
    : data(nullptr), size(0) {
        std::swap(this->data, other.data);
        std::swap(this->size, other.size);
}

template<typename T>
Buffer<T>& Buffer<T>::operator=(Buffer<T> other) noexcept {
    std::swap(this->data, other.data);
    std::swap(this->size, other.size);
    return *this;
}

template<typename T>
const T* Buffer<T>::begin() const { return data; }

template<typename T>
const T* Buffer<T>::end() const { return data + size; }

template<typename T>
T* Buffer<T>::begin() { return data; }

template<typename T>
T* Buffer<T>::end() { return data + size; }