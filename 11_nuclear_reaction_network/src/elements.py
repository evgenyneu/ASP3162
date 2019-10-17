# Dealing with elements

# IDs of the elements in the arrays
id_helium = 0
id_carbon = 1
id_magnesium = 2


def mole_fractions_to_mass_fractions(mole_fractions):
    """
    Convert the mole fractions to mass fractions.

    Parameters
    ----------

    mole_fractions : list of float

    Mole fractions for the elements.


    Returns : list of float
    -------

    Array of mass fractions for the elements.
    """

    return [
        mole_fractions[id_helium] * 4,
        mole_fractions[id_carbon] * 12,
        mole_fractions[id_magnesium] * 24
    ]
