import numpy as np
from pytest import approx

from integrators import euler_integrator, improved_euler_integrator, \
                        runge_kutta_integrator


def derivative_exponential(x, dependent_variables, data):
    """
    Test solving equation

        dy/dx = y

    with initial condition:
        x = 0
        y = 1.

    Analytical solution:

        y = e**x.
    """

    return np.array([dependent_variables[0]])


def test_euler_integrator():
    # Initial conditions
    x = 0
    y = [1]
    all_x = []
    all_y = []

    for i in range(21):
        all_x.append(x)
        all_y.append(y)

        x, y = euler_integrator(h=0.1,
                                derivative=derivative_exponential,
                                data=None,
                                x=x, y=y)

    # Verify x
    # --------

    assert len(all_x) == 21
    assert all_x[0] == 0
    assert all_x[1] == approx(0.1, rel=1e-10)
    assert all_x[10] == approx(1, rel=1e-10)
    assert all_x[20] == approx(2, rel=1e-10)

    # Verify y
    # --------

    assert len(all_y) == 21
    assert all_y[0][0] == 1
    assert all_y[10][0] == approx(2.5937424601, rel=1e-15)  # e
    assert all_y[20][0] == approx(6.727499949325601, rel=1e-15)  # e^2


def test_improved_euler_integrator():
    # Initial conditions
    x = 0
    y = [1]
    all_x = []
    all_y = []

    for i in range(21):
        all_x.append(x)
        all_y.append(y)

        x, y = improved_euler_integrator(h=0.1,
                                         derivative=derivative_exponential,
                                         data=None,
                                         x=x, y=y)

    # Verify x
    # --------

    assert len(all_x) == 21
    assert all_x[0] == 0
    assert all_x[1] == approx(0.1, rel=1e-10)
    assert all_x[10] == approx(1, rel=1e-10)
    assert all_x[20] == approx(2, rel=1e-10)

    # Verify y
    # --------

    assert len(all_y) == 21
    assert all_y[0][0] == 1
    assert all_y[10][0] == approx(2.714080846608224, rel=1e-15)  # e
    assert all_y[20][0] == approx(7.366234841925615, rel=1e-15)  # e^2


def test_runge_kutta_integrator():
    # Initial conditions
    x = 0
    y = [1]
    all_x = []
    all_y = []

    for i in range(21):
        all_x.append(x)
        all_y.append(y)

        x, y = runge_kutta_integrator(h=0.1,
                                      derivative=derivative_exponential,
                                      data=None,
                                      x=x, y=y)

    # Verify x
    # --------

    assert len(all_x) == 21
    assert all_x[0] == 0
    assert all_x[1] == approx(0.1, rel=1e-10)
    assert all_x[10] == approx(1, rel=1e-10)
    assert all_x[20] == approx(2, rel=1e-10)

    # Verify y
    # --------

    assert len(all_y) == 21
    assert all_y[0][0] == 1
    assert all_y[10][0] == approx(2.718279744135166, rel=1e-15)  # e
    assert all_y[20][0] == approx(7.389044767375541, rel=1e-15)  # e^2

# ------------------------------------
#
# System of two diffential equations
#
# ------------------------------------

def derivative_two(x, dependent_variables, data):
    """
    Test solving system of equations:

        dy/dx = z
        dz/dx = -y

    with initial condition:
        x = 0
        y = 1
        z = 0.5
    """

    return np.array(
        [
            dependent_variables[1],  # dy/dx = z
            -dependent_variables[0],  # dz/dx = -y
        ]
    )


def test_euler_two_equations():
    # Initial conditions
    x = 0
    dependent_variables = np.array([1, 0.5])
    all_x = [x]
    all_dependent_variables = np.array([dependent_variables])

    for i in range(101):
        x, dependent_variables = euler_integrator(
            h=0.02,
            derivative=derivative_two,
            data=None,
            x=x, y=dependent_variables)

        all_x.append(x)

        all_dependent_variables = np.append(
            all_dependent_variables, [dependent_variables], axis=0)

    # Verify x
    # --------

    assert all_x[0] == approx(0, rel=1e-6)
    assert all_x[1] == approx(0.02, rel=1e-6)
    assert all_x[2] == approx(0.04, rel=1e-6)
    assert all_x[100] == approx(2, rel=1e-6)

    # Verify y
    # --------

    y = all_dependent_variables[:, 0]
    assert y[0] == approx(1, rel=1e-15)
    assert y[1] == approx(1.01, rel=1e-15)
    assert y[2] == approx(1.0196, rel=1e-15)
    assert y[3] == approx(1.028796, rel=1e-15)
    assert y[100] == approx(0.039583418607340215, rel=1e-15)

    # Verify z
    # --------

    z = all_dependent_variables[:, 1]
    assert z[0] == approx(0.5, rel=1e-15)
    assert z[1] == approx(0.48, rel=1e-15)
    assert z[2] == approx(0.4598, rel=1e-15)
    assert z[3] == approx(0.439408, rel=1e-15)
    assert z[100] == approx(-1.1399281623946178, rel=1e-15)


def test_improved_euler_two_equations():
    # Initial conditions
    x = 0
    dependent_variables = np.array([1, 0.5])
    all_x = [x]
    all_dependent_variables = np.array([dependent_variables])

    for i in range(101):
        x, dependent_variables = improved_euler_integrator(
            h=0.02,
            derivative=derivative_two,
            data=None,
            x=x, y=dependent_variables)

        all_x.append(x)

        all_dependent_variables = np.append(
            all_dependent_variables, [dependent_variables], axis=0)

    # Verify x
    # --------

    assert all_x[0] == approx(0, rel=1e-6)
    assert all_x[1] == approx(0.02, rel=1e-6)
    assert all_x[2] == approx(0.04, rel=1e-6)
    assert all_x[100] == approx(2, rel=1e-6)

    # Verify y
    # --------

    y = all_dependent_variables[:, 0]
    assert y[0] == approx(1, rel=1e-15)
    assert y[1] == approx(1.0098, rel=1e-15)
    assert y[2] == approx(1.01919604, rel=1e-15)
    assert y[3] == approx(1.028184361192, rel=1e-15)
    assert y[100] == approx(0.03835298833102184, rel=1e-15)

    # Verify z
    # --------

    z = all_dependent_variables[:, 1]
    assert z[0] == approx(0.5, rel=1e-15)
    assert z[1] == approx(0.4799, rel=1e-15)
    assert z[2] == approx(0.45960802, rel=1e-15)
    assert z[3] == approx(0.439132177596, rel=1e-15)
    assert z[100] == approx(-1.1173782028910264, rel=1e-15)


def test_runge_kutta_two_equations():
    # Initial conditions
    x = 0
    dependent_variables = np.array([1, 0.5])
    all_x = [x]
    all_dependent_variables = np.array([dependent_variables])

    for i in range(101):
        x, dependent_variables = runge_kutta_integrator(
            h=0.02,
            derivative=derivative_two,
            data=None,
            x=x, y=dependent_variables)

        all_x.append(x)

        all_dependent_variables = np.append(
            all_dependent_variables, [dependent_variables], axis=0)

    # Verify x
    # --------

    assert all_x[0] == approx(0, rel=1e-6)
    assert all_x[1] == approx(0.02, rel=1e-6)
    assert all_x[2] == approx(0.04, rel=1e-6)
    assert all_x[100] == approx(2, rel=1e-6)

    # Verify y
    # --------

    y = all_dependent_variables[:, 0]
    assert y[0] == approx(1, rel=1e-15)
    assert y[1] == approx(1.00979934000, rel=1e-15)
    assert y[2] == approx(1.01919477372888, rel=1e-15)
    assert y[3] == approx(1.02818254313842972, rel=1e-15)
    assert y[100] == approx(0.03850187984321721, rel=1e-15)

    # Verify z
    # --------

    z = all_dependent_variables[:, 1]
    assert z[0] == approx(0.5, rel=1e-15)
    assert z[1] == approx(0.47990133666666668, rel=1e-15)
    assert z[2] == approx(0.45961071919779561, rel=1e-15)
    assert z[3] == approx(0.4391362635698148, rel=1e-15)
    assert z[100] == approx(-1.11737084494693772, rel=1e-15)
