# Show animated plots of solutions of advection equation

import matplotlib.pyplot as plt
from solver import solve_equation
from matplotlib import animation
from itertools import cycle
from plot_solution import find_nearest_index


def animate(i, lines, text, x_values, t_values, solution):
    """
    Updates the curve and text on the plot. Called during animation.

    Parameters
    ----------

    i : int
        Index of the frame to draw: 0, 1, ...

    line : Line2D,
        Plot curve that will be updated during the animation

    text : matplotlib.text.Text
        A plot text that will be updated during animation

    x_values : np.array of float
        x values

    t_values : np.array of float
        t values

    solution : np.array of float
        2D array containing solution (first index is time, secon is space)

    Returns
    ---------

    Tuple (line, text)

    line : Line2D,
           Updated plot curve

    text : matplotlib.text.Text
           Updated plot text
    """

    time = t_values[0][i]  # Get time form the first method
    text.set_text(f't = {time:.2f} s')

    for i_line, line in enumerate(lines):
        x = x_values[i_line]

        if i_line == 0:
            # Use i as time index for the first method
            time_index = i
        else:
            # If it's not the first method, find the time index
            # corresponding to `time` value
            time_index = find_nearest_index(t_values[i_line], time)

        y = solution[i_line][time_index, :, 0]
        line.set_data(x, y)

    artists = []
    artists += lines
    artists.append(text)

    return artists


def prepare_for_animation(methods, initial_conditions, t_end, nx, ylim,
                          courant_factor):
    """
    Makes a 2D that is used in animation.

    Parameters
    ----------

    methods : list of str
        Numerical methods to be used.

    initial_conditions : str
        Type of initial conditions: square, sine

    t_end : float
        The largest time of the solution.

    nx : integer

        Number of x points.

    ylim : tuple
        Minimum and maximum values of the y-axis.

    Returns
    ---------

    Tuple (fig, line, text, x, y, z)

    fig : Matplotlib figure

    line : Line2D,
           Plot curve that will be updated during the animation

    text : matplotlib.text.Text
           A plot text that will be updated during animation

    x : np.array of float
        x values

    y : np.array of float
        t values

    z : np.array of float
        2D array containing solution (first index is time, secon is space)
    """

    x_values = []
    y_values = []
    z_values = []

    for method in methods:
        this_courant = courant_factor
        this_nx = nx

        if method.lower() == "exact" and courant_factor != 1:
            # Increase x resolution for square exact method
            # to make animation smoother
            this_nx *= 100
            this_courant *= 100

        result = solve_equation(x_start=0, x_end=1,
                                nx=this_nx, t_start=0, t_end=t_end,
                                method=method.lower(),
                                initial_conditions=initial_conditions,
                                courant_factor=this_courant)

        if result is None:
            return
        else:
            x, y, z, dx = result
            x_values.append(x)
            y_values.append(y)
            z_values.append(z)

    fig = plt.figure(figsize=(8, 6))
    ax = plt.axes(xlim=(0, 1), ylim=ylim)

    title = (
        "Solutions of Burgers' equation "
        r"for $\Delta x$"
        f"={dx:.3f} m"
    )

    plt.title(title)
    plt.xlabel("Position x [m]")
    plt.ylabel("Speed u [m/s]")

    text = plt.text(
        0.05, 0.92,
        f'',
        horizontalalignment='left',
        verticalalignment='center',
        transform=ax.transAxes,
        bbox=dict(facecolor='white', alpha=0.8, edgecolor='0.7'))

    plt.tight_layout()

    lines = []
    line_styles = ["-", "--", "-.", ":"]
    line_style_cycler = cycle(line_styles)

    for method in methods:
        line, = ax.plot([], [], label=method,
                        linestyle=next(line_style_cycler))

        lines.append(line)

    plt.legend(loc='upper right')

    return (fig, lines, text, x_values, y_values, z_values)


def compare_animated(methods, initial_conditions, t_end, ylim,
                     nx, courant_factor):
    """
    Show animated plots of solutions of advection equation.

    Parameters
    ----------

    methods : list of str
        Numerical methods to be used.

    initial_conditions : str
        Type of initial conditions: square, sine

    t_end : float
        The largest time of the solution.

    ylim : tuple
        Minimum and maximum values of the y-axis.

    nx : int
        Number of x points.

    courant_factor : float
        Parameter used in the numerical methods
    """

    fig, lines, text, x, y, z = \
        prepare_for_animation(methods=methods,
                              initial_conditions=initial_conditions,
                              t_end=t_end, nx=nx, ylim=ylim,
                              courant_factor=courant_factor)

    timesteps = len(y[0])  # Get number of time steps from the first method

    animation.FuncAnimation(fig, animate,
                            frames=timesteps, interval=100, blit=True,
                            fargs=(lines, text, x, y, z))

    plt.show()


def show_plots():
    """
    Show animated plots.
    """

    methods = ['Godunov', 'Kurganov']
    t_end = 2

    compare_animated(methods=methods,
                     initial_conditions='sine',
                     courant_factor=0.5,
                     t_end=t_end, nx=100, ylim=(-1.5, 1.5))


    compare_animated(methods=methods,
                     initial_conditions='square',
                     courant_factor=0.5,
                     t_end=t_end, nx=100, ylim=(-0.5, 1.5))


if __name__ == '__main__':
    show_plots()
