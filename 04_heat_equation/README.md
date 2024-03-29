# A Fortran program for a heat equation

This this a Fortran program that solves the equation

```
dT/dt = k d^2T/dx^2
```

using the initial condition

```
T(x, 0) = 100 sin(pi x / L)
```

and boundary conditions

```
T(0,t) = T(L,t) = 0,
```

where `L=1 m`.


## Compile

```
make
```

Gfortran compiler is required to build the program (tested with GCC 6.3.0 and 7.4.0). Alternatively, one can uncomment `FC=ifort` and `FFLAGS` in the Makefile and compile using ifort.



## Run

Running the program:

```
./build/main data errors
```

The program will print the solution into the `data` file. The first row contains x-values, the first column contains the t-values, and the inner matrix contains temperature solution for the corresponding x and t:

```
0.00000000000000000E+00  0.00000000000000000E+00  5.26315789473684181E-02  1.05263157894736836E-01  1.57894736842105254E-01  2.10526315789473673E-01  2.63157894736842091E-01  3.15789473684210509E-01  3.68421052631578927E-01  4.21052631578947345E-01  4.73684210526315763E-01  5.26315789473684181E-01  5.78947368421052655E-01  6.31578947368421018E-01  6.84210526315789491E-01  7.36842105263157854E-01  7.89473684210526327E-01  8.42105263157894690E-01  8.94736842105263164E-01  9.47368421052631526E-01  1.00000000000000000E+00
  0.00000000000000000E+00  0.00000000000000000E+00  1.64594590280733897E+01  3.24699469204683453E+01  4.75947393037073496E+01  6.14212712689667839E+01  7.35723910673131627E+01  8.37166478262528528E+01  9.15773326655057360E+01  9.69400265939330410E+01  9.96584493006669874E+01  9.96584493006669874E+01  9.69400265939330410E+01  9.15773326655057502E+01  8.37166478262528813E+01  7.35723910673131627E+01  6.14212712689667910E+01  4.75947393037073709E+01  3.24699469204683595E+01  1.64594590280734039E+01  0.00000000000000000E+00
  2.74122797321586127E+01  0.00000000000000000E+00  1.63472162441537812E+01  3.22485230431793610E+01  4.72701741992124553E+01  6.10024182272385218E+01  7.30706753074614852E+01  8.31457548463311582E+01  9.09528349377993379E+01  9.62789587885096978E+01  9.89788436239834937E+01  9.89788436239834937E+01  9.62789587885096978E+01  9.09528349377993521E+01  8.31457548463311724E+01  7.30706753074614994E+01  6.10024182272385289E+01  4.72701741992124767E+01  3.22485230431793752E+01  1.63472162441537918E+01  0.00000000000000000E+00
  5.48245594643172254E+01  0.00000000000000000E+00  1.62357388828717291E+01  3.20286091324312423E+01  4.69478224172107019E+01  6.05864214902877478E+01  7.25723809221231591E+01  8.25787549844807813E+01  9.03325958776098901E+01  9.56223990347005497E+01  9.83038724151150518E+01  9.83038724151150518E+01  9.56223990347005639E+01  9.03325958776098901E+01  8.25787549844807955E+01  7.25723809221231733E+01  6.05864214902877620E+01  4.69478224172107161E+01  3.20286091324312565E+01  1.62357388828717397E+01  0.00000000000000000E+00
  8.22368391964758416E+01  0.00000000000000000E+00  1.61250217245436751E+01  3.18101948912362289E+01  4.66276688642850985E+01  6.01732615799773356E+01  7.20774845797537154E+01  8.20156216921736529E+01  8.97165864436002778E+01  9.49703165905315103E+01  9.76335040700114263E+01  9.76335040700114263E+01  9.49703165905315245E+01  8.97165864436002778E+01  8.20156216921736672E+01  7.20774845797537296E+01  6.01732615799773498E+01  4.66276688642851127E+01  3.18101948912362431E+01  1.61250217245436858E+01  0.00000000000000000E+00
  1.09649118928634451E+02  0.00000000000000000E+00  1.60150595850808948E+01  3.15932700928253070E+01  4.63096985499459421E+01  5.97629191509983713E+01  7.15859631079146084E+01  8.14563286019253212E+01  8.91047777924764262E+01  9.43226809236686847E+01  9.69677072001414473E+01  9.69677072001414473E+01  9.43226809236686847E+01  8.91047777924764404E+01  8.14563286019253354E+01  7.15859631079146226E+01  5.97629191509983855E+01  4.63096985499459564E+01  3.15932700928253212E+01  1.60150595850809054E+01  0.00000000000000000E+00
 ...
```

The absolute errors of the numerical solutions are writtern to the `errors` file in the same format.



## Run with settings

One can also customize program settings:

```
./build/main --t_end=12.56 --delta_t=0.05
```

Run the program with `--help` flag to see the description of parameters:

```
./build/main --help

This program solves the heat equation

  dT/dt = k d^2T/dx^2

with initial condition
  T(x,0) = 100 sin(pi x / L)
and boundary conditions
   T(0,t) = T(L,t) = 0,
 where L = 1 m.


Usage:

 ./build/main OUTPUT ERRORS [--nx=20] [--nt=300] [--alpha=0.2] [--k=2.28e-5]

    OUTPUT : path to the output data file


    ERRORS : path to the output errors file


    --nx=NUMBER : number of x points in the grid,
                  including the points on the edges.
                  Default: 21.

    --nt=NUMBER : number of t points in the grid,
                  Default: 300.

    --alpha=NUMBER : The alpha parameter of the numerical
     solution of the heat equation. Values larger than
     0.5 results in unstable solutions. Default: 0.25.

    --k=NUMBER : Thermal diffusivity of the rod in m^2 s^{-1} units.
                 Default: 2.28e-5.

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


### Plot approximate solution and the errors

```
python plot_solution.py
```