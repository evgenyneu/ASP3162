from task_2 import taks_2
from task_3 import plot_mass_fractions
from task_4 import show_mass_fraction_with_adaptive_solver
from task_5 import show_mass_fraction_with_implicit_solver


def make_plots(plot_dir, show):
    """
    Make plots for all the tasks in the lab.

    Parameters
    ----------

    plot_dir : str
        Directory where the plot files will be saved

    show : bool
        If False the plots are not shown on screen but only saved
        to files (used in unit tests)
    """

    figsize = (8, 6)

    # taks_2(plot_dir=plot_dir, figsize=figsize, show=show)

    # plot_mass_fractions(plot_dir=plot_dir, figsize=figsize, show=show)

    # show_mass_fraction_with_adaptive_solver(plot_dir=plot_dir, figsize=figsize,
    #                                         show=show)

    show_mass_fraction_with_implicit_solver(plot_dir=plot_dir, figsize=figsize,
                                            show=show)


if __name__ == '__main__':
    make_plots(plot_dir="plots", show=True)
