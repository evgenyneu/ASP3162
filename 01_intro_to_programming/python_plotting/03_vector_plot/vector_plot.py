import matplotlib.pyplot as plt
import numpy as np

y, x = np.ogrid[0:1:21j, 0:1:21j]
pi = np.pi
A = 1.0
vx = -A * (np.cos(2 * pi * x) * np.sin(2 * pi * y))
vy = A * (np.sin(2 * pi * x) * np.cos(2 * pi * y))

plt.quiver(x, y, vx, vy, color="b", label="velocity")

# uncomment the following lines to plot streamlines instead
speed = np.sqrt(vx**2 + vy**2)
linewidth = 3 * speed / speed.max()
plt.streamplot(x, y, vx, vy, color="r", linewidth=linewidth)

plt.title("A vector plot")
plt.xlabel("$x$-direction")
plt.ylabel("$y$-direction")
plt.legend()
plt.show()
plt.savefig("myplot.pdf")