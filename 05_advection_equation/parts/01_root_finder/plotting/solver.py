# Solve a heat equation
import subprocess
from plot_utils import create_dir
import os
import struct
import array


def read_solution_from_file(path_to_data):
    """
    Read solution from the binary file.

    Parameters
    ----------
    path_to_data : str
        Path to the binary file containing solution data.

    The data format
    -----------

    [x]
    [
        Number of x values, nx
        Size: 4 bytes
        Type: signed int
    ]
    [x]

    [x]
    [
        Number of t values, tx
        Size: 4 bytes
        Type: Signed int
    ]
    [x]

    [x]
    [
        x values
        Size: nx * 8 bytes
        Type: Array of double floats. Length nx.
    ]
    [x]

    [x]
    [
        t values
        Size: tx * 8 bytes
        Type: Array of double floats. Length: tx.
    ]
    [x]

    [x]
    [
        2D array containing solution, which are velocity values
        for x and t coordinates: solution[x, t]. The data is
        save in Fortran column-major format: the x-index in incremented first.

        Size: nx * tx 8 bytes
        Type: 2D array of double floats. Length: nx * tx.
    ]
    [x]


    Here [x] means 4-byte separator. This is added by Fortran write's function.
    This separator is put before and after the data block, and its value is the length in bytes
    of this block.
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


    os.remove(path_to_data)
    os.rmdir("tmp")

    # return True