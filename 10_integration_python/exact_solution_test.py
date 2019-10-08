import pytest
from pytest import approx
from exact_solution import exact


def test_exact_solution__single_values():
    assert exact(x=1.2, n=0) == approx(0.76, rel=1e-15)
    assert exact(x=1.2, n=1) == approx(0.7766992383060219, rel=1e-15)
    assert exact(x=1.2, n=5) == approx(0.8219949365267865, rel=1e-15)

    with pytest.raises(ValueError):
        exact(x=1.2, n=3)


def test_exact_solution__multiple_values_n_0():
    result = exact(x=[1.2, -0.1], n=0)

    assert result == approx([0.76, 0.998333333333333], rel=1e-15)


def test_exact_solution__multiple_values_n_1():
    result = exact(x=[1.2, -0.1], n=1)

    assert result == approx(
        [0.7766992383060219, 0.9983341664682815], rel=1e-15)


def test_exact_solution__multiple_values_n_1__include_zero():
    result = exact(x=[1.2, 0.0, -0.1], n=1)

    assert result == approx(
        [0.7766992383060219, 1, 0.9983341664682815], rel=1e-15)


def test_exact_solution__multiple_values_n_5():
    result = exact(x=[1.2, -0.1], n=5)

    assert result == approx(
        [0.8219949365267865, 0.9983374884595826], rel=1e-15)
