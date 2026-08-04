#set page(paper: "a4", margin: (x: 2cm, y: 2.5cm))
#set text(
  font: "FreeSans",
  size: 12pt, lang: "pt",
  tracking: 0.01em
)

#align(center)[
  #text("JThreads", size: 24pt, weight: "bold")
]
#line(length: 100%)

JThreads é uma biblioteca de threads para C++ que oferece uma interface simples e moderna para criar e gerenciar threads. Ela é baseada na biblioteca padrão de threads do C++11, mas adiciona recursos adicionais, como suporte a tarefas assíncronas, sincronização avançada e gerenciamento de recursos.

= Problema do C++11
Quando criamos um std::thread, ele imediatamente começa a executar em segundo plano. O problema ocorre quando o objeto std::thread sai de escopo (por exemplo, quando a função onde ele foi criado termina ou uma exceção é lançada). Se o destrutor for chamado e nós não tivermos explicitamente chamado .join() (esperar terminar) ou .detach() (desvincular da execução principal), o programa invoca std::terminate() e aborta abruptamente. Isso exigia muito cuidado, comumente forçando o uso de blocos try-catch apenas para garantir que as threads seriam unidas em caso de erro.
= Solução do C++20 com RAII
O std::jthread (onde o "j" significa joining) resolve isso aplicando o princípio RAII (Resource Acquisition Is Initialization). O destrutor do std::jthread é inteligente: ele verifica se a thread ainda está em execução (joinable). Se estiver, ele chama .join() automaticamente e de forma segura, garantindo que o programa principal espere a thread finalizar antes de destruir seus recursos.

