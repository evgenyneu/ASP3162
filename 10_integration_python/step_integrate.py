from integrate import Integrate


class StepIntegrate(Integrate):
    """
    Helper class to set step size.
    """

    def __init__(self, *args, h=0.001, **kwargs):
        """
        Parameters
        ----------

        h : float
            Contains the step size for the independent variable.
        """

        super().__init__(*args, **kwargs)
        self.h = h
