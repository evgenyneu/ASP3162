# Calculate stellar structure parameters using Lane-Emden model.

import numpy as np
from astropy import constants
import matplotlib.pyplot as plt
from plot_utils import save_plot
from lane_emden import solve_lane_emden
from integrators import runge_kutta_integrator


def calculate_stellar_parameters(step_size,
                                 polytropic_index,
                                 stellar_mass,
                                 central_density,
                                 mean_molecular_weight):

    """
    Calculate stellar structure parameters using Lane-Emden model.

    Parameters
    -----------

    step_size : float
        Size of the radius step used in integration

    polytropic_index : int
        Parameter used in Lane-Emden model

    stellar_mass : float
        Mass of the tellar model [kg]

    central_density : float
        Density at the center of the star [kg/m^3]

    mean_molecular_weight : float
        Mean molecular weight of the star

    Returns : dict
    -----------

    Dictionary structure:
        {
            "radii" :
            "temperatures" :
            "pressures" :
            "densities" :
        }

    Radii, temperatures, pressures and densities are lists of the same size.

    radii : list of float
        Distance from the center of the star [m]

    temperatures : list of float
        Temperature [K]

    pressures : list of float
        Pressure [Pa]

    densities : list of float
        Density [kg/m^3]
    """

    xi, theta, dtheta_dxi = calculate_scaled_parameters(
        polytropic_index=polytropic_index, step_size=step_size)

    xi1 = xi[-1]
    dtheta_dxi_at_xi1 = dtheta_dxi[-1]

    alpha = find_alpha(xi1=xi1,
                       dtheta_dxi_at_xi1=dtheta_dxi_at_xi1,
                       stellar_mass=stellar_mass,
                       central_density=central_density)

    k = find_k(alpha=alpha,
               polytropic_index=polytropic_index,
               central_density=central_density)

    gamma = find_gamma(polytropic_index=polytropic_index)

    central_pressure = find_central_pressure(
        k=k, central_density=central_density, gamma=gamma)

    pressure = find_pressure(polytropic_index=polytropic_index,
                             central_pressure=central_pressure,
                             theta=theta)

    density = find_density(polytropic_index=polytropic_index,
                           central_density=central_density,
                           theta=theta)

    radius = find_radius(alpha=alpha, xi=xi)

    temperature = find_temperature(
        mean_molecular_weight=mean_molecular_weight,
        pressures=pressure,
        densities=density
    )

    return {
        "radii": radius,
        "temperatures": temperature,
        "pressures": pressure,
        "densities": density
    }


def find_alpha(xi1, dtheta_dxi_at_xi1, stellar_mass, central_density):
    """
    Calculate alpha parameter using Eq. 8 (doc/lane_emden_equations.png)

    Parameters
    -----------

    xi1 : float
        Radius at the surface

    dtheta_dxi_at_xi1 : float
        Derivative of density with respect to radius, evaluated at the surface

    stellar_mass : float
        Mass of the tellar model [kg]

    central_density : float
        Density at the center of the star [kg/m^3]

    Returns : float
    ---------------

    Alpha parameter from Eq. 8 (doc/lane_emden_equations.png)
    """

    a = -(xi1**2) * dtheta_dxi_at_xi1

    alpha = stellar_mass / (4 * np.pi * central_density * a)
    alpha = alpha**(1/3)
    return alpha


def find_k(alpha, polytropic_index, central_density):
    """
    Calculate parameter K using Eq. 6 (doc/lane_emden_equations.png)

    Parameters
    -----------

    alpha : float
        Alpha parameter from Eq. 6 (doc/lane_emden_equations.png)

    polytropic_index : int
        Parameter used in Lane-Emden model

    central_density : float
        Density at the center of the star [kg/m^3]

    Returns : float
    ---------------

    K parameter from Eq. 6 (doc/lane_emden_equations.png)
    """

    n = polytropic_index
    k = (alpha**2) * 4 * np.pi * constants.G
    k = k / (n + 1)
    k = k / (central_density ** (1 / n - 1))
    return k


def find_gamma(polytropic_index):
    """
    Calculate gamma parameter from Eq. 5 (doc/lane_emden_equations.png)

    Parameters
    -----------

    polytropic_index : int
        Parameter used in Lane-Emden model

    Returns : float
    ---------------

    Gamma parameter from Eq. 5 (doc/lane_emden_equations.png)
    """

    return 1 / polytropic_index + 1


def find_central_pressure(k, central_density, gamma):
    """
    Calculate central pressure using Eq. 4 (doc/lane_emden_equations.png)

    Parameters
    -----------

    k : float
        K parameter from Eq. 6 (doc/lane_emden_equations.png)

    central_density : float
        Density at the center of the star [kg/m^3]

    gamma : float
        Gamma parameter from Eq. 5 (doc/lane_emden_equations.png)

    Returns : float
    ---------------

    Central pressure [Pa] from Eq. 4 (doc/lane_emden_equations.png)
    """

    return k * central_density**gamma


def calculate_scaled_parameters(polytropic_index, step_size):
    """
    Calculates scaled stellar parameter.

    Parameters
    -----------

    polytropic_index : int
        Parameter used in Lane-Emden model

    step_size : float
        Size of the radius step used in integration

    Returns : tuple (xi, theta, dtheta_dxi)
    -----------

    All lists in the tuple have the same size.

    xi : list of float
        Scaled radius parameter from Lane-Emden equation.

    theta : list of float
        Scaled density parameter from Lane-Emden equation.

    dtheta_dxi : list of float
        Derivative of theta with respect to xi.
    """

    x, y = solve_lane_emden(step_size=step_size,
                            polytropic_index=polytropic_index,
                            integrator=runge_kutta_integrator)

    xi = x
    theta = y[:, 0]
    dtheta_dxi = y[:, 1]

    return (xi, theta, dtheta_dxi)


def find_pressure(polytropic_index, central_pressure, theta):
    """
    Calculate pressure in Pa units using Eq. 4 (doc/lane_emden_equations.png)

    Parameters
    -----------

    polytropic_index : int
        Parameter used in Lane-Emden model

    central_pressure : float
        Central pressure [Pa]

    theta : list of float
        List of scaled density values from Lane-Emden equation,
        corresponding to positions from the center to the surface.

    Returns : list of float
    -----------

    Pressure values [Pa] for the stellar model,
    corresponding to positions from the center to the surface.

    """

    return central_pressure * np.power(theta, polytropic_index + 1)


def find_density(polytropic_index, central_density, theta):
    """
    Calculate density in kg/m^3 units using
    Eq. 3 (doc/lane_emden_equations.png)

    Parameters
    -----------

    polytropic_index : int
        Parameter used in Lane-Emden model

    central_density : float
        Central density [kg/m^3]

    theta : list of float
        List of scaled density values from Lane-Emden equation,
        corresponding to positions from the center to the surface.

    Returns : list of float
    -----------

    Density values [kg/m^3] for the stellar model,
    corresponding to positions from the center to the surface.

    """

    return central_density * np.power(theta, polytropic_index)


def find_radius(alpha, xi):
    """
    Calculate radius in meters using Eq. 2 (doc/lane_emden_equations.png)

    Parameters
    -----------

    alpha : float
        Parameter used in Lane-Emden model

    xi : list of float
        Scaled radius using in Lane-Emden equation.

    Returns : list of float
    -----------

    Distances from the center of the star [m]
    """

    return alpha * xi


def find_temperature(mean_molecular_weight, pressures, densities):
    """
    Calculate temperatures [K] using ideal gas equation:

        P = rho * k * T / (mu * m_u),

    where
        rho : density
        k : Boltzmann constant
        T : temperature
        mu : mean molecular weight
        m_u : atomic mass unit

    Parameters
    -----------

    mean_molecular_weight : float
        Mean molecular weight

    pressures : list of float
        Pressure values [Pa] for the stellar model,
        corresponding to positions from the center to the surface.

    densities : list of float
        Density values [kg/m^3] for the stellar model,
        corresponding to positions from the center to the surface.

    Returns : list of float
    -----------

    Temperature values [K] from the center of the star to the surface.
    """

    return pressures * mean_molecular_weight * constants.u / densities \
        / constants.k_B


def plot_title(stellar_mass, central_density, density_unit,
               step_size, polytropic_index, mean_molecular_weight,
               title_prefix):
    """
    Make a plot of pressure vs radius.

    Parameters
    ----------

    stellar_mass : float
        Mass of the stellar modal [kg]

    central_density : float
        Density at the center of the stellar modal [kg / m^3]

    density_unit : str
        Unit for the density.

    step_size : float
        Size of the radius step used in the integration

    polytropic_index : int
        Parameter n used in Lane-Emden equation

    mean_molecular_weight : float
        Mean molecular weight of the stellar model

    title_prefix : str
        Text that will be added at the start of the plot title

    Returns : str
    -------

    Plot title
    """

    title = (
        f"{title_prefix}"
        "Solution of Lane-Emden equation,\n"
        f"n={polytropic_index}, "
        f"M={stellar_mass:.2G}, "
        r"$\rho_c=$"
        f"{central_density.value:.2G} "
        f"{density_unit}, "
        f"h={step_size}, "
        r"$\mu=$"
        f"{mean_molecular_weight}"
    )

    return title


def plot_density(plot_dir, filename, figsize,
                 stellar_mass, central_density,
                 step_size, polytropic_index,
                 mean_molecular_weight,
                 title_prefix,
                 show):
    """
    Make a plot of density vs radius.

    Parameters
    ----------

    plot_dir : str
        Directory where the plot files will be saved

    filename : str
        Name of the plot file where the plot will be saved

    figsize : tuple
        Figure size (width, height)

    stellar_mass : float
        Mass of the stellar modal [kg]

    central_density : float
        Density at the center of the stellar modal [kg / m^3]

    step_size : float
        Size of the radius step used in the integration

    polytropic_index : int
        Parameter n used in Lane-Emden equation

    mean_molecular_weight : float
        Mean molecular weight of the stellar model

    title_prefix : str
        Text that will be added at the start of the plot title

    show : bool
        If False, the plot will not be shown on screen, but only
        save to the file (used in unit tests)
    """

    result = calculate_stellar_parameters(
        step_size=step_size,
        polytropic_index=polytropic_index,
        stellar_mass=stellar_mass,
        central_density=central_density,
        mean_molecular_weight=mean_molecular_weight)

    radii = result["radii"]
    densities = result["densities"]

    plt.figure(figsize=figsize)
    plt.plot(radii.value, densities.value)
    xunit = radii[0].unit.to_string('latex_inline')
    plt.xlabel(f"Radius R [{xunit}]")

    density_unit = densities[0].unit.to_string('latex_inline')

    ylabel = (
        r"Density $\rho$ "
        f"[{density_unit}]"
    )
    plt.ylabel(ylabel)

    title = plot_title(stellar_mass=stellar_mass,
                       central_density=central_density,
                       density_unit=density_unit,
                       step_size=step_size,
                       polytropic_index=polytropic_index,
                       mean_molecular_weight=mean_molecular_weight,
                       title_prefix=title_prefix)

    plt.title(title)
    plt.grid()
    plt.tight_layout()
    save_plot(plt=plt, plot_dir=plot_dir, filename=filename)

    if show:
        plt.show()


def plot_temperature(plot_dir, filename, figsize,
                     stellar_mass, central_density,
                     step_size, polytropic_index,
                     mean_molecular_weight,
                     title_prefix,
                     show):
    """
    Make a plot of temperature vs radius.

    Parameters
    ----------

    plot_dir : str
        Directory where the plot files will be saved

    filename : str
        Name of the plot file where the plot will be saved

    figsize : tuple
        Figure size (width, height)

    stellar_mass : float
        Mass of the stellar modal [kg]

    central_density : float
        Density at the center of the stellar modal [kg / m^3]

    step_size : float
        Size of the radius step used in the integration

    polytropic_index : int
        Parameter n used in Lane-Emden equation

    mean_molecular_weight : float
        Mean molecular weight of the stellar model

    title_prefix : str
        Text that will be added at the start of the plot title

    show : bool
        If False, the plot will not be shown on screen, but only
        save to the file (used in unit tests)
    """

    result = calculate_stellar_parameters(
        step_size=step_size,
        polytropic_index=polytropic_index,
        stellar_mass=stellar_mass,
        central_density=central_density,
        mean_molecular_weight=mean_molecular_weight)

    radii = result["radii"]
    densities = result["densities"]
    temperatures = result["temperatures"]

    plt.figure(figsize=figsize)
    plt.plot(radii.value, temperatures.value)
    xunit = radii[0].unit.to_string('latex_inline')
    plt.xlabel(f"Radius R [{xunit}]")

    density_unit = densities[0].unit.to_string('latex_inline')
    temperature_unit = temperatures[0].unit.decompose()\
        .to_string('latex_inline')

    ylabel = (
        r"Temperature T "
        f"[{temperature_unit}]"
    )
    plt.ylabel(ylabel)

    title = plot_title(stellar_mass=stellar_mass,
                       central_density=central_density,
                       density_unit=density_unit,
                       step_size=step_size,
                       polytropic_index=polytropic_index,
                       mean_molecular_weight=mean_molecular_weight,
                       title_prefix=title_prefix)

    plt.title(title)
    plt.grid()
    plt.tight_layout()
    save_plot(plt=plt, plot_dir=plot_dir, filename=filename)

    if show:
        plt.show()


def plot_pressure(plot_dir, filename, figsize,
                  stellar_mass, central_density,
                  step_size, polytropic_index,
                  mean_molecular_weight,
                  title_prefix,
                  show):

    """
    Make a plot of pressure vs radius.

    Parameters
    ----------

    plot_dir : str
        Directory where the plot files will be saved

    filename : str
        Name of the plot file where the plot will be saved

    figsize : tuple
        Figure size (width, height)

    stellar_mass : float
        Mass of the stellar modal [kg]

    central_density : float
        Density at the center of the stellar modal [kg / m^3]

    step_size : float
        Size of the radius step used in the integration

    polytropic_index : int
        Parameter n used in Lane-Emden equation

    mean_molecular_weight : float
        Mean molecular weight of the stellar model

    title_prefix : str
        Text that will be added at the start of the plot title

    show : bool
        If False, the plot will not be shown on screen, but only
        save to the file (used in unit tests)
    """

    result = calculate_stellar_parameters(
        step_size=step_size,
        polytropic_index=polytropic_index,
        stellar_mass=stellar_mass,
        central_density=central_density,
        mean_molecular_weight=mean_molecular_weight)

    radii = result["radii"]
    densities = result["densities"]
    pressures = result["pressures"]

    plt.figure(figsize=figsize)
    plt.plot(radii.value, pressures.value)
    xunit = radii[0].unit.to_string('latex_inline')
    plt.xlabel(f"Radius R [{xunit}]")

    density_unit = densities[0].unit.to_string('latex_inline')
    pressures_unit = pressures[0].unit.compose()[0].to_string('latex_inline')

    ylabel = (
        r"Pressure P "
        f"[{pressures_unit}]"
    )
    plt.ylabel(ylabel)

    title = plot_title(stellar_mass=stellar_mass,
                       central_density=central_density,
                       density_unit=density_unit,
                       step_size=step_size,
                       polytropic_index=polytropic_index,
                       mean_molecular_weight=mean_molecular_weight,
                       title_prefix=title_prefix)

    plt.title(title)
    plt.grid()
    plt.tight_layout()
    save_plot(plt=plt, plot_dir=plot_dir, filename=filename)

    if show:
        plt.show()
