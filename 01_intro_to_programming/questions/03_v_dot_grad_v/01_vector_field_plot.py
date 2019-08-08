"""
ASP3162
Week 1 Lab exercise

Question 3 (a)

Calculate and plot vector field v dot grad v
"""

import matplotlib.pyplot as plt
import numpy as np


def vector_field(x, y):
    """
    Calculate the vector field

    Parameters
    ----------
    x, y : float or numpy.ndarray
        Position.

    Returns
    -------
    [float, float] or [numpy.ndarray, numpy.ndarray]
        An array containing x and y componets of the vector field
    """

    a = 1

    coefficient = - np.pi * a**2
    x_component = coefficient * np.sin(4 * np.pi * x)
    y_component = coefficient * np.sin(4 * np.pi * y)

    # Make a grid for each component
    size = x.shape[1]
    zeros = np.array([np.zeros(size)])
    x_component_grid = zeros.T + x_component
    y_component_grid = y_component + zeros

    return x_component_grid, y_component_grid


def plot_field(x, y, field, filename):
    """
    Makes a 2D vector plot of the vector field.

    Parameters
    ----------
    x, y : numpy.ndarray
        Positions.
    velocities: [numpy.ndarray, numpy.ndarray]
        An array containing x and y componets of of the vector field
    filename:
        Name of the file where the plot will be saved.
    """

    plt.quiver(x, y, field[0], field[1], color="b")

    plt.title(r"$(\vec{v} \cdot \nabla) \vec{v}$")
    plt.xlabel("x [m]")
    plt.ylabel("y [m]")
    plt.savefig(filename)
    plt.show()


def calculate_and_plot_vector_field():
    """
    Calculates and plots the vector field.
    """

    y, x = np.ogrid[0:1:21j, 0:1:21j]
    field = vector_field(x, y)
    plot_field(x, y, field, "vector_field.pdf")


if __name__ == '__main__':
    calculate_and_plot_vector_field()