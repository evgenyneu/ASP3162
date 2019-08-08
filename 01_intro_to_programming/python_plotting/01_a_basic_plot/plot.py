import numpy as np
import matplotlib.pyplot as plt

pi = np.pi  # get pi
x = np.linspace(0, 1, 100)  # set up 100 equally spaced points in 0 < x < 1
f = np.sin(2 * pi * x)
plt.plot(x, f, color='purple')
plt.title('f(x) = sin(2$\pi$x)')
plt.xlabel('x')
plt.ylabel('f(x)')

plt.savefig('fx.pdf')
plt.show()