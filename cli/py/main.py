import argparse

def main():
    # Cria um parser de argumentos
    parser = argparse.ArgumentParser(description="CLI")
    # Adiciona um argumento obrigatório posicional chamado "name" do tipo string
    parser.add_argument("name", type=str, help="Name of the user")
    # Adiciona um argumento opcional chamado "salutation" do tipo string com valor padrão "Hello"
    parser.add_argument("-s", "--salutation", type=str, default="Hello", help="Salutation to use")
    # Adiciona um argumento opcional chamado "loud" do tipo booleano que, se presente, imprime a saudação em maiúsculas
    parser.add_argument("-l", "--loud", action="store_true", help="Print the salutation in uppercase")
    # Adiciona um argumento opcional chamado "repeat" do tipo inteiro com valor padrão 1, que indica o número de vezes que a saudação deve ser repetida
    parser.add_argument("-r", "--repeat", type=int, default=1, choices=range(1, 4), metavar="[1..3]", help="Number of times to repeat the greeting")
    
    # Adiciona um grupo de argumentos mutuamente exclusivos para controlar a verbosidade da saída
    # Ou seja, o usuário pode escolher entre suprimir a saída ou imprimir informações adicionais, mas não ambos
    group = parser.add_mutually_exclusive_group(required=False)
    group.add_argument("-q", "--quiet", action="store_true", help="Suppress output")
    group.add_argument("-v", "--verbose", action="store_true", help="Print additional information")
    
    # Parse os argumentos da linha de comando
    args = parser.parse_args()
    
    if args.verbose:
        print(f"Salutation: {args.salutation}")
        print(f"Name: {args.name}")
        print(f"Repeat: {args.repeat}")
    
    if args.quiet:
        return
    
    string = f"{args.salutation}, {args.name}!"
    for _ in range(args.repeat):
        if args.loud:
            print(string.upper())
        else:
            print(string)

if __name__ == "__main__":
    main()
