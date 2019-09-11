!
! Initialize the arrays for the x, t values and the solution
!
module Grid
use Types, only: dp
use Settings, only: program_settings
use FloatUtils, only: linspace
implicit none
private
public :: set_grid

contains

!
! Initialize the arrays for the solution,
! the x and t values
!
! Inputs:
! -------
!
! options : program options
!
!
! Outputs:
! -------
!
! solution : 2D array containing the solution for the advection equation
!        first coordinate is x, second is time.
!
! x_points : A 1D array containing the values of the x coordinate
!
! t_points : A 1D array containing the values of the time coordinate
!
! nt_allocated : the number of t points allocated in the arrays.
!
subroutine set_grid(options, solution, x_points, t_points, nt_allocated)
    type(program_settings), intent(in) :: options
    real(dp), allocatable, intent(out) :: solution(:,:)
    real(dp), allocatable, intent(out) :: x_points(:), t_points(:)
    integer, intent(out) :: nt_allocated
    real(dp) :: xmin, xmax, dx
    integer :: nx

    ! Assign shortcut variables from settings
    xmin = options%x_start
    xmax = options%x_end
    nx = options%nx

    ! Size of the t dimension, an arbitrary number.
    ! The t dimension will grow as the arrays get enlarged when needed
    nt_allocated = 12

    ! Allocate memory for the arrays
    allocate(solution(nx, nt_allocated))
    allocate(x_points(nx))
    allocate(t_points(nt_allocated))

    !
    ! Assign evenly spaced x values.
    !
    ! Here we assign the x values located *in the middle* of the grid cells:
    !
    !   (xmin)---x1---|---x2---|  ...  |---xn---(xmax)
    !
    ! For example consider a grid with four x values (nx=4)
    ! and xmin = 0, xmax = 10. Our grid will look like
    !
    !   (0)---x1---|---x2---|---x3---|---x4---(10)
    !
    ! and the x values will be
    !
    !   (0)---1.25---|---3.75---|---6.25---|---8.75---(10)
    !

    dx = (xmax - xmin) / nx
    call linspace(xmin + dx / 2, xmax - dx / 2, x_points)

    ! Initialize the arrays with zeros
    solution = 0
    t_points = 0
end subroutine

end module Grid