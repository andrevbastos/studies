#set page(paper: "a4", margin: (x: 1.5cm, y: 2cm))
#set text(
  size: 11pt, lang: "pt",
  tracking: 0.01em
)

#align(center)[
  #text(size: 24pt, weight: "bold")[Git]
]
#line(length: 100%)

#let git-table(..rows) = table(
  columns: (auto, 1fr),
  inset: 8pt,
  align: (left, horizon),
  stroke: 0.5pt + gray.lighten(50%),
  fill: (col, row) => if row == 0 { gray.lighten(80%) } else { white },
  [*Comando*], [*Descrição*],
  ..rows
)

= Configurando o GitHub
Configurações iniciais de identidade do usuário.

#git-table(
  [`git config --global --list`], [Retorna as configurações de usuário atuais.],
  [`git config --global user.name "nome"`], [Define o nome do usuário da máquina.],
  [`git config --global user.email "email"`], [Define o email do usuário da máquina.]
)

= Começo de um Repositório
Iniciando e monitorando o estado do projeto.

#git-table(
  [`git init`], [Inicia um repositório vazio no diretório atual.],
  [`git status`], [Devolve o status atual do repositório (branch, arquivos rastreados e não rastreados).],
  [`git log`], [Mostra o histórico de commits detalhadamente.],
  [`git log --oneline`], [Mostra o histórico de commits de forma simplificada (uma linha por commit).]
)

= Commits
Gerenciamento de alterações e histórico.

#git-table(
  [`git add <arquivo>`], [Adiciona o arquivo ou diretório à Staging Area. #text(size: 9pt, style: "italic")[\n(Dica: Use . para adicionar tudo).]],
  [`git rm --cached <arquivo>`], [Retira o arquivo da área de rastreio (Unstage), mas mantém no disco.],
  [`git commit -m "msg"`], [Grava os arquivos referenciados no histórico da branch atual.],
  [`git checkout <id>`], [Retorna para um commit anterior sem alterar o histórico (Detached HEAD).],
  [`git checkout master`], [Retorna para o commit mais recente da branch master (ou main).],
  [`git revert <id>`], [Cria um novo commit revertendo as alterações de um anterior. Seguro para o histórico.],
  [`git reset <id>`], [Retorna a um commit anterior, apaga subsequentes, mas mantém alterações nos arquivos.],
  [`git reset --hard <id>`], [Retorna a um commit anterior e limpa tudo. #text(fill: red.darken(20%), weight: "bold")[Cuidado: não tem volta.]]
)

#v(5pt)
*Ignorando Arquivos:* Use o arquivo `.gitignore` para listar diretórios ou arquivos que não devem ser rastreados.

= Branches (Ramificações)
Trabalhando em paralelo.

#git-table(
  [`git branch`], [Mostra todas as branches disponíveis.],
  [`git branch <nome>`], [Cria uma branch nova baseada na atual.],
  [`git checkout <nome>`], [Move para o commit mais recente da branch especificada.],
  [`git branch -d <nome>`], [Deleta a branch. Use `-D` para forçar a deleção de branches não mergeadas.]
)

= Merge
Integrando ramificações à branch atual (ex: master).

#git-table(
  [`git merge <nome>`], [Traz o histórico da branch `<nome>` para a atual. Em caso de conflito, a resolução deve ser manual seguida de um novo commit.]
)

= Repositórios Remotos
Interagindo com a nuvem (GitHub/GitLab).

#git-table(
  [`git clone <url>`], [Baixa um repositório remoto completo para sua máquina.],
  [`git remote add origin <url>`], [Conecta seu repositório local a um repositório vazio na nuvem.],
  [`git remote -v`], [Lista os repositórios remotos vinculados.],
  [`git push`], [Envia seus commits locais para o remoto. #text(size: 9pt)[\n(Use --set-upstream origin main na primeira vez).]],
  [`git pull`], [Baixa atualizações e faz o merge automaticamente.],
  [`git fetch`], [Baixa atualizações do remoto sem aplicá-las ao seu código (seguro para inspeção).]
)

= Stashing
Guarda mudanças temporárias para limpar o diretório de trabalho.

#git-table(
  [`git stash`], [Salva arquivos modificados numa pilha temporária e limpa o diretório.],
  [`git stash pop`], [Recupera as últimas mudanças salvas e as remove da pilha.],
  [`git stash list`], [Mostra a lista de mudanças guardadas na pilha.]
)

#pagebreak()

= Tags
Marcando pontos específicos na história (ex: lançamentos).

#git-table(
  [`git tag`], [Lista todas as tags existentes.],
  [`git tag -a <v1.0> -m "msg"`], [Cria uma tag anotada (recomendado para releases).],
  [`git push origin <tag>`], [Envia uma tag específica para o servidor remoto.]
)

= Worktrees
Múltiplos diretórios de trabalho ligados ao mesmo repositório.

#git-table(
  [`git worktree list`], [Lista todos os worktrees ativos.],
  [`git worktree add <path> <br>`], [Cria um novo diretório com o checkout da branch especificada.],
  [`git worktree remove <path>`], [Remove o worktree e desvincula a pasta.],
  [`git worktree prune`], [Limpa informações de worktrees deletados manualmente.]
)