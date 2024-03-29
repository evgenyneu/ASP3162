!
! Perform one step of integration
!
module Step
use Types, only: dp
use Settings, only: program_settings
use InitialConditions, only: calculate_initial
implicit none
private
public :: step_exact, step_ftcs, step_lax, step_upwind, step_lax_wendroff

contains


!
! Calculate the exact solution by moving the initial initial_condition 
! to the right by v * t
!
! Inputs:
! -------
!
! options : program options
!
! t : time value.
!
! nt : the current time index in solutions array for which the solution needs
!      to be calcualted.
!
! x_points : A 1D array containing the values of the x coordinate
!
!
! Outputs:
! -------
!
! solution : 2D array containing the solution for the advection equation
!        first coordinate is x, second is time.
!
subroutine step_exact(options, t, nt, x_points, solution)
    type(program_settings), intent(in) :: options
    integer, intent(in) :: nt
    real(dp), intent(in) :: t
    real(dp), intent(in) :: x_points(:)
    real(dp), intent(inout) :: solution(:,:)
    real(dp) :: x_points_shifted(size(x_points))
    real(dp) :: shift, xmin, xmax, v

    xmin = options%x_start
    xmax = options%x_end
    v = options%velocity

    ! Calculate the distance the solution has moved to the right (for v > 0)
    shift = mod(v * t, xmax - xmin)

    ! Shift the x values
    x_points_shifted = x_points - shift

    where (x_points - xmin < shift)
        ! For x values smaller than shift
        ! add xmax - xmin to make the initial initial_condition
        ! continue from the start
        x_points_shifted = x_points_shifted + xmax - xmin
    end where

    call calculate_initial(type=options%initial_conditions, &
                           x_points=x_points_shifted, &
                           solution=solution(:, nt))
end subroutine


!
! Calculate solution for step of the FTCS method
!
! Inputs:
! -------
!
! nx : total number of x points in solution array.
!
! nt : the current time index in solutions array for which the solution needs
!      to be calcualted.
!
! dx : size of space step
!
! dt : size of time step
!
! v : velocity parameter in advection equation
!
!
! Outputs:
! -------
!
! solution : 2D array containing the solution for the advection equation
!        first coordinate is x, second is time.
!
subroutine step_ftcs(nx, nt, dx, dt, v, solution)
    integer, intent(in) :: nt, nx
    real(dp), intent(in) :: dx, dt, v
    real(dp), intent(inout) :: solution(:,:)
    real(dp) :: a

    a = 0.5_dp * v * dt / dx

    solution(2 : nx - 1, nt) = solution(2 : nx - 1, nt - 1) &
            - a * (solution(3 : nx, nt - 1) - solution(1 : nx - 2, nt - 1))
end subroutine


!
! Calculate solution for step of the Lax method
!
! Inputs:
! -------
!
! nx : total number of x points in solution array.
!
! nt : the current time index in solutions array for which the solution needs
!      to be calcualted.
!
! dx : size of space step
!
! dt : size of time step
!
! v : velocity parameter in advection equation
!
!
! Outputs:
! -------
!
! solution : 2D array containing the solution for the advection equation
!        first coordinate is x, second is time.
!
subroutine step_lax(nx, nt, dx, dt, v, solution)
    integer, intent(in) :: nt, nx
    real(dp), intent(in) :: dx, dt, v
    real(dp), intent(inout) :: solution(:,:)
    real(dp) :: a

    a = 0.5_dp * v * dt / dx

    solution(2 : nx - 1, nt) = &
        0.5_dp * (solution(3 : nx, nt - 1) + solution(1 : nx - 2, nt - 1)) &
        - a * (solution(3 : nx, nt - 1) - solution(1 : nx - 2, nt - 1))
end subroutine


!
! Calculate solution for step of the Upwind method
!
! Inputs:
! -------
!
! nx : total number of x points in solution array.
!
! nt : the current time index in solutions array for which the solution needs
!      to be calcualted.
!
! dx : size of space step
!
! dt : size of time step
!
! v : velocity parameter in advection equation
!
!
! Outputs:
! -------
!
! solution : 2D array containing the solution for the advection equation
!        first coordinate is x, second is time.
!
subroutine step_upwind(nx, nt, dx, dt, v, solution)
    integer, intent(in) :: nt, nx
    real(dp), intent(in) :: dx, dt, v
    real(dp), intent(inout) :: solution(:,:)
    real(dp) :: a

    a = v * dt / dx

    if (v > 0) then
        solution(2 : nx - 1, nt) = solution(2 : nx - 1, nt - 1) &
            - a * (solution(2 : nx - 1, nt - 1) - solution(1 : nx - 2, nt - 1))
    else
        solution(2 : nx - 1, nt) = solution(2 : nx - 1, nt - 1) &
            - a * (solution(3 : nx, nt - 1) - solution(2 : nx - 1, nt - 1))
    end if
end subroutine


!
! Calculate solution for step of the Lax-Wendroff method
!
! Inputs:
! -------
!
! nx : total number of x points in solution array.
!
! nt : the current time index in solutions array for which the solution needs
!      to be calcualted.
!
! dx : size of space step
!
! dt : size of time step
!
! v : velocity parameter in advection equation
!
!
! Outputs:
! -------
!
! solution : 2D array containing the solution for the advection equation
!        first coordinate is x, second is time.
!
subroutine step_lax_wendroff(nx, nt, dx, dt, v, solution)
    integer, intent(in) :: nt, nx
    real(dp), intent(in) :: dx, dt, v
    real(dp), intent(inout) :: solution(:,:)
    real(dp) :: a

    a = v * dt / dx

    solution(2 : nx - 1, nt) = solution(2 : nx - 1, nt - 1) &
        - 0.5_dp * a * &
           (solution(3 : nx, nt - 1) - solution(1 : nx - 3, nt - 1)) &
        + 0.5_dp * (a**2) * &
           (solution(3 : nx, nt - 1) &
                - 2 * solution(2 : nx - 1, nt - 1) &
                + solution(1 : nx - 3, nt - 1))
end subroutine


end module Step