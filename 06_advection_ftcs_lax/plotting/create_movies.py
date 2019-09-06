# Create movies of solutions of advection equation

import matplotlib.animation as animation
from plot_animated import animate, prepare_for_animation
import matplotlib
import os
from plot_utils import create_dir
matplotlib.use("Agg")


def create_movie(method, movie_dir, filename, t_end, fps, ylim):
    """
    Create a movie of solution of advection equation

    Parameters
    ----------

    method : str
        Numerical method used : lax, ftcs

    movie_dir : str
        Directory where the movie file is saved

    filename : str
        Movie file name

    t_end : float
        The largest time of the solution.

    fps : int
        Frames per second for the movie

    ylim : tuple
        Minimum and maximum values of the y-axis.
    """

    Writer = animation.writers['ffmpeg']
    writer = Writer(fps=fps,
                    metadata=dict(artist='Evgenii Neumerzhitckii'),
                    bitrate=1800)

    fig, line, text, x, y, z = \
        prepare_for_animation(method=method, t_end=t_end, ylim=ylim)

    timesteps = z.shape[0]

    create_dir(movie_dir)
    path_to_file = os.path.join(movie_dir, filename)

    with writer.saving(fig, path_to_file, dpi=300):
        for i in range(timesteps):
            animate(i=i, line=line, text=text, x_values=x,
                    t_values=y, solution=z)

            writer.grab_frame()


def make_movies():
    """
    Create movies of solutions of advection equation
    """

    create_movie(method='lax', movie_dir='movies', filename='lax.mp4',
                 t_end=2, ylim=(-2, 2), fps=10)

    create_movie(method='ftcs', movie_dir='movies', filename='ftcs.mp4',
                 t_end=1, ylim=(-2, 2), fps=10)


if __name__ == '__main__':
    make_movies()
