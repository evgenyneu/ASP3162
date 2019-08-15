# Plotting solution of x''(t) + x(t) = 0 equation
import numpy as np
import matplotlib.pyplot as plt
import os
from io import StringIO
import pandas as pd
from find_solution import find_solution
from plot_utils import create_dir


def plot_solution(plot_dir, t_end, delta_t):
    data = find_solution(t_end=t_end, delta_t=delta_t)

    create_dir(plot_dir)

    if data is None:
        return

    df = pd.read_csv(StringIO(data), skipinitialspace=True)
    plt.plot(df['t'], df['x'], label='Approximation')

    exact_t = np.arange(0.0, t_end, 0.01)
    exact_x = np.cos(exact_t)

    plt.plot(exact_t, exact_x, label='Exact $x=\cos(t)$', linestyle='--')
    plt.title(r'Solution of $\ddot{x} + x = 0, x(0)=1, \dot{x}(0)=0$ for dt=' + f'{delta_t}')
    plt.xlabel('t')
    plt.ylabel(r'x')
    plt.legend()
    plt.grid()
    plt.tight_layout()
    plotfile = os.path.join(plot_dir, f"approx_vs_exact_dt_{delta_t}.pdf")
    plt.savefig(plotfile)
    plt.show()


if __name__ == '__main__':
    plot_solution(plot_dir="plots", t_end=6.28, delta_t=1)
    plot_solution(plot_dir="plots", t_end=6.28, delta_t=0.1)
