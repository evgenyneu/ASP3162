import os
import shutil
from pytest import approx
import pandas as pd

from surface import calculate_exact_values_at_surface, \
                    calculate_surface_values, save_surface_values_to_csv, \
                    surface_values_single_method

from integrate import improved_euler_integrator


def test_save_surface_values_to_csv():

    filename = "surface_test.csv"

    data_dir = "data_test"
    filename = "surface_test.csv"
    data_file_path = os.path.join(data_dir, filename)

    if os.path.exists(data_file_path):
        os.remove(data_file_path)

    df = calculate_surface_values(n=1)

    save_surface_values_to_csv(df=df, data_dir=data_dir,
                               filename=filename)

    # Verify CSV
    # -----------

    df = pd.read_csv(data_file_path)

    values = df.loc[
        (df['Step size'] == 0.1) & (df['Method'] == 'Improved Euler')]

    assert values['Radius, xi'].iloc[0] == approx(3.1, rel=1e-15)

    assert values['Density derivative, d(theta)/d(xi)'].iloc[0] == \
        approx(-0.3259175013015985, rel=1e-15)

    assert os.path.exists(data_file_path)
    os.remove(data_file_path)
    shutil.rmtree(data_dir)


def test_calculate_exact_values_at_surface():
    result = calculate_exact_values_at_surface(x_surface_estimate=3.1, n=1)

    assert result["method"] == "Exact"
    assert result["x_surface"] == approx(3.14159267959268, rel=1e-15)

    assert result["density_derivative_surface"] == \
        approx(-0.3183098809145041, rel=1e-15)


def test_surface_values_single_method():
    result = surface_values_single_method(
        integrator=improved_euler_integrator, h=0.01, n=1)

    assert result["x_surface"] == approx(3.139999999999977, rel=1e-15)

    assert result["density_derivative_surface"] == \
        approx(-0.31862568823046306, rel=1e-15)


def test_calculate_surface_values():
    df = calculate_surface_values(n=1)

    assert df.shape == (12, 4)

    # Euler, h=0.1
    # ----------

    values = df.loc[(df['h'] == 0.1) & (df['method'] == 'Euler')]
    assert values['x_surface'].iloc[0] == approx(3.1, rel=1e-15)

    assert values['density_derivative_surface'].iloc[0] == \
        approx(-0.3388322661149234, rel=1e-15)

    # Improved Euler, h=0.1
    # ----------

    values = df.loc[(df['h'] == 0.1) & (df['method'] == 'Improved Euler')]
    assert values['x_surface'].iloc[0] == approx(3.1, rel=1e-15)

    assert values['density_derivative_surface'].iloc[0] == \
        approx(-0.3259175013015985, rel=1e-15)

    # Runge-Kutta, h=0.1
    # ----------

    values = df.loc[(df['h'] == 0.1) & (df['method'] == 'Runge-Kutta')]
    assert values['x_surface'].iloc[0] == approx(3.1, rel=1e-15)

    assert values['density_derivative_surface'].iloc[0] == \
        approx(-0.32662045260405514, rel=1e-15)

    # Exact, h=0.1
    # ----------

    values = df.loc[(df['h'] == 0.1) & (df['method'] == 'Exact')]

    assert values['x_surface'].iloc[0] == \
        approx(3.1415926795926814, rel=1e-15)

    assert values['density_derivative_surface'].iloc[0] == \
        approx(-0.31830988091450385, rel=1e-15)

    # Euler, h=0.01
    # ----------

    values = df.loc[(df['h'] == 0.01) & (df['method'] == 'Euler')]

    assert values['x_surface'].iloc[0] == \
        approx(3.1299999999999772, rel=1e-15)

    assert values['density_derivative_surface'].iloc[0] == \
        approx(-0.3217329656403775, rel=1e-15)

    # Improved Euler, h=0.01
    # ----------

    values = df.loc[(df['h'] == 0.01) & (df['method'] == 'Improved Euler')]

    assert values['x_surface'].iloc[0] == \
        approx(3.139999999999977, rel=1e-15)

    assert values['density_derivative_surface'].iloc[0] == \
        approx(-0.31862568823046306, rel=1e-15)

    # Runge-Kutta, h=0.01
    # ----------

    values = df.loc[(df['h'] == 0.01) & (df['method'] == 'Runge-Kutta')]

    assert values['x_surface'].iloc[0] == \
        approx(3.139999999999977, rel=1e-15)

    assert values['density_derivative_surface'].iloc[0] == \
        approx(-0.31863244893617887, rel=1e-15)

    # Exact, h=0.01
    # ----------

    values = df.loc[(df['h'] == 0.01) & (df['method'] == 'Exact')]

    assert values['x_surface'].iloc[0] == \
        approx(3.1415926723926493, rel=1e-15)

    assert values['density_derivative_surface'].iloc[0] == \
        approx(-0.31830988237353536, rel=1e-15)

    # Euler, h=0.001
    # ----------

    values = df.loc[(df['h'] == 0.001) & (df['method'] == 'Euler')]

    assert values['x_surface'].iloc[0] == \
        approx(3.140999999999765, rel=1e-15)

    assert values['density_derivative_surface'].iloc[0] == \
        approx(-0.318535712203409, rel=1e-15)

    # Improved Euler, h=0.001
    # ----------

    values = df.loc[(df['h'] == 0.001) & (df['method'] == 'Improved Euler')]

    assert values['x_surface'].iloc[0] == \
        approx(3.140999999999765, rel=1e-15)

    assert values['density_derivative_surface'].iloc[0] == \
        approx(-0.3184298939191397, rel=1e-15)

    # Runge-Kutta, h=0.001
    # ----------

    values = df.loc[(df['h'] == 0.001) & (df['method'] == 'Runge-Kutta')]

    assert values['x_surface'].iloc[0] == \
        approx(3.140999999999765, rel=1e-15)

    assert values['density_derivative_surface'].iloc[0] == \
        approx(-0.3184299609685312, rel=1e-15)

    # Exact, h=0.001
    # ----------

    values = df.loc[(df['h'] == 0.001) & (df['method'] == 'Exact')]

    assert values['x_surface'].iloc[0] == \
        approx(3.1415927072924723, rel=1e-15)

    assert values['density_derivative_surface'].iloc[0] == \
        approx(-0.31830987530135246, rel=1e-15)
