import numpy as np
import matplotlib.pyplot as plt
from network_implicit_integrator import NetworkImplicitIntegrator
from network import Network
from elements import all_mole_fractions_to_mass_fractions
from plot_utils import save_plot, get_linestyles_cycler
from elements import id_helium, id_carbon, id_magnesium


def run_implicit_solver(plot_dir, figsize, show,
                        temperature9, h, tmax):

    initial_abundances = np.array([0.25, 0, 0])

    integrator = Network(t9=temperature9, rho=1, tmax=tmax,
                         y0=initial_abundances)

    x, all_mole_fractions = integrator.integrate(
        method=NetworkImplicitIntegrator, h=h)

    all_mass_fractions = \
        all_mole_fractions_to_mass_fractions(all_mole_fractions)

    linestyle_cycler = get_linestyles_cycler()
    plt.figure(figsize=figsize)

    plt.plot(x, all_mass_fractions[:, id_helium],
             label=r"${}^{4}\mathrm{He}$",
             linestyle=next(linestyle_cycler))

    plt.plot(x, all_mass_fractions[:, id_carbon],
             label=r"${}^{12}\mathrm{C}$",
             linestyle=next(linestyle_cycler))

    plt.plot(x, all_mass_fractions[:, id_magnesium],
             label=r"${}^{24}\mathrm{Mg}$",
             linestyle=next(linestyle_cycler))

    temperature_kelvin = temperature9 * 1e9

    title = (
        "Mass fractions for nuclear reactions\n"
        r"$3 {}^{4}\mathrm{He} \longleftrightarrow {}^{12}\mathrm{C}$, "
        r"$2 {}^{12}\mathrm{C} \longleftrightarrow {}^{24}\mathrm{Mg}$,"
        "\n"
        f"for T={temperature_kelvin:.2G} K, "
        f"step size h={h:.2G} s"
    )

    plt.title(title)
    plt.xlabel(r'Time t [s]')
    plt.ylabel(r'Mass fractions [unitless]')
    plt.xscale("log")
    plt.yscale("log")
    plt.legend()
    plt.grid()
    plt.tight_layout()
    filename = f"05.1_t9_{temperature9:.1f}.pdf"
    save_plot(plt=plt, plot_dir=plot_dir, filename=filename)

    if show:
        plt.show()


def show_mass_fraction_with_implicit_solver(plot_dir, figsize, show):
    run_implicit_solver(plot_dir=plot_dir, figsize=figsize, show=show,
                        temperature9=2.3, h=1e17, tmax=1e21)

    run_implicit_solver(plot_dir=plot_dir, figsize=figsize, show=show,
                        temperature9=2.4, h=1e16, tmax=1e20)
