# Plotting relative errors of approximation of solutions of
# of x''(t) + x(t) = 0, x(0)=1, x'(0)=0 equation.
import os
from io import StringIO
import matplotlib.pyplot as plt
import pandas as pd
from find_solution import find_solution
from plot_utils import create_dir


def plot_absolute_errors(plot_dir, t_end):
    data_dt_1 = find_solution(t_end=t_end, delta_t=1, print_last=False)
    data_dt_0_1 = find_solution(t_end=t_end, delta_t=0.1, print_last=False)

    create_dir(plot_dir)

    if data_dt_1 is None or data_dt_0_1 is None:
        return

    df_dt_1 = pd.read_csv(StringIO(data_dt_1), skipinitialspace=True)
    df_dt_0_1 = pd.read_csv(StringIO(data_dt_0_1), skipinitialspace=True)
    relative_errors_dt_1 = df_dt_1['abs_error'] / df_dt_1['exact']
    relative_errors_dt_0_1 = df_dt_0_1['abs_error'] / df_dt_0_1['exact']

    plt.plot(df_dt_1['t'], relative_errors_dt_1, label='dt=1', linestyle='--')
    plt.plot(df_dt_0_1['t'], relative_errors_dt_0_1, label='dt=0.1')

    plt.title(r'Relative error for approximage solutions of'
              '\n'
              r'$\ddot{x} + x = 0, x(0)=1, \dot{x}(0)=0$')

    plt.xlabel('t')
    plt.ylabel(r'Relative error')
    plt.grid()
    plt.ylim(-0.2, 0.2)
    plt.tight_layout()
    plt.legend()
    plotfile = os.path.join(plot_dir, f"relative_errors.pdf")
    plt.savefig(plotfile)
    plt.show()


if __name__ == '__main__':
    plot_absolute_errors(plot_dir="plots", t_end=12.56)
