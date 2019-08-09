! Contains the entry point to the program
program Main
use RootFinder, only: do_it
implicit none

call do_it(silent=.false.)

end program Main