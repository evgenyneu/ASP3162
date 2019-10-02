"""
ASP 3162 - Workshop 09
A plot program for ASP 3162 WS data
"""

import numpy as np
import matplotlib.pyplot as plt


class Data(object):
    """
    Loads data from a single text file
    """

    def __init__(self, filename):
        """
        Create data object.

        Parameters
        -----------

        filename : str
            Name of the data file.
        """
        with open(filename, 'rt') as f:
            self.time = np.float(f.readline())
            self.data = np.loadtxt(f)


class DataSet(object):
    """
    Loads data from multiple text files.
    """

    def __init__(self, basename, format='{base:s}{seq:05d}.dat'):
        """
        Create DataSet object and load the data

        Parameters
        -----------

        basename : str
            Path to the data files and prefix of the data files.
            For example, data files are located in `mydata` directory,
            and the names of data files are like
                fluid_000001.dat
                fluid_000002.dat
                ...
                fluid_034233.dat
            then the basename will be `mydata/fluid_`.

        format : str
            The format used to construct the path to the data file.
        """

        self.load(basename, format)

    def load(self, basename, format):
        """
        Loads multiple data files.

        Parameters
        -----------

        basename : str
            Path to the data files and prefix of the data files.
            For example, data files are located in `mydata` directory,
            and the names of data files are like
                fluid_000001.dat
                fluid_000002.dat
                ...
                fluid_034233.dat
            then the basename will be `mydata/fluid_`.

        format : str
            The format used to construct the path to the data file.
        """

        n = 0
        data = []

        while True:
            n += 1
            # Constuct path to the data file
            filename = format.format(base=basename, seq=n)

            try:
                # Load data file
                data_object = Data(filename)
            except:
                break

            data += [data_object]

        # Store all data objects
        self.data = data
        self.n = n

    def time(self):
        """
        Returns : ndarray
        -----------------

        List of all time values
        """

        time = [record.time for record in self.data]
        return np.array(time)

    def x(self, index=0):
        """
        Parameters
        -----------

        index : int
            Index of the data file.

        Returns : ndarray
        -----------------

        List of all position values
        """

        return np.array(self.data[index].data[:, 0])

    def v(self, index=0):
        """
        Parameters
        -----------

        index : int
            Index of the data file.

        Returns : ndarray
        -----------------

        List of all velocity values values
        """

        return np.array(self.data[index].data[:, 1])

    def vset(self):
        """
        Returns : ndarray
        -----------------

        2D array containing all velocity values
        """

        v = [record.data[:, 1] for record in self.data]
        return np.array(v)

    def __len__(self):
        """
        Number of data files.
        """

        return self.n


class Plot2D(object):
    """
    Plotting the data.
    """

    def __init__(self, data):
        self.data = data

    @staticmethod
    def center(x):
        """
        I don't understand the purpose of this function.
        """

        y = np.ndarray(len(x) + 1)
        y[1:-1] = 0.5 * (x[1:] + x[:-1])
        y[-1] = 1.5*x[-1] - 0.5*x[-2]
        y[0] = 1.5*x[0] - 0.5*x[1]
        return y

    def plot(self, figsize, filename):
        """
        Create a 2D plot.

        Parameters
        -----------

        figsize : tuple (x, y)
            Size of the image.

        filename : str
            File name that will be used to save the plot.
        """

        # Create a plot and axes objects
        f = plt.figure(figsize=figsize)
        ax = f.add_subplot(1, 1, 1)

        # Get the time values
        time = self.data.time()

        # I don't understand why this is needed
        time = self.center(time)

        # Get the x values
        x = self.data.x()

        # I have no clue why we need this
        x = np.append(x, 2*x[-1:] - x[-2])

        # Get all the velocity values in a 2D array
        v = self.data.vset()

        # Create a heatmap plot of velocities
        c = ax.pcolormesh(time, x, v.transpose())

        # Add a color bar
        f.colorbar(c, label="Velocity")

        # Set axes limits
        ax.set_xlim(time.min(), time.max())
        ax.set_ylim(x.min(), x.max())

        # Set axes labels
        ax.set_xlabel('Time [s]')
        ax.set_ylabel('Position [m]')

        # Remove empty space
        f.tight_layout()

        # Save plot to a file
        f.savefig(filename)

        # Store the plot object
        self.f = f
        self.ax = ax
