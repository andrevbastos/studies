import argparse

def main():
    # Cria um parser de argumentos
    parser = argparse.ArgumentParser(description="CLI")
    # Adiciona subcomandos ao parser
    subparsers = parser.add_subparsers(dest="command", help="Sub-command help")
    
    # Adiciona um subcomando chamado "greet" ao parser
    parcer_greet = subparsers.add_parser("greet", help="greet the user")
    
    # Adiciona um argumento obrigatório posicional chamado "name" do tipo string
    parcer_greet.add_argument("name", type=str, help="game of the user")
    # Adiciona um argumento opcional chamado "salutation" do tipo string com valor padrão "Hello"
    parcer_greet.add_argument("-s", "--salutation", type=str, default="Hello", metavar="...", help="salutation to use")
    # Adiciona um argumento opcional chamado "loud" do tipo booleano que, se presente, imprime a saudação em maiúsculas
    parcer_greet.add_argument("-l", "--loud", action="store_true", help="print the salutation in uppercase")
    # Adiciona um argumento opcional chamado "repeat" do tipo inteiro com valor padrão 1, que indica o número de vezes que a saudação deve ser repetida
    parcer_greet.add_argument("-r", "--repeat", type=int, default=1, choices=range(1, 4), metavar="[1..3]", help="number of times to repeat the greeting")
    
    # Adiciona um grupo de argumentos mutuamente exclusivos para controlar a verbosidade da saída
    # Ou seja, o usuário pode escolher entre suprimir a saída ou imprimir informações adicionais, mas não ambos
    parcer_greet_verbosity = parcer_greet.add_mutually_exclusive_group(required=False)
    parcer_greet_verbosity.add_argument("-q", "--quiet", action="store_true", help="suppress output")
    parcer_greet_verbosity.add_argument("-v", "--verbose", action="store_true", help="print additional information")
    
    # Adiciona um subcomando chamado "dismiss" ao parser
    parcer_dismiss = subparsers.add_parser("dismiss", help="dismiss the user")
    parcer_dismiss.add_argument("name", type=str, help="name of the user")
    
    # Parse os argumentos da linha de comando
    args = parser.parse_args()
    
    if args.command == "greet":
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
    elif args.command == "dismiss":
        print(f"Goodbye, {args.name}!")


if __name__ == "__main__":
    main()
