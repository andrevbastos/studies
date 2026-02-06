#set page(paper: "a4", margin: (x: 2cm, y: 2.5cm))
#set text(
  font: "FreeSans",
  size: 12pt, lang: "pt",
  tracking: 0.01em
)

#show raw.where(block: true): it => rect(
  fill: rgb("#E5E4E2"),
  radius: 4pt,
  width: 100%,
  inset: 12pt,
  it
)

#align(center)[
  #text(size: 24pt, weight: "bold")[JSON com C++]
]

#line(length: 100%)

= Configuração (CMake)
Para projetos modernos, recomenda-se o uso de `FetchContent`.
_Nota: Certifique-se de usar a versão `v3.11.3` ou superior para compatibilidade com CMake recente._

```cmake
include(FetchContent)
FetchContent_Declare(
  nlohmann_json
  GIT_REPOSITORY [https://github.com/nlohmann/json.git](https://github.com/nlohmann/json.git)
  GIT_TAG v3.11.3
)
FetchContent_MakeAvailable(nlohmann_json)
target_link_libraries(seu_alvo PRIVATE nlohmann_json::nlohmann_json)
```

= Sintaxe Básica 
A classe nlohmann::json funciona de forma semelhante a um std::map.
```cpp
#include <nlohmann/json.hpp>
using json = nlohmann::json;

// Criação e Atribuição
json j;
j["nome"] = "Gerenciador TUI";
j["versao"] = 1.0;
j["tags"] = {"cli", "c++20"}; // Listas automáticas
```

= Persistência (I/O) 
A biblioteca utiliza os fluxos padrão (std::fstream) para leitura e escrita, facilitando o sistema de Save/Load.

== Salvar em Arquivo (Dump)
```cpp
std::ofstream arquivo("dados.json");
// O argumento '4' ativa o "pretty print" com indentação
arquivo << j.dump(4);
arquivo.close();
```

== Carregar do Arquivo (Parse)
```cpp
std::ifstream arquivo("dados.json");
json j_lido;
arquivo >> j_lido; // Parse direto do fluxo
```

= Serialização de Estruturas 
Podemos converter structs C++ diretamente para JSON e vice-versa sem código repetitivo (boilerplate), usando macros especiais.

Defina sua estrutura e use a macro NLOHMANN_DEFINE_TYPE_NON_INTRUSIVE logo em seguida.
```cpp
struct Tarefa {
    int id;
    std::string titulo;
    bool concluida;
};

// Mapeia os campos da struct para chaves JSON
NLOHMANN_DEFINE_TYPE_NON_INTRUSIVE(Tarefa, id, titulo, concluida);
```

== Conversão Automática 
Uma vez definida a macro, a atribuição é direta:
```cpp
// C++ -> JSON
Tarefa t = {1, "Aprender Typst", true};
json j = t; 

// JSON -> C++
Tarefa t_nova = j.get<Tarefa>();
```

#pagebreak()

= Coleções
A biblioteca se integra perfeitamente com contêineres padrão como std::vector.
```cpp
std::vector<Tarefa> lista = {
    {1, "Configurar CMake", true},
    {2, "Criar UI", false}
};

// Serializa o vetor inteiro para um array JSON
json j_lista = lista;

// Deserializa de volta para vetor
auto lista_carregada = j_lista.get<std::vector<Tarefa>>();
```

= Robustez e Segurança
Para evitar que o programa feche abruptamente (crash) devido a dados ruins, utilizamos mecanismos de defesa.

== Tratamento de Exceções (Parse Error)
Se o arquivo JSON estiver corrompido (ex: faltar uma chave), a biblioteca lança uma exceção `json::parse_error`. Devemos capturá-la:

```cpp
try {
    std::ifstream f("config.json");
    json j = json::parse(f);
} catch (json::parse_error& e) {
    // e.what() descreve o erro e a posição (byte)
    std::cerr << "Arquivo corrompido: " << e.what() << '\n';
}
```

== Valores Padrão e Verificação 
Nunca assuma que uma chave existe. O acesso direto j["chave"] pode criar dados indesejados ou falhar.

1. Usar valor padrão: Retorna o valor se existir, ou um padrão se não.
```cpp
// Se "timeout" não existir, usa 5000
int t = config.value("timeout", 5000);
```
2. Verificar existência: Use contains() para checar antes de acessar.
```cpp
if (config.contains("admin_mode")) {
    // Lógica segura aqui...
}
```

#pagebreak()

