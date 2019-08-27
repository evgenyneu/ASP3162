# Solve a heat equation
import subprocess
from plot_utils import create_dir
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

    The data format
    -----------

    Here is how data is saved in the binary file:

    [x]
    [
        nx: number of x values
        Size: 4 bytes
        Type: signed int
    ]
    [x]

    [x]
    [
        tx: number of t values
        Size: 4 bytes
        Type: Signed int
    ]
    [x]

    [x]
    [
        x_values
        Size: nx * 8 bytes
        Type: Array of double floats. Length nx.
    ]
    [x]

    [x]
    [
        t_values
        Size: tx * 8 bytes
        Type: Array of double floats. Length: tx.
    ]
    [x]

    [x]
    [
        solution: 2D array containing solution, which are velocity values
        for x and t coordinates.

        Size: nx * tx 8 bytes
        Type: 2D array of double floats. Length: nx * tx.
    ]
    [x]

    Notes:

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

    # Read nx and nt
    # ----------

    start = 0
    end = 4*3
    (_, nx, _) = struct.unpack("@iii", data[start: end])

    start = end
    end = start + 4*3
    (_, nt, _) = struct.unpack("@iii", data[start: end])
    print(nx)
    print(nt)

    # x values
    # ---------

    start = end + 4
    end = start + nx * 8
    x_values = array.array("d")
    x_values.frombytes(data[start:end])
    print(x_values)

    # x values
    # ---------

    start = end + 8
    end = start + nt * 8
    t_values = array.array("d")
    t_values.frombytes(data[start:end])
    print(t_values)

    # Solution (2D array)
    # ---------

    start = end + 8
    end = start + nx * nt * 8
    solution = array.array("d")
    solution.frombytes(data[start:end])
    print(solution)


def solve_equation():
    """
    Runs Fortran program that solves equation

        cos(x - v * t) - v = 0

    Returns
    -------
        dict
            Solution
    """

    create_dir("tmp")
    path_to_data = "tmp/data.bin"

    parameters = [
        f'../build/main {path_to_data}'
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

    read_solution_from_file(path_to_data)

    os.remove(path_to_data)
    os.rmdir("tmp")

    # return True