// --- CONFIGURAÇÕES GLOBAIS ---
// Define o tipo de papel, margens e idioma (para hifenização correta)
#set page(paper: "a4", margin: (x: 2cm, y: 2.5cm))
#set text(
  font: "Arial",
  size: 16pt, lang: "pt",
  tracking: 0.01em
)
#set par(
  leading: 1em,
  justify: true,
  first-line-indent: 2em
)
1
// --- TÍTULO DO DOCUMENTO ---
#align(center)[
  = Typst
]

#line(length: 100%) 

#set heading(numbering: "1.")
#set math.equation(numbering: "1.")

= Setup & Live Preview (Arch Linux)

Para fazer este documento funcionar, eu precisei:
1. Instalar o Typst CLI no Arch: `sudo pacman -S typst`
2. Instalar a extensão "Tinymist" no VS Code.
3. Abrir o arquivo `.typ` (este aqui!).
4. Abrir a paleta de comandos (`Ctrl+Shift+P`) e rodar `Browsing Preview`.
5. Rodar no terminal: `typst watch nome_do_arquivo.typ` para alterar o pdf em tempo real.

#pagebreak()

= Formatação Básica

== Títulos e Seções

#set heading(numbering: none)
Títulos são feitos com '=' no início da linha.
= \=Título Nível 1 (1 igual)
== \=\=Título Nível 2 (2 iguais)
=== \=\=\=Título Nível 3 (3 iguais)
#set heading(numbering: "1.")

== Estilos de Texto
A sintaxe é muito parecida com Markdown.
Este é um texto normal.
- *Isto está em negrito.*
- _Isto está em itálico._
- Este é um link: #link("https://github.com")
- `Este é um código inline.`
- #text(red)[Este texto é vermelho.]

== Alinhamento
// A função #align() "envolve" o conteúdo que você quer alinhar.
#align(center)[
  Este parágrafo está centralizado.
]

#align(right)[
  Este parágrafo está alinhado à direita.
]

O padrão é alinhado à esquerda.

== Listas
// Listas são fáceis: '-' para não ordenada, '+' para ordenada.
- Um item
  - Um sub-item (com tab)

+ Primeiro item
+ Segundo item
  + Sub-item ordenado

== Indentação (Tab)
// Para forçar um espaço horizontal (como um "tab"), use #h()
// "em" é uma unidade de medida relativa ao tamanho da fonte.
#h(2em) Esta linha tem um 'tab' (recuo) no início.

// Você também pode definir um recuo automático para a primeira
// linha de *todos* os parágrafos (estilo livro)
// Adicionando isto no topo do arquivo:
// #set par(first-line-indent: 1.5em)

#pagebreak()

= Blocos Especiais

== Imagens
// A função #image() precisa do caminho e pode ter largura/altura.
// #figure() adiciona uma legenda.
#figure(
  image("./bartho.jpg", width: 40%),
  caption: [Um placeholder de imagem.]
)

== Mostrando Código
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

#pagebreak()

= Matemática

// O modo matemático é iniciado e terminado com '$'.
// Dica: Use '$ ... $' (com espaços) para modo de bloco (display).

== Fórmulas Básicas
Fórmula inline: $E = m c^2$.
Fórmula em bloco (centralizada):
$  integral_0^infinity e^(-x^2) d x = sqrt(pi) / 2$

== Símbolos e Atalhos Comuns
- *Frações:* `frac(a, b)` -> $frac(1, 2)$
- *Raiz:* `sqrt(x)` -> $sqrt(16) = 4$
- *Sub/Sup:* `x_1^2` -> $x_1^2$
- *Letras Gregas:* `alpha, beta, sum, Pi` -> $alpha, beta, sum, Pi, pi$
- *Infinito:* `infinity` -> $infinity$
- *Bi-implicação:* `A <=> B` -> $A <=> B$
- *Ortogonalidade:* `A perp B` -> $A perp B$

== Vetores
// Use a função `arrow()`
$ arrow(a) = (a_1, a_2, a_3) \ arrow(A B) $

== Matrizes
// Use a função `mat()`
$
    M = mat(
        delim: "[",
        1, 2, 3;
        4, 5, 6;
        7, 8, 9
    )
$
== Sistemas de Equações
// Use a função `cases()`.
// O '&' alinha as equações.
$
  cases(
    x + y &= 5,
    2x - y &= 1
  )
$

#pagebreak()

= Estrutura e Navegação

== Sumário (Table of Contents)
// Para gerar um sumário automático baseado nos títulos (=, ==, ===)
// O parâmetro 'depth' define até qual nível de título o sumário pega.
#outline(title: "Índice", depth: 1)

== Espaçamento e Quebras
- *Espaço vertical explícito:* `#v(1cm)`
- *Espaço vertical flexível:* `#v(1fr)` (empurra o conteúdo para baixo ocupando o resto da página).
- *Quebra de página:* `#pagebreak()`
- *Quebra de coluna:* `#colbreak()`

== Linhas e Divisórias
// O comando '---' gera uma linha fina, mas #line() te dá controle total.
#line(length: 100%, stroke: 1pt + black)
#line(length: 50%, stroke: 2pt + blue) // Linha azul mais grossa pela metade

== Colunas
// Para dividir um trecho em colunas, use #columns()
#columns(2)[
  O Typst facilita muito trabalhar com múltiplas colunas. O texto flui automaticamente da primeira para a segunda.
  
  #colbreak() // Força o texto a ir para a próxima coluna.
  
  Dá pra colocar equações, imagens e o que quiser dentro das colunas sem quebrar o layout.
]

#pagebreak()

= Tabelas e Grids

== Tabelas Simples
// O parâmetro 'columns' define o tamanho de cada coluna.
// 'auto' ajusta ao conteúdo, '1fr' pega o espaço restante.
#align(center)[
  #table(
    columns: (1fr, auto, auto),
    inset: 10pt,
    align: horizon,
    [*Produto*], [*Qtd*], [*Preço*],
    [Maçã], [3], [R\$ 5,00],
    [Banana], [6], [R\$ 4,50]
  )
]

== Grids (Layout invisível)
// Grids são como tabelas, mas sem bordas por padrão. Excelentes para diagramação paralela.
#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [ *Bloco 1:* Este texto fica na esquerda. Excelente para colocar uma explicação ao lado de uma imagem. ],
  [ *Bloco 2:* Este texto fica na direita, perfeitamente alinhado com o da esquerda. ]
)

#pagebreak()

= Referências e Bibliografia

== Labels e Referências Cruzadas
// Você pode "marcar" títulos, equações, figuras ou tabelas usando <nome>
// E depois referenciar com @nome
= Seção de Exemplo <exemplo>
Como vimos na @exemplo, o Typst gera links clicáveis no PDF automaticamente. 

Você também pode referenciar equações: 

$a^2 + b^2 = c^2$ <pitagoras>

A equação @pitagoras é o Teorema de Pitágoras.

== Bibliografia
// 1. Crie um arquivo .bib (ex: refs.bib) ou .yaml na mesma pasta.
// 2. Cite no texto usando a chave da referência: @einstein1905
// 3. No final do seu documento, chame a bibliografia (descomente abaixo):
Assim é possível referênciar @knuth1984 no texto e depois gerar a bibliografia completa no final do documento.
#bibliography("refs.bib", style: "associacao-brasileira-de-normas-tecnicas")

#pagebreak()

= Programação com \#let

O Typst não é só um formatador de texto, é uma linguagem de programação completa.

== Variáveis
// Salve valores para reutilizar no documento inteiro
#let autor = "Fulano de Tal"
O documento foi escrito por #autor.

== Funções Customizadas (Macros)
// Crie seus próprios comandos de formatação para evitar repetição!
#let alerta(corpo) = rect(
  fill: red.lighten(80%),
  stroke: red,
  radius: 4pt,
  width: 100%,
  [ *Atenção:* #corpo ]
)

#alerta[
  Com as funções, você pode criar caixas de destaque padronizadas para o seu documento inteiro.
]

== Condicionais (If / Else) e Loops (For)
#let nota = 8
O aluno está: #if nota >= 7 [ *Aprovado* ] else [ *Reprovado* ]

// Gerando listas com loop:
#for i in (1, 2, 3) [
  - Item automático #i
]

#pagebreak()

= Refinando Parágrafos (\#par e \#set)

// A diferença entre #set e funções normais:
// #set par(...) muda o comportamento de TODOS os parágrafos seguintes.
// #par(...) aplica a regra APENAS ao bloco que você passar.

#par(justify: false, leading: 2em)[
  Este parágrafo possui regras próprias que ignoram o `#set par` lá do topo do arquivo. Ele não está justificado, e o espaçamento entre as linhas (leading) é gigante apenas para demonstrar o isolamento do comando de formatação local.
]

#pagebreak()

= Regras de Estilo (\#show)

// O comando `#show` é talvez o mais poderoso do Typst.
// Enquanto o `#set` muda as configurações padões de um elemento, 
// o `#show` intercepta e redefine completamente como algo é exibido.

== Substituição de Texto
// Você pode substituir palavras automaticamente no documento todo.
#show "TODO": text(red, weight: "bold")[A FAZER]
Lembre-se de revisar esta seção TODO.

== Estilizando Elementos Específicos
// Exemplo: Fazer com que TODOS os links fiquem azuis sublinhados
#show link: it => underline(text(fill: blue, it))
Visite o #link("https://typst.app")[Site do Typst].

= Cabeçalhos, Rodapés e Páginas

// Você configura isso na regra geral de página. 
// Normalmente isso vai lá no topo do arquivo junto com #set page(...)
```typst
#set page(
  header: align(right)[
    _Meu Documento Typst_
  ],
  footer: align(center)[
    - #counter(page).display("1") -
  ],
  numbering: "1" // Formatos: "1", "a", "A", "i", "I"
)
```

A mensagem de rodapé #footnote[Este é um rodapé de exemplo.] aparece no final da página.

#pagebreak()

= Modularidade (Arquivos Múltiplos)
Quando seu documento ficar gigante, divida-o em pedaços.

== Incluindo Conteúdo
// Pega todo o conteúdo de outro arquivo e "cola" aqui:
```typ
#include "capitulo_1.typ"
```

== Importando Variáveis/Funções
// Se você tem um arquivo "estilos.typ" com seus #let e #set:

```#import "estilos.typ": alerta, autor``` \
Ou importe tudo: \
```#import "estilos.typ": *```

= Pacotes (Typst Universe)

// O Typst tem pacotes criados pela comunidade, parecidos com bibliotecas.
// Você usa o prefixo `@preview` para importá-los via internet 
// (o Typst faz o download automaticamente).
// Exemplo:

```typ
// Pacote excelente para desenhar gráficos e formas
#import "@preview/cetz:0.2.2" 

// Atalhos ótimos para física e matemática
#import "@preview/physica:0.9.3": * 
```

#pagebreak()

= Sintaxe: Detalhes Menores

== Comentários de Bloco
/*
  Este é um comentário de bloco.
  Você pode pular várias linhas
  e nada disso aparecerá no PDF.
*/
```
/*
  Bloco de
  Comentários
*/
```

== Escapando Caracteres Especiais
Se você precisar digitar o símbolo do Hashtag ou o cifrão sem iniciar comandos, use a barra invertida `\`: \
Isto é um cifrão: \$100. \
Isto é um hashtag: \#Typst. \

== Quebrando linhas
Se você quiser forçar uma quebra de linha sem iniciar um novo parágrafo, use \\ no final da linha: \
Primeira linha. \
Segunda linha, mas ainda no mesmo parágrafo.

== Referências de Citação
// Para criar uma citação use <nome> e depois referencie com @nome.

A tabela @tab:tabela mostra o autor e o ano da famosa teoria da relatividade.

#figure()[
  #table(
    columns: (1fr, 1fr),
    gutter: 1em,
    [ *Autor:* Albert Einstein ],
    [ *Ano:* 1905 ]
  )
]<tab:tabela>
