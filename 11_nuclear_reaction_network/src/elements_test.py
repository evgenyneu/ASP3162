import numpy as np
from pytest import approx

from elements import mole_fractions_to_mass_fractions, \
                     all_mole_fractions_to_mass_fractions

from elements import id_helium, id_carbon, id_magnesium


def test_all_mole_fractions_to_mass_fractions():
    fractions = np.array([
        [0.08, 0.02, 0.0012],
        [0.02, 0.012, 0.0032]
    ])

    result = all_mole_fractions_to_mass_fractions(fractions)

    assert len(result) == 2
    assert result[0, :].tolist() == approx([0.32, 0.24, 0.0288], rel=1e-10)
    assert result[1, :].tolist() == approx([0.08, 0.144, 0.0768], rel=1e-10)


def test_mole_fractions_to_mass_fractions():
    result = mole_fractions_to_mass_fractions([0.08, 0.02, 0.0012])

    assert len(result) == 3
    assert result[id_helium] == 0.32
    assert result[id_carbon] == 0.24
    assert result[id_magnesium] == 0.0288
