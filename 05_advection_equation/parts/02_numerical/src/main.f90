! Contains the entry point to the program
program Main
use RootFinder, only: read_settings_find_roots_and_print_output
implicit none

call read_settings_find_roots_and_print_output(silent=.false.)

end program Main