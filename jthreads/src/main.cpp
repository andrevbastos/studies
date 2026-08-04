#include <iostream>
#include <functional>
#include <thread>
#include <mutex>
#include <vector>
#include <queue>
#include <condition_variable>
#include <stop_token>
#include <chrono>

int counter = 0;
std::condition_variable_any cv;
bool dado_pronto = false;

void basic_thread_function() {
    std::cout << "Executando em background..." << std::endl;
}

void thread_with_stop_token(std::stop_token st) {
    while (!st.stop_requested()) {
        std::cout << "Thread rodando..." << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(1));
    }
    std::cout << "Thread recebeu sinal de parada, finalizando..." << std::endl;
}

void incr(std::stop_token st, std::mutex& mtx) {
    while (!st.stop_requested() && counter < 5) {
        {
            std::lock_guard<std::mutex> lock(mtx);
            counter++;
            std::cout << "Counter: " << counter << std::endl;
        }
        std::this_thread::sleep_for(std::chrono::seconds(1));
    }
    dado_pronto = true;
    cv.notify_all();
    std::cout << "Thread recebeu sinal de parada, finalizando..." << std::endl;
}

void consumer(std::stop_token st, std::mutex& mtx) {
    std::unique_lock<std::mutex> lock(mtx);
    cv.wait(lock, st, [] { return dado_pronto; });
    std::cout << "Consumindo dado..." << std::endl;
    counter -= 1;
    std::cout << "Counter: " << counter << std::endl;
}

class MonitorContador {
public:
    void produzir(std::stop_token st) {
        while (!st.stop_requested() && counter < 5) {
            {
                std::lock_guard<std::mutex> lock(mtx);
                counter++;
                std::cout << "Counter: " << counter << std::endl;
            }
            std::this_thread::sleep_for(std::chrono::seconds(1));
        }
        dado_pronto = true;
        cv.notify_all();
        std::cout << "Thread recebeu sinal de parada, finalizando..." << std::endl;
    }
    
    void consumir(std::stop_token st) {
        std::unique_lock<std::mutex> lock(mtx);
        if (!cv.wait(lock, st, [&] { return this->dado_pronto; })) return;
        std::cout << "Consumindo dado..." << std::endl;
        counter -= 1;
        std::cout << "Counter: " << counter << std::endl;
    }
private:
    int counter = 0;
    bool dado_pronto = false;
    std::mutex mtx;
    std::condition_variable_any cv;
};

int main() {
    MonitorContador monitor;
    std::jthread produtor(&MonitorContador::produzir, &monitor);

    std::jthread c1(&MonitorContador::consumir, &monitor);
    std::jthread c2(&MonitorContador::consumir, &monitor);
    std::jthread c3(&MonitorContador::consumir, &monitor);
    std::jthread c4(&MonitorContador::consumir, &monitor);
    std::jthread c5(&MonitorContador::consumir, &monitor);

    produtor.join();

    return 0;
}