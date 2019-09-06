# A Fortran program for finding roots of advection equation

This this a Fortran program that finds roots of equation

```
v_t + v v_x = 0
```

with initial condition

```
v(x, 0) = cos x
```

and boundary conditions

```
v(−pi/2, t) = v(pi/2, t) = 0
```

using numerical approximation.


## Compile

```
make
```

Gfortran compiler is required to build the program (tested with GCC 6.3.0 and 7.4.0). Alternatively, one can uncomment `FC=ifort` and `FFLAGS` in the Makefile and compile using ifort.



## Run

Running the program:

```
./build/main data.bin
```

The program will print the solution into the binary file `data.bin`.

### The binary file format


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
    solution: a 2D array containing solution. These are velocity values
    for x and t coordinates.

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



## Run with settings

One can also customize program settings, for example:

```
./build/main data.bin --x_start=-1.5 --x_end=1.5 --nx=200
```

Run the program with `--help` flag to see the description of parameters:

```
./build/main --help

This program solves equation

  v_t + v v_x = 0

with initial condition
  v(x,0) = cos x

and boundary conditions
  v(−pi/2, t) = v(pi/2, t) = 0


Usage:

 ./build/main OUTPUT [--method=lax] [--x_start=-1.5] [--x_end=1.5]
    [--nx=100] [--t_start=0] [--t_end=1.4] [--nt=8]

    OUTPUT : path to the output data file

    --method=NAME : numerical method to use
                  (ftcs, lax). 
                  Default: lax.

    --x_start=NUMBER : the smallest x value,
                  Default: -pi/2.

    --x_end=NUMBER : the largest x value,
                  Default: pi/2.

    --nx=NUMBER : number of x points in the grid,
                  Default: 100.

    --t_start=NUMBER : the smallest t value,
                  Default: 0.

    --t_end=NUMBER : the largest t value,
                  Default: 1.4.

    --nt=NUMBER : number of t points in the grid,
                  Default: 8.

    --help  : show this message.
```

## Run unit tests

First make the test executable:

```
make test
```

Next, run the tests:

```
./build/test
```

You will see the following output, if tests are successful:

```
./build/test
 · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · 
Tests finished successfully
```


## Plotting

To make plots, first cd into plotting directory:

```
cd plotting
```

The plotting codes require the Fortran executable to be present.


### Plot solutions

```
python plot_solution.py
```