# Plotting failure ratio of root finding Newton-Raphson method
# for cos(x) - x = 0 equation for different number of maximum iterations
import subprocess
import numpy as np
import matplotlib.pyplot as plt
import os


def find_root(x_value, max_iterations):
    """
    Runs root finding Fortran program.

    Parameters
    ----------
    x_value : float
        Starting x value for the root finding method.

    max_iterations : int
        Maximum number of iterations for the root finding method

    Returns
    -------
        Dictionary containing two keys:
            "root": float
                The approximated root value. 0 of no root found.
            "success": bool
                True if root was found successfully.
    """

    parameters = [
        '../build/main', str(x_value),
        f'--max_iterations={max_iterations}'
    ]

    child = subprocess.Popen(parameters,
                             stdout=subprocess.PIPE,
                             stderr=subprocess.STDOUT)

    message = child.communicate()[0].decode('utf-8')
    rc = child.returncode
    root_value = 0
    success = rc == 0

    try:
        root_value = float(message)
    except ValueError:
        success = False

    return {
        "root": root_value,
        "success": success
    }


def plot_fail_rate_vs_x(max_iterations, plots_dir):
    """
    Plots the rate of failures for the root finding method vs
    the starting x value.

    Parameters
    ----------
    max_iterations : int
        Maximum number of iterations for the root finding method

    plots_dir : string
        Directory containing plots

    Returns
    -------
        Dictionary containing two keys:
            "root": float
                The approximated root value. 0 of no root found.
            "success": bool
                True if root was found successfully.
    """

    # calculations needed for finding failure rate
    bin_size_steps = 20
    start_bin = None
    end_bin = None
    step = 0.01
    stepno = 0

    successes = 0
    failures = 0

    successes_total = 0
    failures_total = 0

    centers = []
    failure_ratios = []

    min_x = -10
    max_x = 10

    # Loop over the starting x values
    for x in np.arange(min_x, max_x, step):
        stepno += 1

        if stepno % bin_size_steps == 0:
            # We are at the end of our bin
            if start_bin is None:
                start_bin = x
            else:
                end_bin = x
                # Calculate the failure rate at the middle of the bin
                failure_ratio = float(failures) / (successes + failures)
                centers.append((start_bin + end_bin) / 2)
                failure_ratios.append(failure_ratio)
                successes = 0
                failures = 0
                start_bin = end_bin

        result = find_root(x, max_iterations=max_iterations)

        # Count successes and failures
        if result["success"]:
            successes += 1
            successes_total += 1
        else:
            failures += 1
            failures_total += 1

    plt.plot(centers, failure_ratios, color='purple')

    plt.title(f'Failure ratio for Newton-Raphson root finding method\n'
              f'for $\cos(x) - x = 0$\nusing {max_iterations} maximum iterations')

    plt.xlabel('Starting x value')
    plt.ylabel('Failure ratio: # failures / # total')
    plt.grid()
    plt.tight_layout()
    plotfile = os.path.join(plots_dir, f"plot_max_iterations_{max_iterations}.pdf")
    plt.savefig(plotfile)
    plt.show()

    total_failure_rate = float(failures_total) / (successes_total + failures_total)
    return total_failure_rate


def make_plots():
    """
    Makes plots the rate of failures for the root finding method vs
    the starting x value for different values of maximum iterations.

    Make a plot of total failure rate vs maximum iterations.
    """

    plots_dir = "plots"

    if not os.path.exists(plots_dir):
        os.makedirs(plots_dir)

    list_iterations = []
    failure_ratios = []

    for max_iterations in [1, 5, 10, 20, 50, 100, 1000, 10000, 100000, 1000000]:
        failure_rate = plot_fail_rate_vs_x(max_iterations, plots_dir=plots_dir)
        list_iterations.append(max_iterations)
        failure_ratios.append(failure_rate)

    plt.plot(list_iterations, failure_ratios, color='purple')
    plt.title('Failure ratio for Newton-Raphson root finding method\nfor $\cos(x) - x = 0$')
    plt.xlabel('Maximum number of iterations')
    plt.ylabel('Failure ratio: # failures / # total')
    plt.xscale('symlog')
    plt.grid()
    plt.tight_layout()
    plotfile = os.path.join(plots_dir, "total_failure_ratio.pdf")
    plt.savefig()
    plt.show()


if __name__ == '__main__':
    make_plots()
