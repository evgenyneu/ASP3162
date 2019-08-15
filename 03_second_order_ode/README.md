# A Fortran program for solving a 2nd order linear ODE

This this a Fortran program that solves the equation

```
x''(t) + x(t) = 0
```

using the initial conditions

```
x(0) = 1
x'(0) = 0.
```


## Compile

```
make
```

Gfortran compiler is required to build the program (tested with GCC 6.3.0 and 7.4.0). Alternatively, one can uncomment `FC=ifort` and `FFLAGS` in the Makefile and compile using ifort.



## Run

Running the program:

```
./build/main
```

The program will print the solution in CSV format to the standard output:

```
t, x, exact, abs_error
 0.00000000000000000E+00, 1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00
 1.00000000000000006E-01, 9.94999999999999996E-01, 9.95004165278025710E-01, 4.16527802571398098E-06
 2.00000000000000011E-01, 9.80050000000000088E-01, 9.80066577841241626E-01, 1.65778412415384935E-05
 3.00000000000000044E-01, 9.55299500000000079E-01, 9.55336489125605981E-01, 3.69891256059018403E-05
 ...
```

where, `t` is the time variable, `x` is the approximate solution, `exact` is the exact solution, and `abs_error` is the absolute value of the difference between `x` and `exact`.



## Run with settings

One can also customize program settings:

```
./build/main --t_end=12.56 --delta_t=0.05
```

Run the program with `--help` flag to see the description of parameters:

```
./build/main --help

This program solves ODE

  x''(t) + x(t) = 0

with initial conditions x(0) = 1, x'(0) = 0.


Usage:

 ./build/main [--t_end=6.2] [--delta_t=0.1]

    --t_end=NUMBER   : the end value for t,
               Default: 6.28.

    --delta_t=NUMBER : size of the timestep,
               Default: 0.1.

    --print_last : print only solution for the final t,

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


### Plot numerical and exact solutions

```
python plot_solution.py
```

### Plot absolute errors

```
python plot_absolute_errors.py
```


### Plot error vs time step

```
python plot_errors_vs_delta_t.py
```
