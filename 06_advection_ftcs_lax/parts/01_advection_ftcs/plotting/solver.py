# Solve a heat equation
import subprocess
from plot_utils import create_dir
import numpy as np
import os
import struct
import array


def read_solution_from_file(path_to_data):
    """
    Read solution from a binary file. Please refer to README.md
    for description of the binary file format used here.

    Parameters
    ----------
    path_to_data : str
        Path to the binary file containing solution data.


    Returns
    -------
        (x, y, z) tuple
            x, y, and z values of the solution,
            where x and y and 1D arrays, and z is a 2D array.
    """

    data = open(path_to_data, "rb").read()

    # nx: number of x points
    # ----------

    start = 0
    end = 4*3
    (_, nx, _) = struct.unpack("@iii", data[start: end])

    # nt: number of t points
    # ----------

    start = end
    end = start + 4*3
    (_, nt, _) = struct.unpack("@iii", data[start: end])

    # x values
    # ---------

    start = end + 4
    end = start + nx * 8
    x_values = array.array("d")
    x_values.frombytes(data[start:end])

    # t values
    # ---------

    start = end + 8
    end = start + nt * 8
    t_values = array.array("d")
    t_values.frombytes(data[start:end])

    # Solution: 2D array
    # ---------

    start = end + 8
    end = start + nx * nt * 8
    solution = array.array("d")
    solution.frombytes(data[start:end])
    solution = np.reshape(solution, (nt, nx), order='C')

    return (x_values, t_values, solution)


def solve_equation(x_start, x_end, nx,
                   t_start, t_end, method):
    """
    Runs Fortran program that solves equation

        v_t + v v_x = 0

    and returns the solution.

    Parameters
    ----------
    x_start : float
        The smallest x value

    x_end : float
        The largest x value

    nx : int
        The number of x points in the grid

    t_start : float
        The smallest t value

    t_end : float
        The largest t value

    nt : int
        The number of t points in the grid

    method : str
        Numerical method to be used: centered, upwind

    Returns
    -------
        (x, y, z, dx, dt, courant) tuple
            x, y, z :  values of the solution,
                       where x and y and 1D arrays, and z is a 2D array.

            dx, dt  : position and time steps

            dt_dx : ratio dt / dx
    """

    subdir = "tmp"
    create_dir(subdir)
    path_to_data = os.path.join(subdir, "data.bin")

    parameters = [
        (
            f'../build/main {path_to_data}'
            f' --x_start={x_start}'
            f' --x_end={x_end}'
            f' --nx={nx}'
            f' --t_start={t_start}'
            f' --t_end={t_end}'
            f' --method={method}'
        )
    ]

    child = subprocess.Popen(parameters,
                             stdout=subprocess.PIPE,
                             stderr=subprocess.STDOUT,
                             shell=True)

    message = child.communicate()[0].decode('utf-8')
    rc = child.returncode
    success = rc == 0

    if not success:
        print(message)
        return None

    x, y, z = read_solution_from_file(path_to_data)
    dx = x[1] - x[0]
    dt = y[1] - y[0]

    os.remove(path_to_data)
    os.rmdir(subdir)

    dt_dx = dt/dx
    z = np.nan_to_num(z)

    return (x, y, z, dx, dt, dt_dx)
