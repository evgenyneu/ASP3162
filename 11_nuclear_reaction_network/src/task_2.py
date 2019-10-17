import matplotlib.pyplot as plt
import numpy as np
from r_2c import r_2c
from plot_utils import save_plot, get_linestyles_cycler


def taks_2(plot_dir, figsize, show):
    t9_min = 0.1
    t9_max = 10
    t9 = np.linspace(t9_min, t9_max, 100)

    forward_rate1, reverse_rate1 = r_2c(t9=t9, rho=1)
    forward_rate2, reverse_rate2 = r_2c(t9=t9, rho=1e7)

    plt.figure(figsize=figsize)
    plt.xlabel(r'Scaled temperature $T_9 \  [K / 10^9]$')
    plt.ylabel(r'Reaction rate [mole faction / s]')

    title = (
        "Nuclear reaction rate for reaction\n"
        r"$2 {}^{12}\mathrm{C} \longleftrightarrow {}^{24}\mathrm{Mg}$"
        r"$ + \gamma$"
    )

    plt.title(title)
    linestyle_cycler = get_linestyles_cycler()

    plt.plot(t9, forward_rate1, label=r"$\rho$ = 1 g/cm",
             linestyle=next(linestyle_cycler))

    plt.plot(t9, forward_rate2, label=r"$\rho = 10^7$ g/cm",
             linestyle=next(linestyle_cycler))

    plt.xscale("log")
    plt.yscale("log")
    plt.legend()
    plt.grid()
    plt.tight_layout()
    save_plot(plt=plt, plot_dir=plot_dir, filename="02_test.pdf")

    if show:
        plt.show()
