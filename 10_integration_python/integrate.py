class Integrate(object):
    """
    Do all integration steps
    """

    def __init__(self, f, initial, final):
        """
        Parameters
        ----------

        f : function
            Calculates derivatives.

            Parameters of `f`
            --------------

            x : float
                A value of independent variable

            y_vector : list
                Contains a list of dependent variables

            Returns (`f` function)
            ---------

            numpy.ndarray

            List containing two elements, which are derivatives:
                1. dy/dx.
                2. dz/dx.

        initial : function
            Calculates initial conditions.

            Returns (`initial` function)
            --------------

            tuple (x, y)

                x : float
                    Independent variable

                y : list
                    Dependent variables

        final : function
            Checks if integration should be ended.

            Parameters of `final`
            ----------

            x : float
                Independent variable

            y : list
                Dependent variables

            Returns (`final` function)
            --------

            bool

            True if integration needs to be finished.
        """
        self.f = f
        self.initial = initial
        self.final = final

    def run(self):
        """
        Start the integration
        """

        x, y = self.initial()
        xi = []
        yi = []

        while not self.final(x, y):
            xi += [x]
            yi += [y]
            x, y = self.advance(x, y)

        return np.array(xi), np.array(yi)
