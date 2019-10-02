"""
ASP 3162 - Workshop 09
A plot program for ASP 3162 WS data
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl


class Data(object):
    def __init__(self, filename):
        with open(filename, ’rt’) as f:
            self.time = np.float(f.readline())
            self.data = np.loadtxt(f)
