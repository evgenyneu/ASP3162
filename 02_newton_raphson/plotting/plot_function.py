# Ploting f(x) = cos(x) - x
import numpy as np
import matplotlib.pyplot as plt
import os

plots_dir = "plots"

if not os.path.exists(plots_dir):
    os.makedirs(plots_dir)

x_values = np.arange(-10, 10.0, 0.1)
y_values = np.cos(x_values) - x_values
plt.plot(x_values, y_values, color='red')
plt.title('Function $f(x) = \cos(x) - x$')
plt.xlabel('x')
plt.ylabel('y')
plt.grid()
plt.tight_layout()
plotfile = os.path.join(plots_dir, "cos_x_minus_x.pdf")
plt.savefig(plotfile)
plt.show()