import matplotlib.pyplot as plt
import numpy as np
from r_2c import r_2c
from r_3a import r_3a
from plot_utils import save_plot, get_linestyles_cycler

def plot_rates(filename, x, y, title, plot_dir, figsize, show):
    plt.figure(figsize=figsize)
    plt.xlabel(r'Scaled temperature $T_9 \  [K / 10^9]$')
    plt.ylabel(r'Reaction rate [mole faction / s]')
    plt.title(title)
    linestyle_cycler = get_linestyles_cycler()

    plt.plot(x, y[0], label=r"$\rho$ = 1 g/cm",
             linestyle=next(linestyle_cycler))

    plt.plot(x, y[1], label=r"$\rho = 10^7$ g/cm",
             linestyle=next(linestyle_cycler))

    plt.ylim(1e-30, 1e20)
    plt.xscale("log")
    plt.yscale("log")
    plt.legend()
    plt.grid()
    plt.tight_layout()
    save_plot(plt=plt, plot_dir=plot_dir, filename=filename)

    if show:
        plt.show()


def taks_2(plot_dir, figsize, show):
    t9_min = 0.1
    t9_max = 10
    t9 = np.linspace(t9_min, t9_max, 100)

    forward_rate1, reverse_rate1 = r_2c(t9=t9, rho=1)
    forward_rate2, reverse_rate2 = r_2c(t9=t9, rho=1e7)

    # C to Mg
    # ------------

    title = (
        "Nuclear reaction rate for\n"
        r"$2 {}^{12}\mathrm{C} \longrightarrow {}^{24}\mathrm{Mg}$"
        r"$ + \gamma$"
    )

    plot_rates(filename="02.1_c_to_mg.pdf",
               x=t9, y=[forward_rate1, forward_rate2], title=title,
               plot_dir=plot_dir, figsize=figsize, show=show)

    # Mg to C
    # ------------

    title = (
        "Nuclear reaction rate for\n"
        r"$2 {}^{12}\mathrm{C} \longleftarrow {}^{24}\mathrm{Mg}$"
        r"$ + \gamma$"
    )

    plot_rates(filename="02.2_mg_to_c.pdf",
               x=t9, y=[reverse_rate1, reverse_rate2], title=title,
               plot_dir=plot_dir, figsize=figsize, show=show)

    # 3 He to C
    # ------------

    forward_rate1, reverse_rate1 = r_3a(t9=t9, rho=1)
    forward_rate2, reverse_rate2 = r_3a(t9=t9, rho=1e7)

    title = (
        "Nuclear reaction rate for\n"
        r"$3 {}^{4}\mathrm{He} \longrightarrow {}^{12}\mathrm{C}$"
        r"$ + \gamma$"
    )

    plot_rates(filename="02.3_he_to_c.pdf",
               x=t9, y=[forward_rate1, forward_rate2], title=title,
               plot_dir=plot_dir, figsize=figsize, show=show)

    # C to 3 He
    # ------------

    title = (
        "Nuclear reaction rate for\n"
        r"$3 {}^{4}\mathrm{He} \longleftarrow {}^{12}\mathrm{C}$"
        r"$ + \gamma$"
    )

    plot_rates(filename="02.3_c_to_he.pdf",
               x=t9, y=[reverse_rate1, reverse_rate2], title=title,
               plot_dir=plot_dir, figsize=figsize, show=show)
