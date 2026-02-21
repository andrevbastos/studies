#set page(
  paper: "a4",
  margin: (top: 3cm, left: 3cm, right: 2cm, bottom: 2cm)
)
#set text(
  font: "Libertinus Serif",
  size: 12pt, lang: "pt",
  tracking: 0.01em
)

#show heading.where(level: 1): it => {
  set text(fill: navy)
  stack(
    dir: ttb,
    it,
    v(0.5em),
    line(length: 100%, stroke: 1pt + navy),
  )
}

#show raw: set text(font: "JetBrainsMonoNL NF", size: 10pt)
#show raw.where(block: true): it => {
  block(
    fill: luma(240),
    inset: 10pt,
    radius: 4pt,
    width: 100%,
    stroke: 0.5pt + luma(200),
    it
  )
}

#show figure: set block(spacing: 2em)
#show figure.caption: set text(size: 0.9em, style: "italic")

#let nota(cor: blue, corpo) = {
  block(
    fill: cor.lighten(90%),
    stroke: (left: 4pt + cor),
    inset: (x: 10pt, y: 8pt),
    width: 100%,
    corpo
  )
}

// ==================================================================
//                               CAPA
// ==================================================================

#align(center)[
  #upper[Instituto Federal Catarinense] \
  #upper[Bacharelado de Ciência da Computação] \
]

#v(1fr) 

#align(center)[
  #text(size: 16pt, weight: "bold")[C++] \
  #text(size: 12pt, weight: "light")[Guia de Estudo Completo]
]

#v(1fr) 

#align(right)[
  #box(width: 50%, align(left)[
    #text(size: 10pt)[André Vitor Bastos de Macêdo]
  ])
]

#v(1fr) 

#align(center)[
  Blumenau - SC \
  2026
]

#pagebreak()

// ==================================================================
//                               ÍNDICE
// ==================================================================

#set heading(numbering: "1.1.1")
#outline(
  title: [Sumário],
  indent: auto
)

#pagebreak()

// ==================================================================
//                              CONTEÚDO
// ==================================================================

= Tipos e Variáveis
== Tipos Primitivos e Modificadores
== Variáveis, Constantes e constexpr
=== Inicialização Uniforme
Antes do C++11, inicializar variáveis era uma confusão: usávamos parênteses `()`, sinal de igual `=` ou listas de inicialização para agregados. A inicialização com chaves `{}` veio para unificar isso e resolver problemas clássicos, como o "Most Vexing Parse" (quando o compilador confunde a declaração de uma variável com a declaração de uma função).

```cpp
int temp_A = 36.6; // Estilo antigo
int temp_B{36.6};  // Inicialização Uniforme (C++ Moderno)
```

#nota(cor: red)[
  *Aviso de Segurança: Narrowing Conversions* \
  No estilo antigo com `=`, o compilador realiza uma conversão implícita (truncando o valor decimal para caber no `int`). Isso acontece silenciosamente e pode gerar bugs.
  Com a Inicialização Uniforme `{}`, o compilador é rigoroso: se o valor não couber perfeitamente no tipo (como um `double` em um `int`), ele emitirá um erro, impedindo o código de compilar com um valor corrompido.
]

=== A palavra-chave `auto`
O C++ Moderno introduziu a palavra-chave `auto` para dedução de tipos pelo compilador. Porém, há uma armadilha ao misturar `auto` com chaves `{}`:

```cpp
auto var1 = 10;   // Deduzido como int
auto var2{10};    // Deduzido como int
auto var3 = {10}; // Cuidado: deduzido como std::initializer_list<int>!
```
O tipo `std::initializer_list<T>` serve como uma "ponte" temporária para containers, capaz de ser transicionada para diferentes estruturas de dados.

=== Structured Bindings (C++17)
Permite extrair múltiplos retornos ou desempacotar estruturas diretamente em variáveis individuais, de forma muito limpa.

```cpp
struct Config { int id; float sens; };

Config c{10, 0.99f};
auto [id, sens] = c; // 'id' recebe 10, 'sens' recebe 0.99
```
O número de identificadores nos colchetes deve ser exatamente igual ao número de membros não estáticos da `struct`.

== Tipos Compostos 
=== Arrays
=== Enums
== Strings
== Entrada e Saída

= Operadores e Controle de Fluxo
== Operadores
=== Aritméticos
=== Lógicos
=== Bitwise
== Estruturas Condicionais
== Laços de Repetição
== Tratamento de Exceções

= Funções e Organização de Código
== Definição, Escopo e Visibilidade
== Passagem de Parâmetros
=== Valor
=== Referência
=== Ponteiro

== Retornos de Função e std::optional
No C++ antigo, ao falhar uma busca, retornávamos um ponteiro nulo (`nullptr`) ou um valor sentinela (como `-1`). Com o C++17, ganhamos o `std::optional<T>`. Ele encapsula a possibilidade de "ter um valor" ou "estar vazio".

```cpp
#include <optional>
#include <vector>

struct Config { int id; float sensitivity; };

std::optional<Config> buscar_por_id(const std::vector<Config>& lista, int id_procurado) {
    for (const auto& item : lista) {
        if (item.id == id_procurado) return item;
    }
    return std::nullopt; // Retorna "vazio"
}

// Uso:
auto resultado = buscar_por_id(configs, 2);
if (resultado) { // Pode ser checado como um booleano
    std::cout << resultado->sensitivity; // Acesso via operador seta
}
```
O `std::optional` se comporta intuitivamente como um ponteiro inteligente, mas com a segurança de que reside no _stack_ e não no _heap_.

== Recursividade
== Sobrecarga de Funções e Inline
== Funções Lambda e Callbacks

Funções lambda são funções anônimas que podemos definir dentro do próprio código, frequentemente usadas com algoritmos da STL.

*Anatomia Básica:* `[captura] (parâmetros) { corpo; }`

```cpp
#include <algorithm>
#include <vector>

auto list = {10, 20, 30, 40};
auto limit = 25;

// Passando um lambda para o std::for_each
std::for_each(list.begin(), list.end(), [limit](int value) {
    if (value > limit) {
        std::cout << value << std::endl;
    }
});
```

*Tipos de Captura:*
- `[]`: Captura nada.
- `[limit]`: Captura por valor. Faz uma cópia da variável local no momento da criação da lambda.
- `[&limit]`: Captura por referência. Acessa a variável original.
- `[=]` / `[&]`: Captura tudo o que for necessário do escopo externo por valor ou por referência, respectivamente.

= O Modelo de Memória do C++
== Stack vs Heap
== Alocação Estática, Automática e Dinâmica
== Ciclo de Vida de Objetos e Escopo
== Fragmentação e Performance de Cache

= Ponteiros e Referências
== Ponteiros Simples e Aritmética de Ponteiros
== Referências
== Ponteiros para Funções e Membros
== Ponteiros Nulos e nullptr
== Type Casting

= Gerenciamento de Recursos
== O Conceito de RAII
Resource Acquisition Is Initialization (RAII) é a base do gerenciamento seguro no C++.

#nota(cor: green)[
  *Regra de Ouro do C++ Moderno:* \
  Nunca use `new` ou `delete` manualmente no seu código de alto nível. Deixe que as abstrações (Smart Pointers e Containers) gerenciem isso para você.
]

== Gerenciamento Manual
== Ponteiros Inteligentes
Os Smart Pointers automatizam o gerenciamento de memória baseando-se no escopo (RAII). Os principais são:

1. `std::unique_ptr<T>`: Propriedade exclusiva. Ninguém mais pode apontar para o recurso. Quando sai de escopo, o recurso é destruído automaticamente. É "grátis" em termos de performance.
   
```cpp
auto motor = std::make_unique<Motor>();
// auto motor2 = motor; 
// ERRO! Não pode ser copiado.
auto motor2 = std::move(motor); 
// Correto: a posse foi transferida. motor agora é nullptr.
```

2. `std::shared_ptr<T>`: Propriedade compartilhada. Mantém um bloco de controle (Control Block) com um contador de referências. O recurso só morre quando o último ponteiro for destruído (contador chega a zero).

*O problema da Referência Circular:* Se um objeto A tem um `shared_ptr` para B, e B tem um `shared_ptr` para A, nenhum dos dois será destruído, causando um _Memory Leak_.

3. `std::weak_ptr<T>`: A solução para a referência circular. Ele observa um `shared_ptr`, mas não incrementa o contador de referências. Para acessar o valor, você deve "promovê-lo" temporariamente usando `lock()`, garantindo _Thread Safety_.

== Movimentação de Recursos (Move Semantics)

Para entender a movimentação, precisamos diferenciar:
- *Lvalue:* Tem nome e endereço de memória fixo (ex: uma variável `x`).
- *Rvalue:* É temporário, prestes a evaporar (ex: resultado de `10 + 20` ou retorno de uma função).

O *Move Constructor* permite "roubar" os recursos de um Rvalue (objeto temporário) em vez de fazer uma cópia custosa.

```cpp
class Buffer {
    int* data;
    size_t size;
public:
    // Construtor de Cópia Tradicional (Custa caro)
    Buffer(const Buffer& other) { /* Aloca nova memória e copia os dados */ }

    // Construtor de Movimento (Rápido)
    Buffer(Buffer&& other) noexcept {
        this->size = other.size;
        this->data = other.data;  // "Rouba" o ponteiro
        
        other.size = 0;
        other.data = nullptr;     // Fundamental: anula o original para evitar Double Free
    }
};
```
Ao definir `other.data = nullptr`, garantimos que quando o objeto temporário for destruído, o seu destrutor chamará `delete[] nullptr` (o que é seguro e não faz nada).

*O Idioma Copy-and-Swap:*
Uma forma mais elegante e segura contra exceções de implementar a cópia e o movimento é usando `std::swap`:

```cpp
Buffer(Buffer&& other) noexcept : data(nullptr), size(0) {
    std::swap(this->data, other.data);
    std::swap(this->size, other.size);
}

Buffer& operator=(Buffer other) noexcept { // Recebe por valor (cópia ou movido)
    std::swap(this->data, other.data);
    std::swap(this->size, other.size);
    return *this;
}
```

= Orientação a Objetos
== Encapsulamento e Modificadores de Acesso
== Construtores, Destrutores e a "Rule of Five"
== Herança e Polimorfismo
== Funções Virtuais e Classes Abstratas
== Sobrecarga de Operadores

= Programação Genérica
== Templates de Função
O Template funciona como um molde. Você escreve uma receita para o compilador, e o código real só é "fabricado" quando você o utiliza com um tipo específico.

```cpp
template <typename T>
T somar(T a, T b) {
    return a + b;
}

auto r1 = somar<int>(5, 10);      // Compilador gera a versão 'int'
auto r2 = somar<double>(5.5, 2.1); // Compilador gera a versão 'double'
auto r3 = somar(1, 2);            // O compilador deduz que é 'int'
```

== Templates de Classe
A mesma lógica se aplica a classes, como na criação de estruturas de dados genéricas.

```cpp
template<typename T>
class Buffer {
    T* data;
    size_t size;
public:
    Buffer(size_t s);
    ~Buffer();
    // ... construtores, begin(), end() ...
};

template<typename T>
Buffer<T>::Buffer(size_t s) : size(s), data(new T[s]) {}
```

#nota(cor: orange)[
  *Atenção à Organização de Arquivos:* \
  Diferente de classes normais, você *não pode* colocar a declaração no `.hpp` e a implementação no `.cpp`. Como o compilador precisa gerar o código sob demanda, ele precisa enxergar a implementação completa. Implemente templates inteiramente no arquivo de cabeçalho (`.hpp` ou `.h`).
]

== Especialização de Templates

= STL (Standard Template Library)
== Containers
== Iteradores e sua importância
Para que uma classe customizada funcione com os for-loops baseados em range (`for (auto x : buffer)`), ela deve implementar as funções `begin()` e `end()`.

```cpp
template<typename T> T* Buffer<T>::begin() { return data; }
template<typename T> T* Buffer<T>::end() { return data + size; }
```

== Algoritmos e Ranges (C++20)
No C++20, um _Range_ é essencialmente qualquer coisa que possua um `begin()` e um `end()`. Isso simplificou drasticamente o uso dos algoritmos da STL.

```cpp
// Como era antes (C++11/14/17):
std::reverse(buffer.begin(), buffer.end());

// Como é agora (C++20 Ranges):
std::ranges::reverse(buffer);
```

Para ordenar estruturas complexas (como um vetor de `Jogador`), temos duas abordagens principais: usando funções Lambda ou sobrecarregando o `operator<`.

```cpp
struct Jogador {
    std::string nome;
    int pontuacao;
    
    // Caminho 1: Implementando o operator<
    bool operator<(const Jogador& other) const {
        return pontuacao < other.pontuacao;
    }
};

std::vector<Jogador> jogadores = {{"A", 200}, {"B", 150}, {"C", 180}};

// Usando o operator< (deduzido por padrão)
// O std::ranges pede a struct, uma projeção vazia {}, e o membro a comparar
std::ranges::sort(jogadores, {}, &Jogador::pontuacao);

// Caminho 2: Usando Lambda (mais flexível para contextos locais)
std::ranges::sort(jogadores, [](const Jogador& a, const Jogador& b) {
    return a.pontuacao < b.pontuacao;
});
```

== Functors e Predicados