# Dealing with mole fractions

# IDs of the elements in the arrays used for integration
id_helium = 0
id_carbon = 1
id_magnesium = 2

def mole_fractions_to_mass_fractions(mole_fractions):
    """
    Convert the mole fractions to mass fractions

    Parameters
    ----------

    mole_fractions : array

    Contains mole fractions for He, C and Mg
    """

    return [
        mole_fractions[id_helium] * 4,
        mole_fractions[id_carbon] * 12,
        mole_fractions[id_magnesium] * 24
    ]
