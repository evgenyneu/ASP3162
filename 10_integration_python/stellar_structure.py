import numpy as np
from astropy import constants
from surface import surface_values_single_method
from lane_embden_integrator_limited_x import LaneEmbdenIntegratorLimitedX
from runge_kutta_integrator import RungeKuttaIntegrator


def calculate_stellar_parameters(step_size,
                                 polytropic_index,
                                 stellar_mass,
                                 central_density,
                                 mean_molecular_weight):

    """
    Calculate stellar structure parameters using Lane-Embden model.

    Parameters
    -----------

    step_size : float
        Size of the radius step used in integration

    polytropic_index : int
        Parameter used in Lane-Embden model

    stellar_mass : float
        Mass of the tellar model [kg]

    central_density : float
        Density at the center of the star [kg/m^3]

    mean_molecular_weight : float
        Mean molecular weight of the star

    Returns : tuple (radii, temperatures, pressures, densities)
    -----------

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

    surface_values = surface_values_single_method(
        method=RungeKuttaIntegrator, h=step_size, n=polytropic_index)

    return (0, 0, 0, 0)


def find_alpha(xi1, dtheta_dxi_at_xi1, stellar_mass, central_density):
    """
    Calculate alpha parameter using Eq. 8 (doc/lane_embden_equations.png)

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

    Alpha parameter from Eq. 8 (doc/lane_embden_equations.png)
    """

    a = -(xi1**2) * dtheta_dxi_at_xi1

    alpha = stellar_mass / (4 * np.pi * central_density * a)
    alpha = alpha**(1/3)
    return alpha


def find_k(alpha, polytropic_index, central_density):
    """
    Calculate parameter K using Eq. 6 (doc/lane_embden_equations.png)

    Parameters
    -----------

    alpha : float
        Alpha parameter from Eq. 6 (doc/lane_embden_equations.png)

    polytropic_index : int
        Parameter used in Lane-Embden model

    central_density : float
        Density at the center of the star [kg/m^3]

    Returns : float
    ---------------

    K parameter from Eq. 6 (doc/lane_embden_equations.png)
    """

    n = polytropic_index
    k = (alpha**2) * 4 * np.pi * constants.G
    k = k / (n + 1)
    k = k / (central_density ** (1 / n - 1))
    return k


def find_gamma(polytropic_index):
    """
    Calculate gamma parameter from Eq. 5 (doc/lane_embden_equations.png)

    Parameters
    -----------

    polytropic_index : int
        Parameter used in Lane-Embden model

    Returns : float
    ---------------

    Gamma parameter from Eq. 5 (doc/lane_embden_equations.png)
    """

    return 1 / polytropic_index + 1


def find_central_pressure(k, central_density, gamma):
    """
    Calculate central pressure using Eq. 4 (doc/lane_embden_equations.png)

    Parameters
    -----------

    k : float
        K parameter from Eq. 6 (doc/lane_embden_equations.png)

    central_density : float
        Density at the center of the star [kg/m^3]

    gamma : float
        Gamma parameter from Eq. 5 (doc/lane_embden_equations.png)

    Returns : float
    ---------------

    Central pressure [Pa] from Eq. 4 (doc/lane_embden_equations.png)
    """

    return k * central_density**gamma


def calculate_scaled_parameters(polytropic_index, step_size):
    """
    Calculates scaled stellar parameter.

    Parameters
    -----------

    polytropic_index : int
        Parameter used in Lane-Embden model

    step_size : float
        Size of the radius step used in integration

    Returns : tuple (xi, theta, dtheta_dxi)
    -----------

    All lists in the tuple have the same size.

    xi : list of float
        Scaled radius parameter from Lane-Embden equation.

    theta : list of float
        Scaled density parameter from Lane-Embden equation.

    dtheta_dxi : list of float
        Derivative of theta with respect to xi.
    """

    le = LaneEmbdenIntegratorLimitedX(n=polytropic_index)
    x, y = le.integrate(method=RungeKuttaIntegrator, h=step_size)

    xi = x
    theta = y[:, 0]
    dtheta_dxi = y[:, 1]

    return (xi, theta, dtheta_dxi)


def find_pressure(polytropic_index, central_pressure, theta):
    """
    Calculate pressure in Pa units using Eq. 4 (doc/lane_embden_equations.png)

    Parameters
    -----------

    polytropic_index : int
        Parameter used in Lane-Embden model

    central_pressure : float
        Central pressure [Pa]

    theta : list of float
        List of scaled density values from Lane-Embden equation,
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
    Eq. 3 (doc/lane_embden_equations.png)

    Parameters
    -----------

    polytropic_index : int
        Parameter used in Lane-Embden model

    central_density : float
        Central density [kg/m^3]

    theta : list of float
        List of scaled density values from Lane-Embden equation,
        corresponding to positions from the center to the surface.

    Returns : list of float
    -----------

    Density values [kg/m^3] for the stellar model,
    corresponding to positions from the center to the surface.

    """

    return central_density * np.power(theta, polytropic_index)


def find_radius(alpha, xi):
    """
    Calculate radius in meters using Eq. 2 (doc/lane_embden_equations.png)

    Parameters
    -----------

    alpha : float
        Parameter used in Lane-Embden model

    xi : list of float
        Scaled radius using in Lane-Embden equation.

    Returns : list of float
    -----------

    Distances from the center of the star [m]
    """

    return alpha * xi
