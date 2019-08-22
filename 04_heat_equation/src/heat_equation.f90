!
! Solves a heat equation
!
module HeatEquation
use Types, only: dp
use Constants, only: pi
use Settings, only: program_settings
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

subroutine solve_heat_equation(options, data, errors, x_points, t_points)
    type(program_settings), intent(in) :: options
    real(dp), allocatable, intent(out) :: data(:,:), errors(:,:)
    real(dp), allocatable, intent(out) :: x_points(:), t_points(:)
    real(dp) :: l, x0, x1, dx, t0, dt, alpha, k, t
    real(dp), allocatable :: exact(:,:)
    integer :: nx, nt, n, j
    character(len=1024) :: rowfmt

    k = options%k
    l = 1._dp
    x0 = 0._dp
    x1 = x0 + l
    nx = options%nx
    dx = (x1 - x0) / nx
    alpha = options%alpha
    dt =  alpha * dx**2 / k

    t0 = 0
    nt = options%nt
    allocate(data(nx, nt))
    allocate(exact(nx, nt))
    allocate(errors(nx, nt))
    allocate(x_points(nx))
    allocate(t_points(nt))
    call linspace(x0, x1, x_points)

    ! Set intial conditions
    data(:, 1) = 100._dp * sin(pi * x_points / l)

    ! Set boundary conditions
    data(1, :) = 0
    data(nx, :) = 0

    ! Calculate numerical solution using forward differencing method
    do n = 1, nt - 1
        data(2:nx-1, n + 1) = data(2:nx-1, n) + &
                alpha * (data(3:nx, n) - 2 * data(2:nx-1, n) + data(1:nx-2, n))
    end do

    ! Calculate exact solution
    do n = 1, nt
        t = t0 + real(n - 1, dp) * dt
        t_points(n) = t

        exact(:, n) = 100 * exp(-(pi**2)*k*t / (l**2)) * sin(pi * x_points / l)
    end do

    ! Calculate the errors
    errors = abs(exact - data)

    ! print *, x_points

    ! print *, exact(:, 10)
    ! print *, errors(:, 100)

    ! ! Print to a file
    ! print *, data

    ! write(rowfmt,'(A,I4,A)') '(',nx + 1,'(1X,ES24.17))'
    ! open(unit=12, file="heat_eqn_output.txt", action="write", &
    !     status="replace")

    ! write(12, fmt = rowfmt) 0._dp, (x_points(j), j=1, nx)

    ! do n = 1, nt
    !     write(12, fmt = rowfmt) t_points(t), (data(j, n), j=1, nx)
    ! end do
    ! close(unit=12)

    ! print *, 'dx=', dx, ' dt=', dt
    ! print *, 'xpoints=', x_points
    ! print *, 'data(:,1)=', data(:, 1)

    ! print *, trim(rowfmt)
end subroutine

end module HeatEquation