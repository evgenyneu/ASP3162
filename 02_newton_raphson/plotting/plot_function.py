# Ploting f(x) = cos(x) - x
import numpy as np
import matplotlib.pyplot as plt

x_values = np.arange(-10, 10.0, 0.1)
y_values = np.cos(x_values) - x_values
plt.plot(x_values, y_values, color='red')
plt.title('Function $f(x) = \cos(x) - x = 0$')
plt.xlabel('x')
plt.ylabel('y')
plt.grid()
plt.tight_layout()
plt.savefig(f"cos_x_minus_x.pdf")
plt.show()