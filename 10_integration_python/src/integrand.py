class Integrand(object):
    def integrate(self, method, **kwargs):
        """
        Evaluate the integral and return x coordinate and values.
        """

        integrator = method(self, self.initial, self.final, **kwargs)
        return integrator.run()

    def __call__(self, x, y):
        """Return vector of derivatives for given x and y"""

        raise NotImplementedError()

    def initial(self):
        """Return initial conditions for x and y"""

        raise NotImplementedError()

    def final(self, x, y):
        """Return True if reached final point, False otherwise"""

        raise NotImplementedError()
