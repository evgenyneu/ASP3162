!
! Finds roots of equation
!
!   cos(x - v * t) - v = 0
!
! for a range of values of parameters x and t
!
module RootFinder
use Types, only: dp
use Settings, only: program_settings, read_from_command_line
use NewtonRaphson, only: approximate_root
use FloatUtils, only: linspace
implicit none
private
public :: find_roots_and_print_output, find_root, &
          my_function, my_function_derivative, find_many_roots

contains

!
! The main function of the program that does all the work:
!
!   * Read program settings from command line arguments.
!
!   * Find the roots and prints output to a file
!
! Outputs:
! -------
!
! silent : do not show any output when .true. (used in unit tests)
!
subroutine find_roots_and_print_output(silent)
    logical, intent(in) :: silent
    type(program_settings) :: settings
    logical :: success
    real(dp) :: root

    ! call read_from_command_line(silent=silent, settings=settings, success=success)

    ! if (.not. success) then
    !     if (.not. silent) call exit(41)
    !     return
    ! end if

    ! root = find_root(options=settings, success=success)

    ! if (.not. success) then
    !     write (0, *) "Could not find root"
    !     call exit(40)
    ! end if

    ! print *, root
end subroutine


!
! Calculate the value of function
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
!   cos(x - v * t) - v = 0
!
! for given values of parameters x and t.
!
! Inputs:
! --------
!
! options : settings used for finding the roots.
!
! x, t : value of parameters
!
!
! Outputs:
! -------
!
! success : .true. if algorithm converged to a solution.
!
! Returns: root of equation cos(x - v * t) - v = 0
!
function find_root(options, x, t, success) result(result)
    real(dp), intent(in) :: x, t
    type(program_settings), intent(in) :: options
    logical, intent(out) :: success
    real(dp) :: result

    result = approximate_root( &
                v_start = options%root_finder_v_start, &
                func = my_function, &
                derivative = my_function_derivative, &
                x = x, &
                t = t, &
                tolerance = options%root_finder_tolerance, &
                max_iterations = options%root_finder_max_iterations, &
                success = success)
end function

!
! Find multiple roots of equation
!
!   cos(x - v * t) - v = 0
!
! for a range of parameters x and t.
!
! Inputs:
! --------
!
! options : settings used for finding the roots.
!
!
! Outputs:
! -------
!
! solution : 2D array containing the solution (values of v)
!            first coordinate is x, second is t.
!
! x_points : A 1D array containing the values of x
!
! t_points : A 1D array containing the values of t
!
! success : .true. if algorithm converged to a solution for all values of
!           x and t
!
subroutine find_many_roots(options, solution, x_points, t_points, success)
    type(program_settings), intent(in) :: options
    real(dp), allocatable, intent(out) :: solution(:,:)
    real(dp), allocatable, intent(out) :: x_points(:), t_points(:)
    logical, intent(out) :: success
    integer :: nx, nt, ix, it
    real(dp) :: x_start, x_end, t_start, t_end, dx, dt, root
    real(dp) :: x, t

    ! Assign shortcuts variables from settings
    nx = options%nx
    nt = options%nt
    x_start = options%x_start
    x_end = options%x_end
    t_start = options%t_start
    t_end = options%t_end

    ! Allocate the arrays
    allocate(solution(nx, nt))
    allocate(x_points(nx))
    allocate(t_points(nt))

    ! Assign evenly spaced x and t values
    call linspace(t_start, x_end, x_points)
    call linspace(t_start, t_end, t_points)

    ! Calculate step sizes
    dx = (x_end - x_start) / (nx - 1)
    dt = (t_end - t_start) / (nt - 1)

    ! Calculate solutions for all values of x and t
    do it = 1, nt
        do ix = 1, nx
            x = x_start + (ix - 1) * dx
            t = t_start + (it - 1) * dt

            root = find_root(options=options, x=x, t=t, success=success)
            if (.not. success) return

            solution(ix, it) = root
        end do
    end do
end subroutine


end module RootFinder