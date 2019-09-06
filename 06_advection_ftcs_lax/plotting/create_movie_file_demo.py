import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.animation as animation

fig = plt.figure()
ax = plt.axes(xlim=(0, 2), ylim=(-2, 2))

line, = ax.plot([], [])


def init():
    line.set_data([], [])
    return line,


def animate(i):
    x = np.linspace(0, 2, 1000)
    y = np.sin(2 * np.pi * (x - 0.01 * i))
    y -= y % 0.3
    line.set_data(x, y)
    return line,

# anim = animation.FuncAnimation(fig, animate, init_func=init,
#                                frames=100, interval=20, blit=True)


Writer = animation.writers['ffmpeg']
writer = Writer(fps=15, metadata=dict(artist='Me'), bitrate=1800)

n = 100

with writer.saving(fig, 'myfile.mp4', dpi=100):
    for j in range(n):
        animate(j)
        writer.grab_frame()