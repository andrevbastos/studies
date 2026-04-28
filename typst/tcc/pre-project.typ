// ==========================================
// CONFIGURAÇÃO DO TEMPLATE DE PRÉ-PROJETO (ABNT NBR 15287)
// ==========================================

#let pre_projeto_abnt(
  titulo: "",
  subtitulo: "",
  autor: "",
  orientador: "",
  coorientador: "",
  instituicao: "",
  curso: "",
  local: "",
  ano: "",
  natureza_trabalho: "",
  lista_ilustracoes: false,
  lista_tabelas: false,
  corpo
) = {
  // 1. Configuração Básica da Página
  set page(
    paper: "a4",
    margin: (top: 3cm, left: 3cm, right: 2cm, bottom: 2cm),
    numbering: none // Numeração invisível nos pré-textuais
  )
  
  set text(font: ("Times New Roman"), size: 12pt, lang: "pt", region: "br")

  // ==========================================
  // ELEMENTOS PRÉ-TEXTUAIS
  // ==========================================

  // --- CAPA (Obrigatório) ---
  align(center)[
    #text(weight: "bold", upper(instituicao)) \
    #text(weight: "bold", upper(curso))
    
    #v(1fr)
    #text(weight: "bold", upper(autor))
    #v(1fr)
    
    #text(weight: "bold", size: 14pt, upper(titulo))
    #if subtitulo != "" [
      #text(weight: "bold", size: 14pt)[: #subtitulo]
    ]
    
    #v(2fr)
    #text(weight: "bold", local) \
    #text(weight: "bold", ano)
  ]
  pagebreak()

  // --- FOLHA DE ROSTO (Obrigatório) ---
  align(center)[
    #text(upper(autor))
    #v(1fr)
    
    #text(weight: "bold", upper(titulo))
    #if subtitulo != "" [
      #text(weight: "bold")[: #subtitulo]
    ]
    #v(3em)
    
    // Recuo de 8cm para a nota de natureza do trabalho
    #align(right)[
      #pad(left: 8cm)[
        #set text(size: 10pt)
        #set par(leading: 0.3em, justify: true)
        #natureza_trabalho
        \ \
        *Orientador(a):* #orientador
        #if coorientador != "" [
          \ *Coorientador(a):* #coorientador
        ]
      ]
    ]
    
    #v(1fr)
    #local \
    #ano
  ]
  pagebreak()

  // --- LISTA DE ILUSTRAÇÕES (Opcional) ---
  if lista_ilustracoes [
    #align(center)[#text(weight: "bold")[LISTA DE ILUSTRAÇÕES]]
    #v(1.5em)
    #outline(title: none, target: figure.where(kind: image))
    #pagebreak()
  ]

  // --- LISTA DE TABELAS (Opcional) ---
  if lista_tabelas [
    #align(center)[#text(weight: "bold")[LISTA DE TABELAS]]
    #v(1.5em)
    #outline(title: none, target: figure.where(kind: table))
    #pagebreak()
  ]

  // --- SUMÁRIO (Obrigatório) ---
  align(center)[#text(weight: "bold")[SUMÁRIO]]
  v(1.5em)
  
  show outline.entry.where(level: 1): it => {
    v(1em, weak: true)
    strong(it)
  }
  
  outline(title: none, depth: 3, indent: 0.5em)
  pagebreak()


  // ==========================================
  // ELEMENTOS TEXTUAIS E FORMATAÇÃO DO CORPO
  // ==========================================

  // A partir daqui, a numeração de páginas fica visível
  set page(numbering: "1", number-align: top + right)

  set par(
    justify: true, 
    first-line-indent: 1.25cm, 
    leading: 0.5em, 
    spacing: 0.5em
  )

  set heading(numbering: "1.1")
  show heading: it => {
    set text(size: 12pt, weight: "bold")
    set block(above: 1.5em, below: 1em) 
    
    if it.level == 1 {
      // Capítulos principais quebram página
      pagebreak(weak: true)
      upper(it)
    } else if it.level == 2 {
      it
    } else {
      // Subseções de nível 3 em diante sem negrito
      set text(weight: "regular")
      it
    }
    par(text(size: 0pt, ""))
  }

  // Formatação de Figuras e Tabelas
  show figure: it => block(breakable: false, width: 100%)[
    #set align(center)
    #set text(size: 10pt)
    #set par(leading: 0.3em) 
    
    #if it.has("caption") [
      #strong[#it.supplement #it.counter.display(it.numbering) -- #it.caption.body]
      #v(0.5em)
    ]
    #it.body
    #v(1em)
  ]

  // Formatação das Referências
  show bibliography: set text(size: 12pt)
  show bibliography: set par(leading: 0.3em, first-line-indent: 0pt, justify: false)
  show bibliography: set block(spacing: 1.5em)
  show bibliography: set align(left)

  corpo
}

// ==========================================
// FUNÇÕES AUXILIARES
// ==========================================

#let citacao_longa(texto) = {
  pad(left: 4cm, right: 0cm)[
    #set text(size: 10pt)
    #set par(first-line-indent: 0pt, leading: 0.3em)
    #texto
  ]
  v(1em)
}


// ==========================================
// APLICAÇÃO DO TEMPLATE (CONTEÚDO DO PROJETO)
// ==========================================

#show: pre_projeto_abnt.with(
  titulo: "Implementação de Templates Typst para Pesquisa",
  subtitulo: "Um estudo de viabilidade",
  autor: "João da Silva",
  orientador: "Prof. Dr. Marcos António",
  instituicao: "Universidade Federal de Santa Catarina - UFSC",
  curso: "Curso de Ciência da Computação",
  local: "Florianópolis",
  ano: "2024",
  natureza_trabalho: "Projeto de pesquisa apresentado ao Departamento de Computação como requisito parcial para aprovação na disciplina de Metodologia da Pesquisa.",
  
  lista_ilustracoes: true,
  lista_tabelas: true,
)


= INTRODUÇÃO

A introdução deve apresentar o tema de forma clara e contextualizada. Neste momento, o leitor deve ser inserido no universo da pesquisa, compreendendo o cenário atual e a relevância geral do assunto abordado. 

== Tema e Problema de Pesquisa

A delimitação do tema especifica exatamente o que será estudado. O problema de pesquisa geralmente é formulado como uma pergunta clara e objetiva que o projeto pretende responder ao final de sua execução. Por exemplo: "Como a utilização do Typst pode otimizar o tempo de formatação de trabalhos acadêmicos em comparação ao LaTeX?"

== Justificativa

A justificativa deve convencer o leitor da importância da pesquisa. É o momento de "vender o seu peixe", explicando a relevância teórica, prática e social do estudo, e por que ele merece ser realizado.

= OBJETIVOS

Os objetivos indicam o que se pretende alcançar com a pesquisa.

== Objetivo Geral

Analisar a viabilidade e a eficiência da adoção da linguagem Typst para a diagramação de trabalhos acadêmicos nas universidades brasileiras.

== Objetivos Específicos

Os objetivos específicos detalham os passos necessários para alcançar o objetivo geral. Devem ser iniciados com verbos no infinitivo:

- Identificar os principais desafios enfrentados por estudantes no uso de processadores de texto convencionais e LaTeX.
- Desenvolver modelos (templates) na linguagem Typst baseados nas normas da ABNT.
- Comparar o tempo de compilação e a curva de aprendizado entre Typst e LaTeX.

= FUNDAMENTAÇÃO TEÓRICA

Neste capítulo, apresenta-se a base teórica que sustentará a pesquisa. É a revisão da literatura onde se dialoga com autores que já estudaram o tema.

Segundo Fulano (2020), a diagramação acadêmica é um dos maiores gargalos na finalização de teses e dissertações. A norma ABNT exige rigidez que muitas vezes não é bem tratada por editores visuais como o Microsoft Word.

#citacao_longa[
  A citação longa (com mais de três linhas) deve ser inserida com recuo de 4 cm da margem esquerda, tamanho de fonte menor (geralmente 10pt) e espaçamento simples entre linhas, sem aspas. Este é um exemplo de como a função que criamos formata automaticamente o texto para atender a essa exigência da norma. (AUTOR, 2023, p. 45).
]

= METODOLOGIA

A metodologia descreve *como* a pesquisa será realizada. Deve detalhar o tipo de pesquisa (exploratória, descritiva, explicativa), a abordagem (qualitativa, quantitativa), os instrumentos de coleta de dados e como os dados serão analisados.

= CRONOGRAMA

O cronograma detalha o tempo previsto para a realização de cada etapa da pesquisa, desde o levantamento bibliográfico até a defesa final. 

#figure(
  caption: [Cronograma de execução das atividades],
  supplement: "Tabela",
)[
  #table(
    columns: (3fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    stroke: none,
    align: (left, center, center, center, center, center, center),
    table.hline(y: 0, stroke: 1pt),
    table.hline(y: 1, stroke: 0.5pt),
    [*Atividade*], [*Jan*], [*Fev*], [*Mar*], [*Abr*], [*Mai*], [*Jun*],
    [Levantamento Bibliográfico], [X], [X], [], [], [], [],
    [Construção do Referencial Teórico], [], [X], [X], [], [], [],
    [Coleta de Dados], [], [], [X], [X], [], [],
    [Análise dos Resultados], [], [], [], [X], [X], [],
    [Redação do Trabalho Final], [], [], [], [], [X], [X],
    [Revisão e Defesa], [], [], [], [], [], [X],
    table.hline(y: 7, stroke: 1pt)
  )
  #v(0.5em)
  #text(size: 10pt)[Fonte: Elaborado pelo autor (2024).]
]

// =======================================================
// ELEMENTOS PÓS-TEXTUAIS
// =======================================================

// 1. Referências
#bibliography("referencias.bib", style: "associacao-brasileira-de-normas-tecnicas.csl", title: "REFERÊNCIAS")