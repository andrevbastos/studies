#include <iostream>
#include <vector>
#include <string>

#include "ftxui/dom/elements.hpp"
#include "ftxui/component/screen_interactive.hpp"
#include "ftxui/component/component.hpp"
#include "ftxui/component/event.hpp"

using namespace ftxui;

// --- Estruturas (Mesmas de antes) ---
struct Configuracao { std::string ide; std::string linguagem; };
struct Projeto { std::string nome; std::string path; Configuracao config; };

int main() {
    // 1. Dados
    std::vector<std::string> main_menu_entries = { "Projetos", "Sair" };

    Configuracao alpha_config = {"VSCode", "C++"};
    Configuracao beta_config = {"CLion", "C++"};
    
    std::vector<Projeto> projetos = {
        {"Projeto Alpha", "/usr/dev/alpha", alpha_config},
        {"Projeto Beta", "/usr/dev/beta", beta_config},
    };

    std::vector<std::string> projetos_entries;
    for (const auto& p : projetos) projetos_entries.push_back(p.nome);

    // 2. Estado
    int selected_main = 0;
    int selected_project = 0;
    int depth = 0; // 0 = Menu Principal, 1 = Detalhes do Projeto

    auto screen = ScreenInteractive::TerminalOutput();

    // 3. Componentes
    
    // -- Menu Principal --
    auto menu_main = Menu(&main_menu_entries, &selected_main);

    // -- Menu de Projetos --
    // Aqui está o segredo: Interceptamos os eventos deste menu
    auto menu_projects_raw = Menu(&projetos_entries, &selected_project);
    
    auto menu_projects = CatchEvent(menu_projects_raw, [&](Event event) {
        // Se apertar ENTER na lista de projetos -> Aprofunda o nível (Zoom In)
        if (event == Event::Return) {
            depth = 1;
            return true; 
        }
        // Se apertar ESC (ou Esquerda no nível 1) -> Volta o nível (Zoom Out)
        if (event == Event::Escape || (depth == 1 && event == Event::ArrowLeft)) {
            depth = 0;
            return true;
        }
        
        // Bloqueia a seta para esquerda se estivermos no nível 1
        // (Para não voltar para o menu principal "invisível")
        if (depth == 1 && event == Event::ArrowLeft) {
            return true; 
        }

        return false; // Deixa o evento passar (navegação cima/baixo)
    });

    // Container Global
    // Usamos Horizontal para permitir ir do Main -> Projetos com a seta direita
    auto container = Container::Horizontal({
        menu_main,
        menu_projects,
    });

    // 4. Renderização Dinâmica
    auto renderer = Renderer(container, [&] {
        
        // Elemento de Detalhes (só aparece no Nível 1)
        Element details_view = text("");
        if (!projetos.empty()) {
            const auto& p = projetos[selected_project];
            details_view = vbox({
                text("DETALHES DO PROJETO") | bold | color(Color::Green),
                separator(),
                text("Nome: " + p.nome),
                text("Path: " + p.path),
                text("IDE:  " + p.config.ide),
            }) | border;
        }

        // Se estamos no Nível 0: Mostra [Menu Principal] | [Lista]
        if (depth == 0) {
            return hbox({
                vbox({
                    text(" MENU ") | bold | center,
                    separator(),
                    menu_main->Render()
                }) | border | size(WIDTH, GREATER_THAN, 20),

                vbox({
                    text(" PROJETOS ") | bold | center,
                    separator(),
                    // Mostramos o menu de projetos na direita
                    menu_projects->Render() 
                }) | border | flex 
            });
        } 
        
        // Se estamos no Nível 1: Mostra [Lista] | [Detalhes]
        else {
            return hbox({
                vbox({
                    text(" VOLTAR (ESC) ") | bold | center,
                    separator(),
                    // O MESMO menu agora é renderizado na esquerda!
                    menu_projects->Render() 
                }) | border | size(WIDTH, GREATER_THAN, 20),

                vbox({
                    // Detalhes na direita
                    details_view
                }) | flex
            });
        }
    });

    screen.Loop(renderer);
    
    return 0;
}