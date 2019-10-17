from make_plots import make_plots
import os
import shutil


def test_make_plots():
    plot_dir = "test_plots"
    plot_file_name = "02.1_c_to_mg.pdf"
    plot_file_path = os.path.join(plot_dir, plot_file_name)

    if os.path.exists(plot_file_path):
        os.remove(plot_file_path)

    make_plots(plot_dir=plot_dir, show=False)

    assert os.path.exists(plot_file_path)
    os.remove(plot_file_path)
    shutil.rmtree(plot_dir)
