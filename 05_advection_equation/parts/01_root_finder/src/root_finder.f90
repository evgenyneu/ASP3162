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
!   f(x) = cos(x) - x
!
! Inputs:
! --------
!
! x : value of independent variable
!
! Outputs:
! -------
!
! Returns: the value of function f(x)
!
function my_function(x) result(result)
    real(dp), intent(in) :: x
    real(dp) :: result
    result = cos(x) - x
end function

!
! Calculate the value of the derivative f'(x) of the function
!
!   f(x) = cos(x) - x,
!
! where
!
!   f'(x) = -sin(x) - 1
!
! Inputs:
! --------
!
! x : value of independent variable
!
! Outputs:
! -------
!
! Returns: the value of function f'(x)
!
function my_function_derivative(x) result(result)
    real(dp), intent(in) :: x
    real(dp) :: result
    result = -sin(x) - 1
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