# Various shared functions used by plotting scripts
import os


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
