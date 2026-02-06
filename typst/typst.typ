// --- CONFIGURAÇÕES GLOBAIS ---
// Define o tipo de papel, margens e idioma (para hifenização correta)
#set page(paper: "a4", margin: (x: 2cm, y: 2.5cm))
#set text(
    font: "FreeSans",
    size: 16pt, lang: "pt",
    tracking: 0.01em
)
#set par(
    leading: 1em,
    justify: true,
    first-line-indent: 2em
)

// --- TÍTULO DO DOCUMENTO ---
#align(center)[
  = Meu Guia Pessoal do Typst
  _Criado por: Andre (para o Andre do futuro)_
]

== 1. Setup & Live Preview (Arch Linux)

Para fazer este documento funcionar, eu precisei:
1. Instalar o Typst CLI no Arch: `sudo pacman -S typst`
2. Instalar a extensão "Tinymist" no VS Code.
3. Abrir o arquivo `.typ` (este aqui!).
4. Abrir a paleta de comandos (`Ctrl+Shift+P`) e rodar `Browsing Preview`.
5. Rodar no terminal: `typst watch nome_do_arquivo.typ` para alterar o pdf em tempo real.

---

== 2. Formatação Básica

=== Títulos e Seções
Títulos são feitos com '=' no início da linha.
= \=Título Nível 1 (1 igual)
== \=\=Título Nível 2 (2 iguais)
=== \=\=\=Título Nível 3 (3 iguais)

=== Estilos de Texto
A sintaxe é muito parecida com Markdown.
Este é um texto normal.
- *Isto está em negrito.*
- _Isto está em itálico._
- Este é um link: #link("https://github.com")
- `Este é um código inline.`
- #text(red)[Este texto é vermelho.]

=== Alinhamento
// A função #align() "envolve" o conteúdo que você quer alinhar.
#align(center)[
  Este parágrafo está centralizado.
]

#align(right)[
  Este parágrafo está alinhado à direita.
]

O padrão é alinhado à esquerda.

=== Listas
// Listas são fáceis: '-' para não ordenada, '+' para ordenada.
- Um item
- Outro item
    - Um sub-item (com tab)

+ Primeiro item
+ Segundo item
  + Sub-item ordenado

=== Indentação (Tab)
// Para forçar um espaço horizontal (como um "tab"), use #h()
// "em" é uma unidade de medida relativa ao tamanho da fonte.
#h(2em) Esta linha tem um 'tab' (recuo) no início.

// Você também pode definir um recuo automático para a primeira
// linha de *todos* os parágrafos (estilo livro)
// Adicionando isto no topo do arquivo:
// #set par(first-line-indent: 1.5em)

== 3. Blocos Especiais

=== Imagens
// A função #image() precisa do caminho e pode ter largura/altura.
// #figure() adiciona uma legenda.
#figure(
  image("./bartho.jpg", width: 40%),
  caption: [Um placeholder de imagem.]
)

=== Mostrando Código
// Para mostrar código Typst sem executá-lo, use 3 crases + 'typ'
```typ
// Este código não é executado, apenas mostrado
= Meu Título
*negrito*
```
Para outras linguagens:

```cpp
#include <iostream>
int main() {
  std::cout << "C++ também funciona!" << std::endl;
  return 0;
}
```

== 4. O Poder: Matemática

// O modo matemático é iniciado e terminado com '$'.
// Dica: Use '$ ... $' (com espaços) para modo de bloco (display).

=== Fórmulas Básicas
Fórmula inline: $E = m c^2$.
Fórmula em bloco (centralizada):
$  integral_0^infinity e^(-x^2) d x = sqrt(pi) / 2$

=== Símbolos e Atalhos Comuns
- *Frações:* `frac(a, b)` -> $frac(1, 2)$
- *Raiz:* `sqrt(x)` -> $sqrt(16) = 4$
- *Sub/Sup:* `x_1^2` -> $x_1^2$
- *Letras Gregas:* `alpha, beta, sum, Pi` -> $alpha, beta, sum, Pi, pi$
- *Infinito:* `infinity` -> $infinity$
- *Bi-implicação:* `A <=> B` -> $A <=> B$
- *Ortogonalidade:* `A perp B` -> $A perp B$

=== Vetores
// Use a função `vec()`
#align(center)[
    `vec(a) = (a_1, a_2, a_3)`
]
$  vec(a) = (a_1, a_2, a_3) $

// Use `arrow()` para a seta em cima
$  arrow(A B) $

=== Matrizes
// Use a função `mat()`
$
    M = mat(
        delim: "[",
        1, 2, 3;
        4, 5, 6;
        7, 8, 9
    )
$
=== Sistemas de Equações
// Use a função `cases()`.
// O '&' alinha as equações.
$
  cases(
    x + y &= 5,
    2x - y &= 1
  )
$