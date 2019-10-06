# Various shared functions used by plotting scripts
import os


def create_dir_for_path(path_to_file):
    """
    Make sure the directory specified in `path_to_file` exists

    Parameters
    ----------

    path_to_file : str
        A path to a file
    """

    dir = os.path.dirname(path_to_file)
    create_dir(dir)


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
