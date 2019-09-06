import matplotlib.animation as animation
from plot_animated import animate, prepare_for_animation
import matplotlib
matplotlib.use("Agg")


def create_movie(method, duration, fps):
    Writer = animation.writers['ffmpeg']
    writer = Writer(fps=fps, metadata=dict(artist='Me'), bitrate=1800)

    fig, line, text, x, y, z = \
        prepare_for_animation(method='lax', t_end=duration)

    timesteps = z.shape[0]

    with writer.saving(fig, 'myfile.mp4', dpi=300):
        for i in range(timesteps):
            animate(i=i, line=line, text=text, x_values=x,
                    t_values=y, solution=z)

            writer.grab_frame()


if __name__ == '__main__':
    create_movie(method='lax', duration=2, fps=60)
