# Show animated plots of solutions of advection equation

import matplotlib.pyplot as plt
from solver import solve_equation
from matplotlib import animation
from itertools import cycle


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

    time = t_values[0][i]
    text.set_text(f't = {time:.2f} s')

    for i_line, line in enumerate(lines):
        x = x_values[i_line]
        y = solution[i_line][i, :]
        line.set_data(x, y)

    artists = []
    artists += lines
    artists.append(text)

    return artists


def prepare_for_animation(methods, initial_conditions, t_end, ylim):
    """
    Makes a 2D that is used in animation.

    Parameters
    ----------

    methods : list of str
        Numerical methods to be used: ftcs, lax, upwind, lax-wendroff

    initial_conditions : str
        Type of initial conditions: square, sine

    t_end : float
        The largest time of the solution.

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
        result = solve_equation(x_start=0, x_end=1,
                                nx=100, t_start=0, t_end=t_end, method=method,
                                initial_conditions=initial_conditions)

        if result is None:
            return
        else:
            x, y, z, dx, dt, dt_dx = result
            x_values.append(x)
            y_values.append(y)
            z_values.append(z)

    fig = plt.figure()
    ax = plt.axes(xlim=(0, 1), ylim=ylim)

    title = (
        "Solution of advection equation\n"
        f"for dx={dx:.3f} m, dt={dt:.3f} s, "
        "$v \\Delta t / \\Delta x$"
        f"={dt_dx:.2f}"
    )

    plt.title(title)
    plt.xlabel("Position x [m]")
    plt.ylabel("Density $\\rho$ [$kg \\ m^{-3}$]")

    text = plt.text(
        0.05, 0.89,
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
        line, = ax.plot([], [], label=method.capitalize(),
                        linestyle=next(line_style_cycler))

        lines.append(line)

    plt.legend()

    return (fig, lines, text, x_values, y_values, z_values)


def compare_animated(methods, initial_conditions, t_end, ylim):
    """
    Show animated plots of solutions of advection equation.

    Parameters
    ----------

    methods : list of str
        Numerical methods to be used: ftcs, lax, upwind, lax-wendroff

    initial_conditions : str
        Type of initial conditions: square, sine

    t_end : float
        The largest time of the solution.

    ylim : tuple
        Minimum and maximum values of the y-axis.
    """

    fig, lines, text, x, y, z = \
        prepare_for_animation(methods=methods,
                              initial_conditions=initial_conditions,
                              t_end=t_end, ylim=ylim)

    timesteps = z[0].shape[0]

    animation.FuncAnimation(fig, animate,
                            frames=timesteps, interval=100, blit=True,
                            fargs=(lines, text, x, y, z))

    plt.show()


if __name__ == '__main__':
    # plot_animated(method='ftcs', initial_conditions='square',
    #               t_end=1, ylim=(-0.5, 1.5))

    # plot_animated(method='lax', initial_conditions='square',
    #               t_end=1, ylim=(-0.5, 1.5))

    # plot_animated(method='upwind', initial_conditions='square',
    #               t_end=1, ylim=(-0.5, 1.5))

    # plot_animated(method='lax-wendroff', initial_conditions='square',
    #               t_end=1, ylim=(-0.5, 1.5))

    compare_animated(methods=['exact', 'lax', 'upwind', 'lax-wendroff'],
                     initial_conditions='square',
                     t_end=1, ylim=(-0.5, 1.5))
