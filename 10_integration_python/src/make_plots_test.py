from make_plots import make_plots
import os
import shutil


def test_plot_solution():
    plot_dir = "test_plots"
    plot_file_name = "01_lane_emden.pdf"
    plot_file_path = os.path.join(plot_dir, plot_file_name)

    if os.path.exists(plot_file_path):
        os.remove(plot_file_path)

    make_plots(plot_dir=plot_dir, show=False)

    assert os.path.exists(plot_file_path)
    os.remove(plot_file_path)
    shutil.rmtree(plot_dir)
