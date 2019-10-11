import numpy as np
from astropy import constants
from surface import surface_values_single_method
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
    Calculate parameter L using Eq. 6 (doc/lane_embden_equations.png)

    Parameters
    -----------

    alpha : float
        Alpha parameter from Eq. 8 (doc/lane_embden_equations.png)

    polytropic_index : int
        Parameter used in Lane-Embden model

    central_density : float
        Density at the center of the star [kg/m^3]

    Returns : float
    ---------------

    Alpha parameter from Eq. 8 (doc/lane_embden_equations.png)
    """

    n = polytropic_index
    k = (alpha**2) * 4 * np.pi * constants.G
    k = k / (n + 1)
    k = k / (central_density ** (1 / n - 1))
    return k


def find_gamma(polytropic_index):
    """
    Calculate gamma parameter Eq. 5 (doc/lane_embden_equations.png)

    Parameters
    -----------

    polytropic_index : int
        Parameter used in Lane-Embden model

    Returns : float
    ---------------

    Gamma parameter Eq. 5 (doc/lane_embden_equations.png)
    """

    return 1 / polytropic_index + 1
