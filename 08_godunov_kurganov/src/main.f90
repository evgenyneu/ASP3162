! Contains the entry point to the program
program Main
use Equation, only: read_settings_solve_and_create_output
implicit none

call read_settings_solve_and_create_output(silent=.false.)

end program Main
