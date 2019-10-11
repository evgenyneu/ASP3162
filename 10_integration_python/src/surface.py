# Calculate parameters at the surface
import numpy as np
import pandas as pd
import os
from exact_solution import exact, exact_derivative
from plot_utils import find_nearest_index, create_dir

from integrate import integrate, euler_integrator,\
                      improved_euler_integrator, runge_kutta_integrator


def calculate_exact_values_at_surface(x_surface_estimate, n):
    """
    Calculates values of radius and derivative of density at the surface
    using exact estimates.

    Parameters
    ----------

    x_surface_estimate : float
        Estimate of radius at the surface

    n : int
        Parameter in the Lane-Emden equation.

    Returns : dict
    -------

    {
        "method" : str
            Name of the method

        "x_surface" : float
            Radius at the surface

        "density_derivative_surface" : float
            Density derivative at the surface
    }

    """

    x_values = np.linspace(x_surface_estimate * 0.98,
                           x_surface_estimate * 1.02, 1000000)

    item = {}
    y_exact = exact(x_values, n)
    index_zero_density = find_nearest_index(y_exact, 0)
    y_exact_derivative = exact_derivative(x_values, n)
    item["method"] = "Exact"
    item["x_surface"] = x_values[index_zero_density]
    item["density_derivative_surface"] = y_exact_derivative[index_zero_density]
    return item


def surface_values_single_method(integrator, h, n):
    """
    Calculates values of radius and derivative of density at the surface
    for a single integration method

    Parameters
    -----------

    integrator : function
        An integrator function to be used (i.e. Euler or Runge-Kutta)

    h : float
        Step size for the radius.

    n : int
        Parameter in the Lane-Emden equation.
    """

    x, y = integrate(step_size=h,
                     polytropic_index=n,
                     integrator=integrator)

    item = {}
    item["h"] = h
    x_surface = x[-1]
    item["x_surface"] = x_surface
    item["density_derivative_surface"] = y[-1, 1]

    return item


def calculate_surface_values(n):
    """
    Calculates values of radius and derivative of density at the surface
    for different methods of integration, as well as exact estimates.

    Parameters
    -----------

    n : int
        Parameter in the Lane-Emden equation.

    Returns : Panda's DataFrame
    -------

    A dataframe with following columns:

    "h" : float
        Size of the step in radius.

    "method" : str
        Name of the method

    "x_surface" : float
        Radius at the surface

    "density_derivative_surface" : float
        Density derivative at the surface
    """

    items = []

    integrators = [
        {
            "name": "Euler",
            "integrator": euler_integrator
        },
        {
            "name": "Improved Euler",
            "integrator": improved_euler_integrator
        },
        {
            "name": "Runge-Kutta",
            "integrator": runge_kutta_integrator
        }
    ]

    for h in [0.1, 0.01, 0.001]:
        for integrator in integrators:
            item = surface_values_single_method(
                integrator=integrator["integrator"], h=h, n=n)

            item["method"] = integrator["name"]

            items.append(item)

        item = calculate_exact_values_at_surface(
            x_surface_estimate=item["x_surface"], n=n)

        item["h"] = h
        items.append(item)

    return pd.DataFrame(items)


def save_surface_values_to_csv(df, data_dir, filename):
    """
    Save value for the surface in csv

    Parameters
    ----------

    df : Panda's dataframe

    data_dir : str
        Directory for the data.

    filename : str
        Name of the CSV file.
    """

    create_dir(data_dir)
    file_path = os.path.join(data_dir, filename)

    df.to_csv(
        file_path,
        index=False,
        columns=["h", "method", "x_surface", "density_derivative_surface"],
        header=[
            "Step size", "Method", "Radius, xi",
            "Density derivative, d(theta)/d(xi)"])
