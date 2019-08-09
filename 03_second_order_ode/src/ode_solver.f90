!
! Solves the ODE:
!
!   x''(t) + x(t) = 0.
!
module OdeSolver
use Types, only: dp
implicit none
private
public :: solve_ode

!
! Stores program settings:
!
type, public :: program_settings
    ! the starting value for x for the root finding algorithm.
    real(dp) :: x_start

    ! convergence tolerance for Newton-Raphson method.
    real(dp) :: tolerance

    ! the maximum number of iterations of the Newton-Raphson method.
    integer :: max_iterations
end type program_settings

contains

!
! Solves the ODE
!
!   x''(t) + x(t) = 0.
!
! Outputs:
! -------
!
! t_start : intial value of t coordinate
!
! t_end : final value of t coordinate
!
! delta_t : size of the time step
!
subroutine solve_ode(t_start, t_end, delta_t)
    real(dp), intent(in) :: t_start, t_end, delta_t
end subroutine

end module OdeSolver