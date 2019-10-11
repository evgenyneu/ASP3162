from astropy import constants
from astropy import units as u
from stellar_structure import calculate_stellar_parameters


def test_calculate_stellar_parameters():
    stellar_mass = 2 * constants.M_sun
    central_density = 1e5 * u.kg / u.meter**3

    radii, temperatures, pressures, densities = calculate_stellar_parameters(
        step_size=0.001,
        polytropic_index=3,
        stellar_mass=stellar_mass,
        central_density=central_density,
        mean_molecular_weight=1.4)
