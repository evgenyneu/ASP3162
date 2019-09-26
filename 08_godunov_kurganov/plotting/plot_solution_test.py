from plot_solution import make_plots
import os
import shutil


def test_plot_solution():
    plot_dir = "test_plots"
    plot_file_name = "03_sine_c_0.5_time_1.0.pdf"
    plot_file_path = os.path.join(plot_dir, plot_file_name)

    if os.path.exists(plot_file_path):
        os.remove(plot_file_path)

    make_plots(plot_dir=plot_dir, show_plot=False)

    assert os.path.exists(plot_file_path)
    os.remove(plot_file_path)
    shutil.rmtree(plot_dir)
