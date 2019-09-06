import matplotlib.pyplot as plt
from solver import solve_equation
from matplotlib import animation


def animate(i, line, text, x_values, t_values, solution):
    x = x_values
    y = solution[i, :]
    time = t_values[i]
    text.set_text(f't = {time:.2f} s')
    line.set_data(x, y)
    return line, text


def prepare_for_animation(method, t_end):
    """
    Makes a 2D plot of the velocity at different time values
    and saves it to a file.

    Parameters
    ----------

    plot_dir : str
        Directory where the plot file is saved

    plot_file_name : str
        Plot file name

    nx : int
        The number of x points in the grid

    nt : int
        The number of t points in the grid

    method : str
        Numerical method to be used: ftcs, lax

    plot_timesteps : int
        number of timesteps to plot
    """

    result = solve_equation(x_start=0, x_end=1,
                            nx=101, t_start=0, t_end=t_end, method=method)

    if result is None:
        return
    else:
        x, y, z, dx, dt, dt_dx = result

    fig = plt.figure()
    ax = plt.axes(xlim=(0, 1), ylim=(-0.1, 1.1))

    title = (
        "Solution of advection equation "
        f"made with {method} method\n"
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
        transform=ax.transAxes)

    plt.tight_layout()

    line, = ax.plot([], [])

    return (fig, line, text, x, y, z)


def plot_animated(method):
    fig, line, text, x, y, z = prepare_for_animation(method, t_end=5)
    timesteps = z.shape[0]

    animation.FuncAnimation(fig, animate,
                            frames=timesteps, interval=20, blit=True,
                            fargs=(line, text, x, y, z))

    plt.show()


if __name__ == '__main__':
    plot_animated(method='lax')
