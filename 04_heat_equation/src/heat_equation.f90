!
! Solves a heat equation
!
module HeatEquation
use Types, only: dp
implicit none
private
public :: solve_heat_equation

contains


!
! Generates evenly spaced numbers from `from` to `to` (inclusive).
!
! Inputs:
! -------
!
! from, to : the lower and upper boundaries of the numbers to generate
!
! Outputs:
! -------
!
! array : Array of evenly spaced numbers
!
subroutine linspace(from, to, array)
    real(dp), intent(in) :: from, to
    real(dp), intent(out) :: array(:)
    real(dp) :: range
    integer :: n, i
    n = size(array)
    range = to - from

    if (n == 0) return

    if (n == 1) then
        array(1) = from
        return
    end if


    do i=1, n
        array(i) = from + range * (i - 1) / (n - 1)
    end do
end subroutine

subroutine solve_heat_equation()
    real(dp) :: x0, x1, dx, t0, tf, dt, alpha, k
    integer :: nx

    k = 2.28e-5_dp
    x0 = 0._dp
    x1 = 1._dp
    nx = 20
    dx = (x1 - x0) / nx
    alpha = 0.25_dp
    dt =  alpha * dx**2 / k

    t0 = 0
    ! nt = 100
    ! tf = t0 + nt * 

    print *, 'dx=', dx, ' dt=', dt
end subroutine

end module HeatEquation