from astropy import constants
from astropy import units as u
from pytest import approx

from stellar_structure import calculate_stellar_parameters, \
                              find_alpha,\
                              find_k


def test_find_k():
    alpha = 116177708.60712494
    polytropic_index = 3
    central_density = 1e5 * u.kg / u.meter**3

    result = find_k(alpha=alpha,
                    polytropic_index=polytropic_index,
                    central_density=central_density)

    assert result.value == approx(6097056608.050699, rel=1e-15)


def test_find_alpha():
    xi1 = 6.896
    dtheta_dxi_at_xi1 = -0.042440201016223186
    stellar_mass = 2 * constants.M_sun
    central_density = 1e5 * u.kg / u.meter**3

    result = find_alpha(xi1=xi1,
                        dtheta_dxi_at_xi1=dtheta_dxi_at_xi1,
                        stellar_mass=stellar_mass,
                        central_density=central_density)

    assert result.value == approx(116177708.60712494, rel=1e-15)


def test_calculate_stellar_parameters():
    stellar_mass = 2 * constants.M_sun
    central_density = 1e5 * u.kg / u.meter**3

    radii, temperatures, pressures, densities = calculate_stellar_parameters(
        step_size=0.001,
        polytropic_index=3,
        stellar_mass=stellar_mass,
        central_density=central_density,
        mean_molecular_weight=1.4)
