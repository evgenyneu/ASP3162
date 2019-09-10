!
! Helper functions to deal with file system
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
    real(dp) :: xmin, xmax
    integer :: nx

    ! Assign shortcuts variables from settings
    xmin = options%x_start
    xmax = options%x_end
    nx = options%nx

    nt_allocated = 10
    allocate(solution(nx, nt_allocated))
    allocate(x_points(nx))
    allocate(t_points(nt_allocated))

    ! Assign evenly spaced x values
    call linspace(xmin, xmax, x_points)

    solution = 0
    t_points = 0
end subroutine

end module Grid