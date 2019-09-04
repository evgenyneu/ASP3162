# Various shared functions used by plotting scripts
import os


def create_dir(dir):
    """
    Creates a directory if it does not exist.

    Parameters
    ----------
    dir : str
        Directory path, can be nested directories.

    """

    if not os.path.exists(dir):
        os.makedirs(dir)