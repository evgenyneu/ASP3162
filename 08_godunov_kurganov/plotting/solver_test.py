from solver import read_solution_from_file, solve_equation
from pytest import approx


def test_read_solution_from_file():
    (x_values, t_values, solution) = read_solution_from_file(
        "plotting/test_data/test_output.dat")

    # x_values
    # -------

    x_values = x_values.tolist()
    assert len(x_values) == 2
    assert x_values == [1.1, 1.2]

    # t_values
    # -------

    t_values = t_values.tolist()
    assert len(t_values) == 3
    assert t_values == [0.1, 0.2, 0.3]

    # solution
    # -------

    assert solution.shape == (3, 2, 1)
    assert solution[0, :, 0].tolist() == [1, 2]
    assert solution[1, :, 0].tolist() == [3, 4]
    assert solution[2, :, 0].tolist() == [5, 6]


def test_solve_equation():
    result = solve_equation(x_start=0, x_end=1,
                            nx=100, t_start=0, t_end=1,
                            method='upwind',
                            initial_conditions='sine',
                            velocity=1, courant_factor=0.5)

    x, y, z, dx, dt, dt_dx = result

    assert dx == approx(0.01, rel=1e-10)
    assert dt == approx(0.005, rel=1e-10)
    assert dt_dx == approx(0.5, rel=1e-10)

    # x
    # --------

    assert len(x) == 100
    assert x[0] == approx(0.005, rel=1e-10)
    assert x[1] == approx(0.015, rel=1e-10)
    assert x[99] == approx(0.995, rel=1e-10)

    # t
    # --------

    assert len(y) == 201
    assert y[0] == approx(0, rel=1e-10)
    assert y[1] == approx(0.005, rel=1e-10)
    assert y[200] == approx(1, rel=1e-10)

    # Solution
    # ---------

    assert z[0, 1] == approx(0.0941083133185, rel=1e-10)
    assert z[0, 20] == approx(0.96029368567, rel=1e-10)
    assert z[0, 99] == approx(-0.031410759078, rel=1e-10)

    assert z[100, 1] == approx(-0.089576252581, rel=1e-10)
    assert z[100, 20] == approx(-0.914047938031, rel=1e-10)
    assert z[100, 99] == approx(0.0298980822175, rel=1e-10)
