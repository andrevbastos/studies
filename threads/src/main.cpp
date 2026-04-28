#include <iostream>
#include <thread>
#include <mutex>
#include <semaphore>

int count;

void hello();
void incr1();
void incr2(std::mutex& mtx);
void incr3(std::mutex& mtx);

int main() {
    // Create a thread that runs the hello function
    std::thread t(hello);

    // Detach the thread if you don't need to wait for it
    // t.detach();

    // Wait for the thread to finish
    t.join();

    // Problema: O resultado da contagem pode ser diferente a cada execução, devido a condições de corrida
    count = 0;
    std::thread t1(incr1);
    std::thread t2(incr1);
    t1.join();
    t2.join();
    
    std::cout << "Count sem mutex: " << count << std::endl;
    
    // Solução: Usar um mutex para proteger o acesso à variável compartilhada count
    // Novo problema: Como o lock é manualmente controlado, é possível que um erro aconteça antes do unlock, o que pode levar a deadlocks
    count = 0;
    std::mutex mtx;
    std::thread t3(incr2, std::ref(mtx));
    std::thread t4(incr2, std::ref(mtx));
    t3.join();
    t4.join();

    std::cout << "Count com mutex: " << count << std::endl;

    // Solução: Usar lock_guard para evitar deadlocks, lock_guard é um wrapper que gerencia o lock de um mutex, 
    //          garantindo que ele seja liberado automaticamente quando o lock_guard sair do escopo
    // Novo problema: O mutex consistentemente causa busy waiting, o que pode levar a uma performance ruim
    count = 0;
    std::thread t5(incr3, std::ref(mtx));
    std::thread t6(incr3, std::ref(mtx));
    t5.join();
    t6.join();

    std::cout << "Count com lock_guard: " << count << std::endl;

    // Solução: Usar um semáforo para limitar o número de threads que podem acessar a seção crítica ao mesmo tempo, evitando busy waiting
    count = 0;
    std::counting_semaphore<1> sem(1);
    std::thread t7(incr4, std::ref(sem));
    std::thread t8(incr4, std::ref(sem));
    t7.join();
    t8.join();

    std::cout << "Count com semáforo: " << count << std::endl;

    // Alternativa: Usar um monitor, que é uma abstração de alto nível que combina mutex e condição de variável, 
    //          permitindo que as threads esperem por certas condições sem busy waiting.
    

    return 0;
}

void hello() {
    std::cout << "Hello from thread!" << std::endl;
}

void incr1() {
    for (int i = 0; i < 100000; ++i) {
        count++;
    }
}

void incr2(std::mutex& mtx) {
    for (int i = 0; i < 100000; ++i) {
        mtx.lock();
        count++;
        mtx.unlock();
    }
}

void incr3(std::mutex& mtx) {
    for (int i = 0; i < 100000; ++i) {
        std::lock_guard<std::mutex> lock(mtx);
        count++;
    }
}

void incr4(std::counting_semaphore<1>& sem) {
    for (int i = 0; i < 100000; ++i) {
        sem.acquire();
        count++;
        sem.release();
    }
}