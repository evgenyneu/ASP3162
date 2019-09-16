!
! Perform one step of integration
!
module Step
use Types, only: dp
implicit none
private
public :: step_ftcs, step_lax

contains

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

    ! Pre-calculate the multiplier
    a = 0.5_dp * v * dt / dx

    solution(2 : nx - 1, nt) = &
        0.5_dp * (solution(3 : nx, nt - 1) + solution(1 : nx - 2, nt - 1)) &
        - a * (solution(3 : nx, nt - 1) - solution(1 : nx - 2, nt - 1))
end subroutine

end module Step