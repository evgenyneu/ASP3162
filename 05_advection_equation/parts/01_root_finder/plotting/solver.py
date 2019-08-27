# Solve a heat equation
import subprocess
from plot_utils import create_dir
import os
import struct


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

    data = open(path_to_data, "rb").read()
    unpacked = struct.unpack("@iiiii", data[:20])
    print(unpacked)

    # df = pd.read_table("tmp/data", sep='\s+', header=None)
    # x_values = [df.values[0, 1:]]
    # t_values = np.transpose([df.values[1:, 0]])
    # temperatures = df.values[1:, 1:]
    # temperatures = np.clip(temperatures, 0, 100)

    # df = pd.read_table("tmp/errors", sep='\s+', header=None)
    # x_values_errors = [df.values[0, 1:]]
    # t_values_errors = np.transpose([df.values[1:, 0]])
    # temperatures_errors = df.values[1:, 1:]
    # temperatures_errors = np.clip(temperatures_errors, 0, 100)

    os.remove(path_to_data)
    os.rmdir("tmp")

    # return True