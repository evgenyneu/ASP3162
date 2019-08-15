# Finds solution of x''(t) + x(t) = 0, x(0)=1, x'(0)=0 equation
import subprocess


def find_solution(t_end, delta_t, print_last):
    """
    Runs Fortran program that returns solution of

        x''(t) + x(t) = 0, x(0)=1, x'(0)=0.

    Parameters
    ----------
    t_end : float
        The end interval for t.

    delta_t : float
        The timestep.

    print_last : bool
        If true, returns only the solution for the final value of t.

    Returns
    -------
        str
            the solution in CSV format, or None if error occured.
    """

    print_last_text = ""

    if (print_last):
        print_last_text = "--print_last"

    parameters = [
        f'../build/main --delta_t={delta_t} --t_end={t_end} {print_last_text}'
    ]

    child = subprocess.Popen(parameters,
                             stdout=subprocess.PIPE,
                             stderr=subprocess.STDOUT,
                             shell=True)

    message = child.communicate()[0].decode('utf-8')
    rc = child.returncode
    success = rc == 0

    if not success:
        print(message)
        return None

    return message