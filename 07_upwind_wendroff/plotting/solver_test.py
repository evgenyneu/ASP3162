from solver import read_solution_from_file
from pytest import approx
import numpy as np


def test_read_solution_from_file():
    (x_values, t_values, solution) = read_solution_from_file("plotting/test_data/test_output.dat")

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

    assert solution.shape == (3, 2)
    assert solution[0, :].tolist() == [1, 2]
    assert solution[1, :].tolist() == [3, 4]
    assert solution[2, :].tolist() == [5, 6]


# def test_calculate_orbit():
#     result = calculate_orbit(tmax=10 * np.pi, nt=3142, eccentricity=0)
#     (times, positions, velocities) = result

#     # times
#     # -------

#     times = times.tolist()
#     assert len(times) == 3142
#     assert times[0] == 0
#     assert times[1] == approx(0.01000188683, rel=1e-10)
#     assert times[3141] == approx(31.4159265359, rel=1e-10)

#     # positions
#     # -------

#     assert positions.shape == (3142, 3)

#     # Initial position
#     assert positions[0, :] == approx([1, 0, 0], rel=1e-10)

#     # After one iteration
#     assert positions[1, :] == approx(
#         [0.9999499811, 0.01000188683091, 0],
#         rel=1e-10)

#     # At angle pi/2
#     assert positions[157, :] == approx(
#         [0.0005024508275483, 1.0000248703756, 0],
#         rel=1e-10)

#     # At angle 10 * pi, returned to initial state
#     assert positions[3141, :] == approx(
#         [0.9999994513, -0.00104755262807, 0],
#         rel=1e-10)

#     # velocities
#     # -------

#     assert velocities.shape == (3142, 3)

#     # Initial position
#     assert velocities[0, :] == approx([0, 1, 0], rel=1e-10)

#     # After one iteration
#     assert velocities[1, :] == approx(
#         [-0.010001636670, 0.99994998113, 0],
#         rel=1e-10)

#     # At angle pi/2
#     assert velocities[157, :] == approx(
#         [-0.999974865239, 0.000527435138589, 0],
#         rel=1e-10)

#     # At angle 10 * pi, returned to initial state
#     assert velocities[3141, :] == approx(
#         [0.0010475460769, 0.9999994513226, 0],
#         rel=1e-10)
