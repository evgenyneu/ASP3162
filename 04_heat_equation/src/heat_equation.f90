!
! Solves a heat equation
!
module HeatEquation
use Types, only: dp
use Constants, only: pi
use Settings, only: program_settings
implicit none
private
public :: solve_heat_equation, print_data, solve_and_create_output

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
    integer :: nx, nt, n

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

    ! Allocate the arrays
    allocate(data(nx, nt))
    allocate(exact(nx, nt))
    allocate(errors(nx, nt))
    allocate(x_points(nx))
    allocate(t_points(nt))

    ! The evenly spaced x values
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
end subroutine

subroutine print_data(data, x_points, t_points, output)
    real(dp), intent(in) :: data(:,:),  x_points(:), t_points(:)
    character(len=:), allocatable, intent(out) :: output
    character(len=:), allocatable :: tmp_arr
    character(len=1024) :: buffer
    integer :: n, nx, j, allocated = 2024
    character(len=1024) :: rowfmt

    allocate(character(len=allocated) :: output)
    output = ""
    nx = size(x_points)
    write(rowfmt,'(A,I4,A)') '(',nx + 1,'(1X,ES24.17))'
    write(buffer, fmt = rowfmt) 0._dp, (x_points(j), j=1, nx)
    output = output // trim(buffer) // new_line('A')

    do n = 1, size(t_points)
        write(buffer, fmt = rowfmt) t_points(n), (data(j, n), j=1, nx)
        output = output // trim(buffer) // new_line('A')

        ! Resize the string array if two small
        if (len(output) > allocated / 2) then
            allocated = 2 * allocated
            allocate(character(len=allocated) :: tmp_arr)
            tmp_arr = output
            deallocate(output)
            call move_alloc(tmp_arr, output)
        end if
    end do
end subroutine

subroutine write_to_file(text, path)
    character(len=*), intent(in) :: text, path
    integer, parameter :: out_unit=20

    open(unit=out_unit, file=path, action="write", status="replace")
    write(out_unit, "(a)") text
    close(unit=out_unit)
end subroutine

subroutine solve_and_create_output(options)
    type(program_settings), intent(in) :: options
    real(dp), allocatable :: data(:,:), errors(:,:)
    real(dp), allocatable :: x_points(:), t_points(:)
    character(len=:), allocatable :: data_output, errors_output

    call solve_heat_equation(options, data, errors, x_points, t_points)
    call print_data(data, x_points, t_points, data_output)
    call print_data(errors, x_points, t_points, errors_output)
    call write_to_file(data_output, options%output_path)
    call write_to_file(errors_output, options%errors_path)
end subroutine


end module HeatEquation