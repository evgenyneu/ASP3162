# Dealing with elements
import numpy as np

# IDs of the elements in the arrays
id_helium = 0
id_carbon = 1
id_magnesium = 2


def all_mole_fractions_to_mass_fractions(all_mole_fractions):
    """
    Convert the array
    [
        [mole fractions]
        [mole fractions]
        [mole fractions]
    ]

    to the array containing mole fractions

    Parameters
    ----------

    all_mole_fractions : numpy array

    Array of arrays containing mole fractions for the elements.


    Returns : numpy array
    -------

    Array of mass fractions for the elements.
    """

    all_mass_fractions = [
        mole_fractions_to_mass_fractions(mole_fractions)
        for mole_fractions in all_mole_fractions
    ]

    return np.array(all_mass_fractions)


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
