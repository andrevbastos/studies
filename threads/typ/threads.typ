#set page(paper: "a4", margin: (x: 2cm, y: 2.5cm))
#set text(
  font: "FreeSans",
  size: 16pt, lang: "pt",
  tracking: 0.01em
)

#align(center)[
  #text("Threads", size: 40pt, weight: "bold")
]

#line(length: 100%)

= O que é uma thread?
Uma thread é a menor unidade de execução dentro de um processo. Ela permite que um programa execute múltiplas tarefas simultaneamente, compartilhando recursos do processo, como memória e arquivos abertos.

= Ciclo de vida de uma thread
Em C++ podemos criar uma thread usando a classe `std::thread`. O ciclo de vida de uma thread inclui os seguintes estados:
- *Criada*: A thread é criada, mas ainda não começou a executar.
- *Executando*: A thread está em execução, realizando suas tarefas.
- *Finalizada*: A thread terminou sua execução, seja porque completou suas tarefas ou porque foi interrompida.
== `join()`
Quando uma thread é criada, ela pode ser "juntada" (joined) à thread principal usando o método `join()`. Isso garante que a thread principal espere até que a thread secundária termine sua execução antes de continuar.
== `detach()`
Alternativamente, uma thread pode ser "desanexada" (detached) usando o método `detach()`. Isso permite que a thread execute de forma independente, sem que a thread principal precise esperar por ela. No entanto, é importante garantir que a thread desanexada seja gerenciada corretamente para evitar problemas de recursos, como vazamentos de memória. Se a função main terminar antes da thread desanexada, o comportamento é indefinido, pois a thread pode tentar acessar recursos que já foram liberados.

= Sincronização de threads
Quando múltiplas threads acessam recursos compartilhados, como variáveis globais ou arquivos, é necessário sincronizar o acesso a esses recursos para evitar condições de corrida (race conditions) e garantir a consistência dos dados. Em C++, podemos usar mutexes para proteger o acesso a recursos compartilhados.
== Exemplo do contador
Quando múltiplas threads tentam incrementam uma variável compartilhada, como um contador, sem sincronização, o resultado pode ser imprevisível devido a condições de corrida. Para resolver isso, podemos usar um mutex para proteger o acesso à variável compartilhada, garantindo que apenas uma thread possa modificá-la por vez.
== Mutexes
Um mutex (mutual exclusion) é um objeto de sincronização que pode ser usado para proteger recursos compartilhados. Ele funciona como um bloqueio que uma thread deve adquirir antes de acessar o recurso protegido e liberar depois de terminar. Em C++, a classe `std::mutex` é usada para criar mutexes, esta classe tem as funções `lock()` e `unlock()` para adquirir e liberar o mutex, respectivamente. No entanto, o uso manual de `lock()` e `unlock()` pode levar a erros, como esquecer ou não conseguir liberar o mutex, o que pode causar deadlocks.
=== Lock Guard
Para evitar os problemas associados ao uso manual de mutexes, C++ oferece a classe `std::lock_guard`, que é um wrapper que gerencia o lock de um mutex. Ele garante que o mutex seja liberado automaticamente quando o `lock_guard` sair do escopo, mesmo que uma exceção seja lançada. Isso torna o código mais seguro e fácil de ler, evitando erros comuns como esquecer de liberar o mutex ou liberar o mutex em um local errado.