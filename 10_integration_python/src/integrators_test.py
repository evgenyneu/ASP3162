import numpy as np
from pytest import approx

from integrators import euler_integrator, improved_euler_integrator, \
                        runge_kutta_integrator


def derivative_exponential(x, y, data):
    """
    Test solving equation

        dy/dx = y

    with initial condition:
        x = 0
        y = 1.

    Analytical solution:

        y = e**x.
    """

    return np.array([y[0]])


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
