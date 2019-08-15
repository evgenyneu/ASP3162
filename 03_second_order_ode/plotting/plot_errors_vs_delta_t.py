# Plotting errors vs the timesteps
# for approximation of solutions of
# of x''(t) + x(t) = 0, x(0)=1, x'(0)=0.
import os
from io import StringIO
import matplotlib.pyplot as plt
import pandas as pd
from find_solution import find_solution
from plot_utils import create_dir
import numpy as np
from scipy.stats import linregress


def find_abs_errors_at_t(at_t, delta_ts):
    """
    Calculates absolute errors of numerical solution
    of ODE for given values of timesteps

    Parameters
    ----------
    at_t : float
        Value of time variable at which to evaluate the error.

    delta_ts : list of float
        Timestep values

    Returns
    -------
        list of float
            Absolute errors of the numerical solution corresponding to the timesteps `delta_ts`.

    """

    errors = []

    for delta_t in delta_ts:
        data = find_solution(t_end=at_t, delta_t=delta_t)

        if data is None:
            return

        df = pd.read_csv(StringIO(data), skipinitialspace=True)
        t = df['t'].iloc[-1]

        if (abs(t - at_t) > 0.001):
            print("Can not locate the error")
            return None

        abs_error = df['abs_error'].iloc[-1]
        errors.append(abs_error)

    return errors


def calculate_linear_fit_equation(delta_ts, errors):
    """
    Calculates an equation for the linear fit
    for log-log of delta_t and errors.

    Parameters
    ----------
    delta_ts : list of float
        Timestep values

    errors : list of float
        Absolute errors corresponding to the timesteps.

    Returns
    -------
        str
            Equation of the linear fit
    """

    log_dt = np.log(delta_ts)
    log_errors = np.log(errors)
    fit_data = linregress(log_dt,log_errors)
    slope = f"({fit_data.slope:.3f} \pm {fit_data.stderr:.3f})"
    text = "$\log(error) = " + slope + "\ \log(\Delta t) + b$"
    return text


def plot_errors_vs_dt(plot_dir, at_t, delta_ts):
    errors = find_abs_errors_at_t(at_t=at_t, delta_ts=delta_ts)

    if errors is None:
        return

    create_dir(plot_dir)

    delta_t_squared = np.array(delta_ts)**2

    plt.plot(delta_ts, errors, marker="+")

    equation = calculate_linear_fit_equation(delta_ts=delta_ts, errors=errors)

    ax = plt.gca()
    plt.text(0.1, 0.9, equation,
             horizontalalignment='left',
             verticalalignment='top',
             transform=ax.transAxes,
             fontsize=11,
             bbox=dict(facecolor='wheat', alpha=0.8))

    plt.title(r'Absolute errors of numerical solutions of'
              '\n'
              r'$\ddot{x} + x = 0, x(0)=1, \dot{x}(0)=0$')

    plt.xlabel(r'$\Delta t$')
    plt.ylabel(r'Absolute errors at t=11')
    plt.grid()
    plt.tight_layout()
    plt.xscale("log")
    plt.yscale("log")
    plotfile = os.path.join(plot_dir, f"abs_error_vs_dt.pdf")
    plt.savefig(plotfile)
    plt.show()


if __name__ == '__main__':
    delta_ts = [1, 0.5, 0.2, 0.1, 0.05, 0.02, 0.01, 0.005, 0.002, 0.001, 0.0005, 0.0002]
    # delta_ts = [1, 0.5, 0.2, 0.1, 0.05, 0.02, 0.01]
    # delta_ts = [1, 0.5, 0.2, 0.1]
    # delta_ts = [1, 0.5]
    plot_errors_vs_dt(plot_dir="plots", at_t=11.000001, delta_ts=delta_ts)
