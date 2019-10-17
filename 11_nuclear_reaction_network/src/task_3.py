import matplotlib.pyplot as plt
from runge_kutta_integrator import RungeKuttaIntegrator
from network import Network
from plot_utils import save_plot, get_linestyles_cycler
from elements import all_mole_fractions_to_mass_fractions
from elements import id_helium, id_carbon, id_magnesium


def plot_mass_fractions_for_temperature(temperature9, number_of_steps,
                                        plot_dir, figsize, show):
    tmax = 1e13
    h = tmax / number_of_steps  # Step size

    integrator = Network(t9=temperature9, rho=1, tmax=tmax, y0=[0.25, 0, 0])

    x, all_mole_fractions = integrator.integrate(method=RungeKuttaIntegrator,
                                                 h=h)
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
        f"for {temperature_kelvin:.2G} K, "
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
    filename = f"03.1_t9_{temperature9:.1f}.pdf"
    save_plot(plt=plt, plot_dir=plot_dir, filename=filename)

    # if show:
    #     plt.show()


def plot_mass_fractions(plot_dir, figsize, show):
    temperatures_and_number_of_steps = [
        # [1, 1000],
        # [1.1, 1000],
        # [1.2, 1000],
        # [1.3, 2000],
        # [1.4, 5000],
        # [1.5, 7000],
        # [1.6, 18000],
        # [1.7, 30000],
        # [1.8, 60000],
        [1.9, 150000]
    ]

    for one_temperature_and_number_of_steps in \
            temperatures_and_number_of_steps:

        plot_mass_fractions_for_temperature(
            temperature9=one_temperature_and_number_of_steps[0],
            number_of_steps=one_temperature_and_number_of_steps[1],
            plot_dir=plot_dir, figsize=figsize, show=show)
