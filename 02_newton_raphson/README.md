# Finding a single root of equation with Newton-Raphson method

This this a Fortran program that finds a single root of equation

```
cos(x) - x = 0
```

using Newton-Raphson method.


## Compile

```
make
```

Gfortran compiler is required to build the program (tested with GCC 6.3.0 and 7.4.0). Alternatively, one can uncomment `FC=ifort` and `FFLAGS` in the Makefile and compile using ifort.

## Run

Running the program:

```
./build/main 0.5
```

where `0.5` is the initial x-value for the root finding method. The program will return the approximated root value:

```
 0.73908513321516067
```

 ## Run with settings

One can also configure parameters of the program:

```
./build/main 1.3 --tolerance=1e-5 --max_iterations=15
```

Run the program with `--help` flag to see the description of the parameters:

```
./build/main --help

This program finds a single root of equation 

    cos(x) - x = 0

using Newton-Raphson method.

Usage:

 ./build/main XSTART [--tolerance=1e-5] [--max_iterations=20]

    XSTART : the starting x value for finding the root. Ex: 0.5.

    tolerance : convergence tolerance for Newton-Raphson method.
                Default: 1.e-5.

    max_iterations : the maximum number of iterations of 
                     the Newton-Raphson method.
                     Default: 20.

    --help : show this message
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

### Plot failure ratio

```
python plot_failure_ratio.py
```

The code requires the Fortran executable to be present.


### Plot `f(x) = cos(x) - x` function

```
python plot_function.py
```
