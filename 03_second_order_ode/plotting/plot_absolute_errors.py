# Plotting absolute errors of approximation of solutions of
# of x''(t) + x(t) = 0, x(0)=1, x'(0)=0 equation.
import os
from io import StringIO
import matplotlib.pyplot as plt
import pandas as pd
from find_solution import find_solution
from plot_utils import create_dir


def plot_absolute_errors(plot_dir, t_end, delta_t):
    data = find_solution(t_end=t_end, delta_t=delta_t, print_last=False)

    create_dir(plot_dir)

    if data is None:
        return

    df = pd.read_csv(StringIO(data), skipinitialspace=True)
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
