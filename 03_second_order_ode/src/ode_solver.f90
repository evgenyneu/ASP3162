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
! Data for the ODE solution
!
type, public :: ode_solution
    ! arrau of t values
    real(dp), allocatable :: t_values(:)

    ! arrau of x values
    real(dp), allocatable :: x_values(:)

    ! the nubmer of elements in `t_values` and `x_values` arrays
    integer :: size
end type ode_solution

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
!
! Outputs:
! -------
!
! solution : solution to the ODE.
!
subroutine solve_ode(t_start, t_end, delta_t, solution)
    real(dp), intent(in) :: t_start, t_end, delta_t
    type(ode_solution), intent(out) :: solution
end subroutine

end module OdeSolver