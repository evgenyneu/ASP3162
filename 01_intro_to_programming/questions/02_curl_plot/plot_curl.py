"""
ASP3162
Week 1 Lab exercise

Question 2 (b)

Calculate and plot z-component of curl of a velocity vector field.
"""

import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
import numpy as np


def calculate_curl(x, y):
    """
    Calculate z-component of curl for a velocity field.

    Parameters
    ----------
    x, y : float or numpy.ndarray
        Position.

    Returns
    -------
    float or numpy.ndarray
        Z-component value of the curl.
    """

    a = 1
    return 4 * np.pi * a * np.cos(2 * np.pi * x) * np.cos(2 * np.pi * y)


def plot_curl(x, y, curl, filename):
    """
    Makes a 3D surface plot of the z-components of curl of velocity

    Parameters
    ----------
    x, y : numpy.ndarray
        Positions.
    curl: numpy.ndarray
        A 2D array containing values of the z-component of curl.
    filename:
        Name of the file where the plot will be saved.
    """

    fig = plt.figure()
    ax = fig.gca(projection='3d')
    ax.plot_surface(x, y, curl, cmap=cm.bone)
    ax.set_xlabel("x [m]")
    ax.set_ylabel("y [m]")
    ax.set_zlabel("Curl")
    ax.set_title("Z-component of curl of velocity")
    plt.savefig(filename)
    plt.show()


def calculate_and_plot_curl():
    """
    Calculates and plots z-component of curl.
    """

    y, x = np.ogrid[0:1:21j, 0:1:21j]
    curl = calculate_curl(x, y)
    plot_curl(x, y, curl, "curl.pdf")


if __name__ == '__main__':
    calculate_and_plot_curl()