import matplotlib.pyplot as plt
from runge_kutta_integrator import RungeKuttaIntegrator
from network import Network
from plot_utils import save_plot, get_linestyles_cycler


def plot_mass_fractions(plot_dir, figsize, show):
    tmax = 1e12
    number_of_steps = 1000
    h = tmax / number_of_steps  # Step size

    integrator = Network(t9=1.5, rho=1, tmax=tmax, y0=[0.25, 0, 0])
    x, mole_fractions = integrator.integrate(method=RungeKuttaIntegrator, h=h)


    helium_mole_fractions = mole_fractions[:, 0]
    carbon_mole_fractions = mole_fractions[:, 1]
    magnesium_mole_fractions = mole_fractions[:, 2]

    linestyle_cycler = get_linestyles_cycler()
    plt.figure(figsize=figsize)

    plt.plot(x, helium_mole_fractions,
             label=r"${}^{4}\mathrm{He}$",
             linestyle=next(linestyle_cycler))

    plt.plot(x, carbon_mole_fractions,
             label=r"${}^{12}\mathrm{C}$",
             linestyle=next(linestyle_cycler))

    plt.plot(x, magnesium_mole_fractions,
             label=r"${}^{24}\mathrm{Mg}$",
             linestyle=next(linestyle_cycler))

    plt.xlabel(r'Time t [s]')
    plt.ylabel(r'Mole fractions Y [unitless]')
    plt.title("Change of composition due to nuclear reactions")
    plt.xscale("log")
    plt.yscale("log")
    plt.legend()
    plt.grid()
    plt.tight_layout()
    save_plot(plt=plt, plot_dir=plot_dir, filename="03.1_t9_1.0.pdf")

    if show:
        plt.show()
