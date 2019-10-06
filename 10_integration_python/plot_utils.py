# Various shared functions used by plotting scripts
import os
from itertools import cycle


def save_plot(plt, plot_dir, filename):
    """
    Saves plot figure to a file.

    Parameters
    ----------

    plt :
        Matplotlib's plot object

    plot_dir : str
        Directory where the plot files will be saved

    filename : str
        Name of the plot file where the plot will be saved
    """

    create_dir(plot_dir)
    plot_file = os.path.join(plot_dir, filename)
    plt.savefig(plot_file)


def create_dir(dir):
    """
    Creates a directory if it does not exist.

    Parameters
    ----------
    dir : str
        Directory path, can be nested directories.

    """

    if not os.path.exists(dir):
        os.makedirs(dir)


def get_linestyles_cycler():
    """
    Returns a cycler that is used to get different line styles for plots.
    Usage:

    ```
    cycler = get_linestyles_cycler()
    linestyle = next(cycler)
    plt.plot(..., linestyle=linestyle)
    ```
    """

    line_styles = get_linestyles()
    return cycle(line_styles)


def get_linestyles():
    """
    Returns a list of line styles.

    Source: https://matplotlib.org/3.1.0/gallery/lines_bars_and_markers/linestyles.html
    """

    linestyle_tuple = [
         ('solid', 'solid'),      # Same as (0, ()) or '-'
         ('dotted', 'dotted'),    # Same as (0, (1, 1)) or '.'
         ('dashed', 'dashed'),    # Same as '--'
         ('dashdot', 'dashdot'),
         ('dotted',                (0, (1, 1))),
         ('densely dotted',        (0, (1, 1))),

         ('loosely dashed',        (0, (5, 10))),
         ('dashed',                (0, (5, 5))),
         ('densely dashed',        (0, (5, 1))),

         ('loosely dashdotted',    (0, (3, 10, 1, 10))),
         ('dashdotted',            (0, (3, 5, 1, 5))),
         ('densely dashdotted',    (0, (3, 1, 1, 1))),

         ('dashdotdotted',         (0, (3, 5, 1, 5, 1, 5))),
         ('loosely dashdotdotted', (0, (3, 10, 1, 10, 1, 10))),
         ('densely dashdotdotted', (0, (3, 1, 1, 1, 1, 1)))]

    return [style[1] for style in linestyle_tuple]
