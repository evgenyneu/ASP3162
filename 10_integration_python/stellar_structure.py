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
        Mass of the star in our model [kg]

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

    return (0, 0, 0, 0)
