#include <iostream>
#include <list>

#include "ftxui/dom/elements.hpp"
#include "ftxui/component/screen_interactive.hpp"
#include "ftxui/component/component.hpp"

using namespace ftxui;

int main() {
    // Cria a tela interativa
    auto screen = ScreenInteractive::TerminalOutput();
    
    // == Menu de Navegação Lateral com Abas ==
    std::vector<std::string> entries = {
        "Todos os Projetos",
        "Em Andamento",
        "Concluídos",
        "Configurações",
        "Sair",
    };
    int selected = 0;

    MenuOption options;
    options.on_enter = [&] {
        if (entries[selected] == "Sair") {
            screen.ExitLoopClosure()();
        }
    };

    auto menu = Menu(&entries, &selected, options);

    // == Conteúdo das Abas ==
    struct Tarefa {
        std::string titulo;
        bool concluida;
        std::string prioridade;
    };

    std::list<Tarefa> lista_tarefas = {
        {"Configurar CMake", true, "Alta"},
        {"Aprender hbox e vbox", true, "Alta"},
        {"Criar estrutura de dados", false, "Média"},
        {"Implementar salvar em arquivo", false, "Baixa"},
    };

    std::string nova_tarefa_texto;
    auto layout_lista = Container::Vertical({}); 

    InputOption input_option;
    input_option.on_enter = [&] {
        lista_tarefas.push_back({nova_tarefa_texto, false, "Média"});
        layout_lista->Add(Checkbox(nova_tarefa_texto, &lista_tarefas.back().concluida));
        nova_tarefa_texto = "";
    };

    auto input_add_tarefa = Input(&nova_tarefa_texto, "Nova tarefa...", input_option);
    
    auto container_tarefas = Container::Vertical({
        input_add_tarefa,
        layout_lista,
    });

    auto tab_projetos = Renderer(container_tarefas, [&] {
        return vbox({
            hbox(text(" + Adicionar: "), input_add_tarefa->Render()),
            separator(),
            layout_lista->Render()
        });
    });

    auto tab_andamento = Renderer([] {
        return vbox({
            text("Projetos em Andamento") | bold,
            separator(),
            text("- Projeto Alpha: 50% concluído"),
            text("- Projeto Beta: 20% concluído") | color(Color::Red),
        });
    });

    auto tab_concluidos = Renderer([] {
        return vbox({
            text("Projetos Concluídos") | bold,
            separator(),
            text("- Projeto Omega: Concluído em 01/05/2024"),
            text("- Projeto Sigma: Concluído em 15/04/2024"),
        });
    });

    auto tab_config = Renderer([] {
        return text("Aqui ficarão as configurações...") | center;
    });

    auto tab_exit = Renderer([] {
        return text("Enter para sair.") | center;
    });

    auto tab_container = Container::Tab({
        tab_projetos,
        tab_andamento,
        tab_concluidos,
        tab_config,
        tab_exit
    }, &selected);

    // Layout final
    auto layout = Container::Horizontal({
        menu,
        tab_container,
    });

    // Renderizador principal
    auto renderer = Renderer(layout, [&]() {
        return hbox({
            menu->Render() | size(WIDTH, EQUAL, 30),
            separator(),
            tab_container->Render() | flex
        }) | borderRounded;
    });

    // Inicia o loop da tela interativa
    screen.Loop(renderer);
    
    return 0;
}