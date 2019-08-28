# Solve a heat equation
import subprocess
from plot_utils import create_dir
import numpy as np
import os
import struct
import array


def read_solution_from_file(path_to_data):
    """
    Read solution from a binary file.

    Parameters
    ----------
    path_to_data : str
        Path to the binary file containing solution data.


    Returns
    -------
        (x, y, z) tuple
            x, y, and z values of the solution,
            where x and y and 1D arrays, and z is a 2D array.


    The data format
    -----------

    Here is how data is stored in the binary file:

    [x]
    [
        nx: number of x values
        Size: 4 bytes
        Type: signed int
    ]
    [x]

    [x]
    [
        nt: number of t values
        Size: 4 bytes
        Type: Signed int
    ]
    [x]

    [x]
    [
        x_values: array of x values
        Size: nx * 8 bytes
        Type: Array of double floats. Length nx.
    ]
    [x]

    [x]
    [
        t_values: array of t values
        Size: nt * 8 bytes
        Type: Array of double floats. Length: tx.
    ]
    [x]

    [x]
    [
        solution: a 2D array containing solution. These are velocity values
        for x and t coordinates.

        Size: nx * nt * 8 bytes
        Type: 2D array of double floats. Length: nx * nt.
    ]
    [x]

    Notes
    ------

    * Here [x] means 4-byte separator. This is added by Fortran's `write`
    function. This separator is written before and after a data block,
    and its value is the length in bytes of this block.

    * `solution` is a 2D array saved as a sequence of double precision
    float numbers in the column-major order. For example, for nx=3, nt=2,
    the data will be saved as:

        [1, 1] [2, 1] [3, 1] [1, 2] [2, 2] [3, 2],

    where first index is x and second index is t.
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
                   t_start, t_end, nt,
                   v_start, tolerance, max_iterations):
    """
    Runs Fortran program that solves equation

        cos(x - v * t) - v = 0

    and returns the solution.

    Returns
    -------
        (x, y, z) tuple
            x, y, and z values of the solution,
            where x and y and 1D arrays, and z is a 2D array.
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
            f' --nt={nt}'
            f' --v_start={v_start}'
            f' --tolerance={tolerance}'
            f' --max_iterations={max_iterations}'
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

    # print(message)

    x, y, z = read_solution_from_file(path_to_data)

    os.remove(path_to_data)
    os.rmdir(subdir)

    return (x, y, z)
