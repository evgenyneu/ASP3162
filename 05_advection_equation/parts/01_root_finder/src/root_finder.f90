!
! Finds a single root of equation
!
!   cos(x) - x = 0
!
module RootFinder
use Types, only: dp
use Settings, only: program_settings, read_from_command_line
use NewtonRaphson, only: approximate_root
implicit none
private
public :: do_it, find_root, my_function, my_function_derivative

contains

!
! The main function of the program that does all the work:
!
!   * Read program settings from command line arguments.
!
!   * Find the root and display output.
!
! Outputs:
! -------
!
! silent : do not show any output when .true. (used in unit tests)
!
subroutine do_it(silent)
    logical, intent(in) :: silent
    type(program_settings) :: settings
    logical :: success
    real(dp) :: root

    call read_from_command_line(silent=silent, settings=settings, success=success)

    if (.not. success) then
        if (.not. silent) call exit(41)
        return
    end if

    root = find_root(options=settings, success=success)

    if (.not. success) then
        write (0, *) "Could not find root"
        call exit(40)
    end if

    print *, root
end subroutine


!
! Calculate the value of function
!
!   f(v, x, t) = cos(x - v * t) - v,
!
! Inputs:
! --------
!
! v : value of the independent variable
!
! x, t : value of parameters
!
! Outputs:
! -------
!
! Returns: the value of function f
!
function my_function(v, x, t) result(result)
    real(dp), intent(in) :: v, x, t
    real(dp) :: result
    result = cos(x - v * t) - v
end function

!
! Calculate the value of the derivative f' of the function
! with respect to v
!
!   f = cos(x - v * t) - v,
!
! Inputs:
! --------
!
! v : value of the independent variable
!
! x, t : value of parameters
!
! Outputs:
! -------
!
! Returns: the value of function f'
!
function my_function_derivative(v, x, t) result(result)
    real(dp), intent(in) :: v, x, t
    real(dp) :: result
    result = t * sin(x - v * t) - 1
end function

!
! Calculate a single root of equation
!
!   cos(x) - x = 0
!
! Inputs:
! --------
!
! settings : settings used for finding the roots.
!
!
! Outputs:
! -------
!
! success : .true. if algorithm converged to a solution.
!
! Returns: root of equation cos(x) - x = 0
!
function find_root(options, success) result(result)
    type(program_settings), intent(in) :: options
    logical, intent(out) :: success
    real(dp) :: result

    ! result = approximate_root(x_start = options%x_start, &
    !                           func = my_function, &
    !                           derivative = my_function_derivative, &
    !                           tolerance = options%tolerance, &
    !                           max_iterations = options%max_iterations, &
    !                           success = success)
end function

end module RootFinder