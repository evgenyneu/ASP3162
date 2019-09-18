# Create movies of solutions of advection equation

import matplotlib.animation as animation
from compare_animated import animate, prepare_for_animation
import matplotlib
import os
from plot_utils import create_dir
matplotlib.use("Agg")


def create_movie(methods, initial_conditions, courant_factor,
                 movie_dir, filename, t_end, nx, fps, ylim):
    """
    Create a movie of solution of advection equation

    Parameters
    ----------

    methods : list of str
        Numerical methods to be used: ftcs, lax, upwind, lax-wendroff

    initial_conditions : str
        Type of initial conditions: square, sine

    courant_factor : float
        Parameter used in the numerical methods

    movie_dir : str
        Directory where the movie file is saved

    filename : str
        Movie file name

    t_end : float
        The largest time of the solution.

    nx : int

        Number of x points.

    fps : int
        Frames per second for the movie

    ylim : tuple
        Minimum and maximum values of the y-axis.
    """
    print("...")

    Writer = animation.writers['ffmpeg']
    writer = Writer(fps=fps,
                    metadata=dict(artist='Evgenii Neumerzhitckii'),
                    bitrate=1800)

    fig, lines, text, x, y, z = \
        prepare_for_animation(methods=methods,
                              initial_conditions=initial_conditions,
                              t_end=t_end, nx=nx, ylim=ylim,
                              courant_factor=courant_factor)

    timesteps = z[0].shape[0]

    create_dir(movie_dir)
    path_to_file = os.path.join(movie_dir, filename)

    with writer.saving(fig, path_to_file, dpi=300):
        for i in range(timesteps):
            animate(i=i, lines=lines, text=text, x_values=x,
                    t_values=y, solution=z)

            writer.grab_frame()


def make_movies():
    """
    Create movies of solutions of advection equation
    """

    movies_dir = "movies"
    print(
            (f"Creating movies in '{movies_dir}'' directory.\n"
             "This will take a couple of minutes.")
         )

    methods = ['Exact', 'Lax-Wendroff', 'Lax', 'Upwind']

    t_end = 2
    fps = 10

    create_movie(methods=methods,
                 initial_conditions='sine',
                 courant_factor=0.5,
                 movie_dir=movies_dir, filename='01_sine_c_0.5.mp4',
                 t_end=t_end, nx=100, ylim=(-1.5, 1.5), fps=fps)

    create_movie(methods=methods,
                 initial_conditions='square',
                 courant_factor=0.5,
                 movie_dir=movies_dir, filename='02_square_c_0.5.mp4',
                 t_end=t_end, nx=100, ylim=(-0.5, 1.5), fps=fps)

    create_movie(methods=methods,
                 initial_conditions='sine',
                 courant_factor=1,
                 movie_dir=movies_dir, filename='03_sine_c_1.mp4',
                 t_end=t_end, nx=200, ylim=(-1.5, 1.5), fps=fps)

    create_movie(methods=methods,
                 initial_conditions='square',
                 courant_factor=1,
                 movie_dir=movies_dir, filename='04_square_c_1.mp4',
                 t_end=t_end, nx=200, ylim=(-0.5, 1.5), fps=fps)


if __name__ == '__main__':
    make_movies()
