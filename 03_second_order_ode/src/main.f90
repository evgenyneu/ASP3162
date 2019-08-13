! Contains the entry point to the program
program Main
use OdeSolver, only: read_settings_solve_and_print
implicit none

call read_settings_solve_and_print(silent=.false.)

end program Main