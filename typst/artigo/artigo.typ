// ==========================================
// CONFIGURAÇÃO DO TEMPLATE ABNT
// ==========================================

#let artigo_abnt(
  titulo: "",
  titulo_estrangeiro: "",
  autores: (),
  resumo: "",
  palavras_chave: (),
  abstract: "",
  keywords: (),
  corpo
) = {
  // 1. Configuração da Página (ABNT NBR 14724 / 6022)
  // Margens: Superior 3cm, Esquerda 3cm, Inferior 2cm, Direita 2cm
  set page(
    paper: "a4",
    margin: (top: 3cm, left: 3cm, right: 2cm, bottom: 2cm),
    numbering: "1",
    number-align: top + right,
  )

  // 2. Configuração de Fonte Padrão
  // Times New Roman ou Arial, tamanho 12.
  set text(font: ("Times New Roman", "Linux Libertine"), size: 12pt, lang: "pt", region: "br")

  // 3. Espaçamento de Parágrafo
  // Espaçamento entre linhas de 1.5 (leading ~0.5em para fonte 12pt dá exatos 18pt de altura de linha)
  // Recuo de primeira linha padrão de 1.25cm
  // 'spacing' é o espaço entre os parágrafos
  set par(
    justify: true, 
    first-line-indent: 1.25cm, 
    leading: 0.5em, 
    spacing: 0.5em
  )

  // 4. Configuração de Títulos (Seções) - NBR 6024
  set heading(numbering: "1.1")
  show heading: it => {
    set text(size: 12pt, weight: "bold")
    
    // ABNT: 1.5 de entrelinhas (18pt). Reduzimos o "below" de 1.5em para 1em
    // pois o parágrafo falso logo abaixo vai adicionar os 0.5em restantes.
    set block(above: 1.5em, below: 1em) 
    
    // Nível 1: MAIÚSCULO E NEGRITO
    if it.level == 1 {
      upper(it)
    } 
    // Nível 2: Letra capitular e negrito
    else if it.level == 2 {
      it
    } 
    // Nível 3+: Sem negrito
    else {
      set text(weight: "regular")
      it
    }

    // HACK ABNT: O Typst remove o recuo do 1º parágrafo após um título.
    // Injetamos um parágrafo vazio e invisível para enganar o sistema
    // e forçar o recuo (tab de 1.25cm) no seu texto real logo abaixo.
    par(text(size: 0pt, ""))
  }

  // 5. Configuração de Figuras e Tabelas - IBGE / ABNT
  // O título deve ficar ACIMA e a fonte ABAIXO, em tamanho 10, espaçamento simples.
  show figure: it => block(breakable: false, width: 100%)[
    #set align(center)
    #set text(size: 10pt)
    #set par(leading: 0.3em) // Espaçamento simples
    
    // Título acima
    #if it.has("caption") [
      #strong[#it.supplement #it.counter.display(it.numbering) -- #it.caption.body]
      #v(0.5em)
    ]
    
    // Conteúdo da figura/tabela e fonte (que virá no corpo)
    #it.body
    #v(1em)
  ]

  // 6. Configuração de Referências (Bibliografia)
  // Alinhada à esquerda, espaçamento simples, linha em branco entre elas.
  show bibliography: set text(size: 12pt)
  show bibliography: set par(leading: 0.3em, first-line-indent: 0pt, justify: false)
  show bibliography: set block(spacing: 1.5em)
  show bibliography: set align(left)

  // ==========================================
  // ESTRUTURA DO DOCUMENTO
  // ==========================================

  // Título do Artigo (Centralizado, Maiúsculo, Negrito)
  align(center)[
    #text(size: 12pt, weight: "bold", upper(titulo))
    #if titulo_estrangeiro != "" [
      \ #v(0.5em) #text(size: 12pt, weight: "bold", style: "italic", titulo_estrangeiro)
    ]
  ]
  v(2em)

  // Autores (Alinhado à direita)
  align(right)[
    #for autor in autores [
      #text(size: 12pt)[#autor.nome]
      #footnote[#autor.filiacao - E-mail: #autor.email] \
    ]
  ]
  v(3em)

  // Resumo na língua vernácula
  if resumo != "" [
    #set par(first-line-indent: 0pt, leading: 0.3em) // Espaçamento simples
    #text(weight: "bold")[RESUMO] \
    #resumo
    \ \
    #text(weight: "bold")[Palavras-chave:] #palavras_chave.join(". ").
  ]
  v(2em)

  // Resumo em língua estrangeira (Abstract)
  if abstract != "" [
    #set par(first-line-indent: 0pt, leading: 0.3em) // Espaçamento simples
    #text(weight: "bold")[ABSTRACT] \
    #abstract
    \ \
    #text(weight: "bold")[Keywords:] #keywords.join(". ").
  ]
  v(3em)

  // Renderiza o corpo do texto
  corpo
}

// 7. Função auxiliar para Citações Longas (> 3 linhas) - NBR 10520
// Recuo de 4cm da margem esquerda, tamanho 10, espaçamento simples, sem aspas.
#let citacao_longa(texto) = {
  pad(left: 4cm, right: 0cm)[
    #set text(size: 10pt)
    #set par(first-line-indent: 0pt, leading: 0.3em) // Espaçamento simples
    #texto
  ]
  v(1em)
}


// ==========================================
// EXEMPLO DE USO DO TEMPLATE
// ==========================================

#show: artigo_abnt.with(
  titulo: "Template de Artigo em Typst seguindo as Normas da ABNT",
  titulo_estrangeiro: "Typst Article Template following ABNT Standards",
  autores: (
    (
      nome: "João da Silva",
      filiacao: "Universidade Federal de Santa Catarina (UFSC)",
      email: "joao.silva@email.com"
    ),
    (
      nome: "Maria Oliveira",
      filiacao: "Universidade de São Paulo (USP)",
      email: "maria.oliveira@email.com"
    )
  ),
  resumo: "Este trabalho apresenta um modelo de artigo científico formatado automaticamente utilizando a linguagem de marcação Typst. O foco principal é demonstrar a aplicação das regras da Associação Brasileira de Normas Técnicas (ABNT) em relação a margens, espaçamentos, tipografia, figuras e referências bibliográficas. A principal vantagem do Typst em relação ao LaTeX é sua sintaxe mais amigável e tempo de compilação instantâneo.",
  palavras_chave: ("Typst", "ABNT", "Formatação", "Artigo Científico"),
  abstract: "This paper presents a scientific article template automatically formatted using the Typst markup language. The main focus is to demonstrate the application of the Brazilian Association of Technical Standards (ABNT) rules regarding margins, spacing, typography, figures, and bibliographical references. The main advantage of Typst over LaTeX is its more user-friendly syntax and instantaneous compilation time.",
  keywords: ("Typst", "ABNT", "Formatting", "Scientific Paper")
)

= INTRODUÇÃO

A redação de trabalhos acadêmicos no Brasil exige o rigoroso cumprimento das diretrizes estabelecidas pela Associação Brasileira de Normas Técnicas (ABNT). Segundo as normas, o espaçamento entrelinhas do texto padrão deve ser de 1,5, enquanto citações longas, notas de rodapé e legendas de figuras devem possuir espaçamento simples.

Este template foi construído com regras de `show` e `set` no Typst para automatizar esses processos, garantindo que o autor precise focar apenas no conteúdo textual.

= DESENVOLVIMENTO

Nesta seção, demonstraremos os recursos de formatação automática que foram implementados na função base do template.

== Citações Longas

As citações diretas com mais de três linhas devem ser destacadas com recuo de 4 cm da margem esquerda, fonte tamanho 10 pt e sem aspas (ABNT NBR 10520). Para isso, utilizamos a função customizada `#citacao_longa[]`. Veja o exemplo abaixo:

#citacao_longa[
  A tecnologia de composição de documentos avançou significativamente nas últimas décadas. O Typst surge como uma alternativa moderna ao LaTeX, oferecendo um sistema de script Turing-completo, mensagens de erro claras e compilação em tempo real, mantendo a excelência tipográfica necessária para publicações científicas e acadêmicas de alto nível.
]

O texto normal retorna ao espaçamento de 1,5, com recuo de parágrafo de 1,25 cm na primeira linha e fonte tamanho 12 pt.

== Inserção de Figuras e Imagens

A NBR 14724 e normas correlatas do IBGE exigem que qualquer ilustração contenha a sua identificação na parte superior (Ex: "Figura 1 – Título") e, na parte inferior, a indicação da fonte.

No Typst, reescrevemos a regra `show figure` para posicionar o título (`caption`) automaticamente acima da imagem. A fonte pode ser colocada como texto logo abaixo do conteúdo da figura.

#figure(
  caption: [Diagrama de funcionamento do Typst],
  supplement: "Figura",
)[
  // Substitua por #image("sua_imagem.png", width: 60%) num projeto real
  #rect(width: 60%, height: 4cm, fill: luma(230), stroke: 1pt)[
    #align(center + horizon)[*IMAGEM AQUI*]
  ]
  #v(0.5em)
  #text(size: 10pt)[Fonte: Elaborado pelos autores (2024).]
]

== Tabelas

As tabelas seguem o mesmo princípio lógico das figuras: título acima e fonte abaixo. Recomenda-se evitar o fechamento das bordas laterais para seguir o padrão clássico do IBGE.

#figure(
  caption: [Comparativo de tempos de compilação],
  supplement: "Tabela",
)[
  #table(
    columns: (auto, auto, auto),
    stroke: none,
    table.hline(y: 0, stroke: 1pt),
    table.hline(y: 1, stroke: 0.5pt),
    [*Ferramenta*], [*Complexidade*], [*Tempo Médio*],
    [LaTeX], [Alta], [3.2 s],
    [Typst], [Baixa], [0.1 s],
    table.hline(y: 3, stroke: 1pt)
  )
  #v(0.5em)
  #text(size: 10pt)[Fonte: Dados da pesquisa (2024).]
]

= Considerações Finais

O Typst se provou ser uma ferramenta extremamente ágil para formatação de documentos. As regras `show` e `set` permitem "hackear" e reconstruir o layout nativo para atender exigências rígidas como as da ABNT, de forma programática, limpa e reutilizável.

// Quebra de página antes das referências
#pagebreak()

// Exemplo de chamamento de Referências. 
// Para a ABNT verdadeira, você deve baixar o arquivo "associacao-brasileira-de-normas-tecnicas.csl"
// e um arquivo .bib com suas fontes, chamando assim:
#bibliography("referencias.bib", style: "associacao-brasileira-de-normas-tecnicas.csl", title: "REFERÊNCIAS")
// Qualquer chamada de @referência aqui, como @silva2024, será formatada automaticamente conforme as regras da ABNT.