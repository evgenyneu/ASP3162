# Plotting solution of x''(t) + x(t) = 0 equation
import subprocess
import os
from io import StringIO
import pandas as pd


def find_solution(t_end, delta_t):
    """
    Runs Fortran program that returns solution of

        x''(t) + x(t) = 0

    Parameters
    ----------
    t_end : float
        The end interval for t.

    delta_t : float
        The timestep.

    Returns
    -------
        str
            the solution in CSV format, or None if error occured.
    """

    parameters = [
        f'../build/main --delta_t={delta_t} --t_end={t_end}'
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

    return message


def make_plots_dir(plot_dir):
    plots_dir = "plot_dir"

    if not os.path.exists(plot_dir):
        os.makedirs(plot_dir)


def plot_absolute_errors(plot_dir, t_end, delta_t):
    data = find_solution(t_end=t_end, delta_t=delta_t)

    make_plots_dir(plot_dir)

    if data is None:
        return

    df = pd.read_csv(StringIO(data), skipinitialspace=True)
    print(df.columns)
    plt.plot(df['t'], df['abs_error'])

    plt.title(r'Absolute error for approximage solution of'
              '\n'
              r'$\ddot{x} + x = 0, x(0)=1, \dot{x}(0)=0$ for dt=' + f'{delta_t}')

    plt.xlabel('t')
    plt.ylabel(r'Absolute error')
    plt.grid()
    plt.tight_layout()
    plotfile = os.path.join(plot_dir, f"abs_error_dt_{delta_t}.pdf")
    plt.savefig(plotfile)
    plt.show()


if __name__ == '__main__':
    plot_absolute_errors(plot_dir="plots", t_end=12.56, delta_t=1)
    plot_absolute_errors(plot_dir="plots", t_end=12.56, delta_t=0.1)
