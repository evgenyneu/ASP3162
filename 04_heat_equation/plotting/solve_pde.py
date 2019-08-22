# Solve a heat equation
import subprocess
from plot_utils import create_dir
import pandas as pd
import numpy as np
import os


def solve_pde(nx, nt, alpha, k):
    """
    Runs Fortran program that solves a heat equation.

    Parameters
    ----------
    nx : int
        Number of x points

    nt : int
        Number of time points

    alpha : float
        Alpha parameter of the forward differencing method that solves the heat equation.
        Values larger than 0.5 reusult in instable solution.

    k : float
        Thermal difusivity of the metal rod.

    Returns
    -------
        dict
            solution and its errors.
    """

    create_dir("tmp")

    parameters = [
        f'../build/main tmp/data tmp/errors --nx={nx} --nt={nt} --alpha={alpha} --k={k}'
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

    df = pd.read_table("tmp/data", sep='\s+', header=None)
    x_values = [df.values[0, 1:]]
    t_values = np.transpose([df.values[1:, 0]])
    temperatures = df.values[1:, 1:]
    temperatures = np.clip(temperatures, 0, 100)

    df = pd.read_table("tmp/errors", sep='\s+', header=None)
    x_values_errors = [df.values[0, 1:]]
    t_values_errors = np.transpose([df.values[1:, 0]])
    temperatures_errors = df.values[1:, 1:]
    temperatures_errors = np.clip(temperatures_errors, 0, 100)

    os.remove("tmp/data")
    os.remove("tmp/errors")
    os.rmdir("tmp")

    return {
        "data": {
            "x_values": x_values,
            "t_values": t_values,
            "temperatures": temperatures
        },
        "errors": {
            "x_values": x_values_errors,
            "t_values": t_values_errors,
            "temperatures": temperatures_errors
        }
    }