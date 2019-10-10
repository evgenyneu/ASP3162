from surface import calculate_exact_values_at_surface, calculate_surface_values
from pytest import approx

def test_calculate_exact_values_at_surface():
    result = calculate_exact_values_at_surface(x_surface_estimate=3, n=1)
    # print(result)
    # assert 2 == 3


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
