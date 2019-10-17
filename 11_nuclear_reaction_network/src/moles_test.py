from moles import mole_fractions_to_mass_fractions
from moles import id_helium, id_carbon, id_magnesium


def test_mole_fractions_to_mass_fractions():
    result = mole_fractions_to_mass_fractions([0.08, 0.02, 0.0012])

    assert len(result) == 3
    assert result[id_helium] == 0.32
    assert result[id_carbon] == 0.24
    assert result[id_magnesium] == 0.0288
