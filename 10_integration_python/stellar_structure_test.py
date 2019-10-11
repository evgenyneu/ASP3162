from astropy import constants
from astropy import units as u
from pytest import approx

from stellar_structure import calculate_stellar_parameters, \
                              find_alpha,\
                              find_k, \
                              find_gamma, \
                              find_central_pressure, \
                              calculate_scaled_parameters


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


def test_find_gamma():
    result = find_gamma(polytropic_index=3)

    assert float(result) == approx(1.3333333333333333, rel=1e-15)


def test_find_central_pressure():
    k = 6097056608.050699
    central_density = 1e5 * u.kg / u.meter**3
    gamma = 1.3333333333333333

    result = find_central_pressure(
        k=k, central_density=central_density, gamma=gamma)

    assert result.value == approx(2.8300029869833104e16, rel=1e-15)


def test_calculate_scaled_parameters():
    xi, theta, dtheta_dxi = calculate_scaled_parameters(
        polytropic_index=1, step_size=0.001)

    assert len(xi) == 3142
    assert len(theta) == 3142
    assert len(dtheta_dxi) == 3142

    # xi
    # --------

    assert xi[0] == approx(0, rel=1e-15)
    assert xi[1400] == approx(1.3999999999999566, rel=1e-15)
    assert xi[-1] == approx(3.140999999999765, rel=1e-15)

    # theta
    # --------

    assert theta[0] == approx(1, rel=1e-15)
    assert theta[1400] == approx(0.7038926643002749, rel=1e-15)
    assert theta[-1] == approx(0.00018868302096028763, rel=1e-15)

    # dtheta_dxi
    # --------

    assert dtheta_dxi[0] == approx(0, rel=1e-15)
    assert dtheta_dxi[1400] == approx(-0.38137537255970344, rel=1e-15)
    assert dtheta_dxi[-1] == approx(-0.3184299609685312, rel=1e-15)


def test_find_pressure():
    central_pressure = 2.8300029869833104e16
    # polytropic_index = 3
    # theta = []

    # find_pressure(central_pressure)
