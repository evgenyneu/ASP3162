import pytest
from pytest import approx
from exact_solution import exact


def test_exact_solution__single_values():
    assert exact(x=1.2, n=0) == approx(0.76, rel=1e-15)
    assert exact(x=1.2, n=1) == approx(0.7766992383060219, rel=1e-15)
    assert exact(x=1.2, n=5) == approx(0.8219949365267865, rel=1e-15)

    with pytest.raises(ValueError):
        exact(x=1.2, n=3)
