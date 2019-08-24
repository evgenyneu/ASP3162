# Plotting solution of the heat equation
import matplotlib.pyplot as plt
import os
from plot_utils import create_dir
from solve_pde import solve_pde
from mpl_toolkits.mplot3d import Axes3D


def make_plot(data, title, plot_dir, plot_file_name):
    x_values = data["x_values"]
    t_values = data["t_values"]
    temperatures = data["temperatures"]

    fig = plt.figure()
    ax = fig.gca(projection='3d')
    ax.plot_surface(x_values, t_values, temperatures, cmap=plt.cm.jet)
    ax.set_xlabel("Length x [m]")
    ax.set_ylabel("Time t [s]")
    ax.set_zlabel("Temperature T [K]")
    ax.set_title(title)
    ax.view_init(30, 45)
    plt.tight_layout()
    pdf_file = os.path.join(plot_dir, plot_file_name)
    # pdf_file = pdf_file.replace(".", "_")
    # pdf_file = f"{pdf_file}.pdf"
    plt.savefig(pdf_file)
    plt.show()


def plot_solution(plot_dir, nx, alpha, k, nt):
    create_dir(plot_dir)

    result = solve_pde(nx=nx, nt=nt, alpha=alpha, k=k)

    if result is None:
        return

    dx = 1. / (nx - 1)
    dt = alpha * dx**2 / k

    data = result["data"]

    title = f"Solution of heat equation\ndx={dx:.2e} m, dt={dt:.2e} s, $\\alpha$={alpha:.2e}"
    plot_file_name = f"nx_{nx}_alpha_{alpha:.2f}_solution.pdf"
    make_plot(data=data, title=title, plot_dir=plot_dir, plot_file_name=plot_file_name)

    # Plot errors
    # -------------

    data = result["errors"]
    title = f"Errors of the solution to the heat equation\ndx={dx:.2e} m, dt={dt:.2e} s, $\\alpha$={alpha:.2e}"
    plot_file_name = f"nx_{nx}_alpha_{alpha:.2f}_errors.pdf"
    make_plot(data=data, title=title, plot_dir=plot_dir, plot_file_name=plot_file_name)


if __name__ == '__main__':
    plot_solution(plot_dir="plots", nx=5, alpha=0.1, k=2.28e-5, nt=35)
    plot_solution(plot_dir="plots", nx=21, alpha=0.25, k=2.28e-5, nt=300)
    plot_solution(plot_dir="plots", nx=31, alpha=0.5625, k=2.28e-5, nt=180)
