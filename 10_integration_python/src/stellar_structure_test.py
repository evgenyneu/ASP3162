from astropy import constants
from astropy import units as u
from pytest import approx

from stellar_structure import calculate_stellar_parameters, \
                              find_alpha,\
                              find_k, \
                              find_gamma, \
                              find_central_pressure, \
                              calculate_scaled_parameters, \
                              find_pressure, \
                              find_density, \
                              find_radius, \
                              find_temperature


def test_calculate_stellar_parameters():
    stellar_mass = 2 * constants.M_sun
    central_density = 1e5 * u.kg / u.meter**3

    result = calculate_stellar_parameters(
        step_size=0.001,
        polytropic_index=3,
        stellar_mass=stellar_mass,
        central_density=central_density,
        mean_molecular_weight=1.4)

    radii = result["radii"]
    temperatures = result["temperatures"]
    pressures = result["pressures"]
    densities = result["densities"]

    assert len(radii) == 6897
    assert len(temperatures) == 6897
    assert len(pressures) == 6897
    assert len(densities) == 6897

    # radii
    # ---------

    assert radii[0].unit == u.m
    assert radii[0].value == approx(0, rel=1e-15)
    assert radii[1400].value == approx(162648792.04996988, rel=1e-13)
    assert radii[-1].value == approx(801161478.5548077, rel=1e-13)

    # temperatures
    # ---------

    assert temperatures[0].unit == u.K
    assert temperatures[0].value == approx(47651973.15014357, rel=1e-15)
    assert temperatures[1400].value == approx(35618172.97845829, rel=1e-15)
    assert temperatures[-1].value == approx(1716.003715107512, rel=1e-15)

    # pressures
    # ---------

    assert pressures[0].unit == u.Pa
    assert pressures[0].value == approx(2.8300029869829612e+16, rel=1e-15)
    assert pressures[1400].value == approx(8833847448327913.0, rel=1e-15)
    assert pressures[-1].value == approx(0.04759224978521558, rel=1e-15)

    # densities
    # ---------

    assert densities[0].unit == u.kg / u.m**3
    assert densities[0].value == approx(100000, rel=1e-15)
    assert densities[1400].value == approx(41761.130899912016, rel=1e-15)
    assert densities[-1].value == approx(4.669947584135971e-9, rel=1e-15)


def test_find_k():
    alpha = 116177708.60712494 * u.meter
    polytropic_index = 3
    central_density = 1e5 * u.kg / u.meter**3

    result = find_k(alpha=alpha,
                    polytropic_index=polytropic_index,
                    central_density=central_density)

    assert result.value == approx(6097056608.050699, rel=1e-15)
    assert result.unit == u.m**3 / (u.kg**(1/3) * u.s**2)


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
    central_pressure = 2.8300029869833104e16 * u.pascal
    polytropic_index = 3

    xi, theta, dtheta_dxi = calculate_scaled_parameters(
        polytropic_index=3, step_size=0.001)

    result = find_pressure(polytropic_index=polytropic_index,
                           central_pressure=central_pressure,
                           theta=theta)

    assert len(result) == 6897
    assert result[0].unit == u.pascal
    assert result[0].value == approx(2.8300029869833104e+16, rel=1e-15)
    assert result[1400].value == approx(8833847448329003, rel=1e-15)
    assert result[-1].value == approx(0.04759224978521558, rel=1e-15)


def test_find_density():
    central_density = 1e5 * u.kg / u.meter**3
    polytropic_index = 3

    xi, theta, dtheta_dxi = calculate_scaled_parameters(
        polytropic_index=3, step_size=0.001)

    result = find_density(polytropic_index=polytropic_index,
                          central_density=central_density,
                          theta=theta)

    assert len(result) == 6897
    assert result[0].unit == u.kg / u.m**3
    assert result[0].value == approx(100000, rel=1e-15)
    assert result[1400].value == approx(41761.130899912016, rel=1e-15)
    assert result[-1].value == approx(4.669947584135971e-9, rel=1e-15)


def test_find_radius():
    alpha = 116177708.60712494 * u.meter

    xi, theta, dtheta_dxi = calculate_scaled_parameters(
        polytropic_index=3, step_size=0.001)

    result = find_radius(alpha=alpha, xi=xi)

    assert len(result) == 6897
    assert result[0].unit == u.m
    assert result[0].value == approx(0, rel=1e-15)
    assert result[1400].value == approx(162648792.04996988, rel=1e-15)
    assert result[-1].value == approx(801161478.5548077, rel=1e-15)


def test_find_temperature():
    mean_molecular_weight = 1.4
    central_pressure = 2.8300029869833104e16 * u.pascal
    central_density = 1e5 * u.kg / u.meter**3
    polytropic_index = 3

    xi, theta, dtheta_dxi = calculate_scaled_parameters(
        polytropic_index=3, step_size=0.001)

    pressures = find_pressure(
        polytropic_index=polytropic_index,
        central_pressure=central_pressure,
        theta=theta)

    densities = find_density(polytropic_index=polytropic_index,
                             central_density=central_density,
                             theta=theta)

    result = find_temperature(
        mean_molecular_weight=mean_molecular_weight,
        pressures=pressures,
        densities=densities
    )

    assert len(result) == 6897
    assert result[0].unit == u.K
    assert result[0].value == approx(47651973.15014945, rel=1e-15)
    assert result[1400].value == approx(35618172.978462696, rel=1e-15)
    assert result[-1].value == approx(1716.0037151077242, rel=1e-15)
