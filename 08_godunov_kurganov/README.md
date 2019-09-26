# A Fortran program for solving Burgers' equation

This is a Fortran program that solves Burgers' equation

```
v_t + v v_x = 0
```

numerically using Godunov’s and Kurganov-Tadmor's methods.


## YouTube movies of solutions

  * Sine: https://youtu.be/bDNXNGpYj0c

  * Square: https://youtu.be/IfFQsQHDGUc


## Compile

```
make
```

Gfortran compiler is required to build the program (tested with GCC 6.3.0 and 7.4.0). Alternatively, one can uncomment `FC=ifort` and `FFLAGS` in the Makefile and compile using ifort.


## Make plots


The plotting codes runs the Fortran executable. Run `make` before executing Python code.


### Plot solutions

Create plots in `plots` directory.

```
make
python plotting/plot_solution.py
```


### Show animated plots

```
python plotting/compare_animated.py
```


### Create movies

Create mp4 movies for the solutions in the `movies` directory:

```
python plotting/create_movies.py
```


## Run unit tests

### Fortran unit tests

```
make test
./build/test
```

You will see the following output, if tests are successful:

```
./build/test
 · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
Tests finished successfully
```


### Python unit tests

Run unit tests for plotting code:

```
make
pytest
```

Note: Requires *pytest* Python package.


## Run

Running the program:

```
./build/main data.bin
```

The program will print the solution into the binary file `data.bin`. See the description of the format below.



## Run with settings

To specify program settings, run:

```
./build/main data.bin --method=upwind --initial_conditions=sine --courant_factor=0.5
```

Run the program with `--help` flag to see the description of all settings:

```
./build/main --help

This program solves Burgers' equation

  u_t + u u_x = 0


Usage:

 ./build/main OUTPUT [--method=kurganov] [--initial_conditions=square]
       [--x_start=0] [--x_end=1] [--nx=100] [--t_start=0]
       [--t_end=1] [--courant_factor=0.5]

    OUTPUT : path to the output data file

    --method=NAME : numerical method to use
                  (godunov, kurganov).
                  Default: godunov.

    --initial_conditions=NAME : initial conditions (square, sine).
                  Default: square.

    --x_start=NUMBER : the smallest x value,
                  Default: 0.

    --x_end=NUMBER : the largest x value,
                  Default: 1.

    --nx=NUMBER : number of x points in the grid,
                  Default: 100.

    --t_start=NUMBER : the smallest t value,
                  Default: 0.

    --t_end=NUMBER : the largest t value,
                  Default: 1.

    --courant_factor=NUMBER : parameter equal to v*dt/dx,
                  Default: 0.5.

    --help  : show this message.

```


## Binary file format

Here is how data is stored in the binary file:

```
[x]
[
    nx: number of x values
    Size: 4 bytes
    Type: signed int
]
[x]

[x]
[
    nt: number of t values
    Size: 4 bytes
    Type: Signed int
]
[x]

[x]
[
    x_values: array of x values
    Size: nx * 8 bytes
    Type: Array of double floats. Length nx.
]
[x]

[x]
[
    t_values: array of t values
    Size: nt * 8 bytes
    Type: Array of double floats. Length: tx.
]
[x]

[x]
[
    solution: a 2D array containing solution.

    Size: nx * nt * 8 bytes
    Type: 2D array of double floats. Length: nx * nt.
]
[x]
```


#### Notes

* Here [x] means 4-byte separator. This is added by Fortran's `write`
function. This separator is written before and after a data block,
and its value is the length in bytes of this block.

* `solution` is a 2D array saved as a sequence of double precision
float numbers in the column-major order. For example, for nx=3, nt=2,
the data will be saved as:

```
    [1, 1] [2, 1] [3, 1] [1, 2] [2, 2] [3, 2],
```

where first index is x and second index is t.



## The unlicense

This work is in [public domain](LICENSE).
