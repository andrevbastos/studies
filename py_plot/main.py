import numpy as np
import matplotlib.pyplot as plt

def main():
    w = np.linspace(0, 1, 100)
    S = 3 * w**2 - 2 * w**3
    lerp = w

    plt.figure(figsize=(7, 4.5))
    plt.plot(w, S, label=r'$S(w) = 3w^2 - 2w^3$ (Smoothstep)', color='#1f77b4', linewidth=2.5)
    plt.plot(w, lerp, label='Interpolação Linear (lerp)', color='#d62728', linestyle='--', linewidth=2)

    plt.xlabel('Peso (w)', fontsize=10)
    plt.ylabel('Valor Interpolado', fontsize=10)
    plt.grid(True, linestyle=':', alpha=0.7)
    plt.legend(loc='upper left', frameon=True)

    plt.xlim(0, 1)
    plt.ylim(0, 1)

    plt.tight_layout()
    plt.savefig('smoothstep_graph.png', dpi=300, transparent=False)
    print("Gráfico salvo como 'smoothstep_graph.png'")
    
if __name__ == "__main__":
    main()