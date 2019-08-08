"""
ASP3162
Week 1 Lab exercise

Question 2 (a)

Calculate and plot velocities on a 2D vector plot.
"""

import matplotlib.pyplot as plt
import numpy as np


def velocity(x, y):
    """
    Calculate velocity 2D vector given x and y positions.

    Parameters
    ----------
    x, y : float or numpy.ndarray
        Position.

    Returns
    -------
    [float, float] or [numpy.ndarray, numpy.ndarray]
        An array containing x and y componets of velocity
    """

    a = 1
    velocity_x = -a * (np.cos(2 * np.pi * x) * np.sin(2 * np.pi * y))
    print(velocity_x.shape)
    velocity_y = a * (np.sin(2 * np.pi * x) * np.cos(2 * np.pi * y))

    return velocity_x, velocity_y


def plot_velocity(x, y, velocities, filename):
    """
    Makes a 2D vector plot of the velocity field.

    Parameters
    ----------
    x, y : numpy.ndarray
        Positions.
    velocities: [numpy.ndarray, numpy.ndarray]
        An array containing x and y componets of velocity
    filename:
        Name of the file where the plot will be saved.
    """

    plt.quiver(x, y, velocities[0], velocities[1], color="b")

    plt.title("Velocities")
    plt.xlabel("x [m]")
    plt.ylabel("y [m]")
    plt.savefig(filename)
    # plt.show()


def calculate_and_plot_velocities():
    """
    Calculates and plots velocities.
    """

    y, x = np.ogrid[0:1:21j, 0:1:21j]
    velocities = velocity(x, y)
    plot_velocity(x, y, velocities, "velocity.pdf")


if __name__ == '__main__':
    calculate_and_plot_velocities()