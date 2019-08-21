!
! Solves a heat equation
!
module HeatEquation
use Types, only: dp
use Constants, only: pi
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
    real(dp) :: l, x0, x1, dx, t0, tf, dt, alpha, k
    real(dp), allocatable :: data(:,:), x_points(:)
    integer :: nx, nt, in

    k = 2.28e-5_dp
    l = 1._dp
    x0 = 0._dp
    x1 = x1 + l
    nx = 20
    dx = (x1 - x0) / nx
    alpha = 0.25_dp
    dt =  alpha * dx**2 / k

    t0 = 0
    nt = 100
    allocate(data(nx, nt))
    allocate(x_points(nx))
    call linspace(x0, x1, x_points)

    ! Set intial conditions
    data(:, 1) = sin(pi * x_points / l)

    do in = 1, nt - 1

    end do

    print *, 'dx=', dx, ' dt=', dt
    print *, 'xpoints=', x_points
    print *, 'data(:,1)=', data(:, 1)
end subroutine

end module HeatEquation