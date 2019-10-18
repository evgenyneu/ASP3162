import numpy as np
import matplotlib.pyplot as plt
from adaptive_network_implicit_integrator import AdaptiveNetworkImplicit
from thermo_network import ThermoNetwork
from t9_rho import T9Rho
from elements import all_mole_fractions_to_mass_fractions
from plot_utils import save_plot, get_linestyles_cycler
from elements import id_helium, id_carbon, id_magnesium


def run_thermo_solver(plot_dir, figsize, show,
                      tp, rhop, h, tmax):

    initial_abundances = np.array([0.25, 0, 0])

    thermo = T9Rho(tp=tp, rhop=rhop)

    integrator = ThermoNetwork(tmax=tmax,
                               y0=initial_abundances,
                               t9min=1.e-2,
                               thermo=thermo)

    x, all_mole_fractions = integrator.integrate(
        method=AdaptiveNetworkImplicit, h=h)

    all_mass_fractions = \
        all_mole_fractions_to_mass_fractions(all_mole_fractions)

    linestyle_cycler = get_linestyles_cycler()
    plt.figure(figsize=figsize)

    tp_kelvin = tp * 1e9

    title = (
        "Mass fractions for nuclear reactions\n"
        r"$3 {}^{4}\mathrm{He} \longleftrightarrow {}^{12}\mathrm{C}$, "
        r"$2 {}^{12}\mathrm{C} \longleftrightarrow {}^{24}\mathrm{Mg}$,"
        "\n"
        "for $T_p$"
        f"={tp_kelvin:.2G} K, "
        r"$\rho_p$"
        f"={rhop:.2G} "
        "$g \ cm^{-3}$"
    )

    plt.plot(x, all_mass_fractions[:, id_helium],
             label=r"${}^{4}\mathrm{He}$",
             linestyle=next(linestyle_cycler))

    plt.plot(x, all_mass_fractions[:, id_carbon],
             label=r"${}^{12}\mathrm{C}$",
             linestyle=next(linestyle_cycler))

    plt.plot(x, all_mass_fractions[:, id_magnesium],
             label=r"${}^{24}\mathrm{Mg}$",
             linestyle=next(linestyle_cycler))

    plt.title(title)
    plt.xlabel(r'Time t [s]')
    plt.ylabel(r'Mass fractions [unitless]')
    plt.xscale("log")
    plt.yscale("log")
    plt.legend()
    plt.grid()
    plt.tight_layout()
    filename = f"07.1_rhop_{rhop:.2G}.pdf"
    save_plot(plt=plt, plot_dir=plot_dir, filename=filename)

    if show:
        plt.show()


def show_mass_fraction_with_thermo_network(plot_dir, figsize, show):
    run_thermo_solver(plot_dir=plot_dir, figsize=figsize, show=show,
                      tp=10, rhop=1e6, h=1e-10, tmax=1e25)

    run_thermo_solver(plot_dir=plot_dir, figsize=figsize, show=show,
                      tp=7, rhop=1e12, h=1e-10, tmax=1e25)
