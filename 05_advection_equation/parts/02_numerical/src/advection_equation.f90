!
! Solves an advection equation
!
module AdvectionEquation
use Types, only: dp
use Constants, only: pi
use Settings, only: program_settings, read_from_command_line
use FloatUtils, only: linspace
implicit none
private
public :: solve_equation, print_data, solve_and_create_output, &
          read_settings_solve_and_create_output, write_to_file

contains

!
! Solve the advection equation
!
!   v_t + v v_x = 0
!
! with initial conditions
!
!    v(x,0) = cos x
!
! and boundary conditions
!
!   v(−pi/2, t) = v(pi/2, t) = 0
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
subroutine solve_equation(options, solution, x_points, t_points)
    type(program_settings), intent(in) :: options
    real(dp), allocatable, intent(out) :: solution(:,:)
    real(dp), allocatable, intent(out) :: x_points(:), t_points(:)
    real(dp) :: l, x0, x1, dx, t0, dt, t
    integer :: nx, nt, n

    ! x0 = 0._dp
    ! x1 = x0 + l
    ! nx = options%nx
    ! dx = (x1 - x0) / (nx - 1)
    ! alpha = options%alpha
    ! dt =  alpha * dx**2 / k
    ! t0 = 0
    ! nt = options%nt

    ! ! Allocate the arrays
    ! allocate(data(nx, nt))
    ! allocate(exact(nx, nt))
    ! allocate(errors(nx, nt))
    ! allocate(x_points(nx))
    ! allocate(t_points(nt))

    ! ! Assign evenly spaced x values
    ! call linspace(x0, x1, x_points)

    ! ! Set initial conditions
    ! data(:, 1) = 100 * sin(pi * x_points / l)

    ! ! Set boundary conditions
    ! data(1, :) = 0
    ! data(nx, :) = 0

    ! ! Calculate numerical solution using forward differencing method
    ! do n = 1, nt - 1
    !     data(2 : nx - 1, n + 1) = data(2 : nx - 1, n) &
    !         + alpha * ( &
    !             data(3 : nx, n) &
    !             - 2 * data(2 : nx - 1, n) &
    !             + data(1 : nx - 2, n) &
    !         )
    ! end do

    ! ! Calculate exact solution
    ! do n = 1, nt
    !     t = t0 + real(n - 1, dp) * dt
    !     t_points(n) = t

    !     exact(:, n) = 100 * exp(-(pi**2)*k*t / (l**2)) * sin(pi * x_points / l)
    ! end do

    ! ! Calculate the errors
    ! errors = abs(exact - data)
end subroutine


!
! Prints 2D array containing solutions (or their errors)
! to a string variable. In addition to the solution, the first row
! contains the x coordinate, and the first column contains the t coordinate
!
! Inputs:
! -------
!
! data : a 2D array containing solutions or errors for printing
!
! x_points : A 1D array containing the values of the x coordinate
!
! t_points : A 1D array containing the values of the time coordinate
!
!
! Outputs:
! -------
!
! output : text output containing solution
!
subroutine print_data(data, x_points, t_points, output)
    real(dp), intent(in) :: data(:,:),  x_points(:), t_points(:)
    character(len=:), allocatable, intent(out) :: output
    character(len=:), allocatable :: tmp_arr
    character(len=1024*10) :: buffer
    integer :: n, nx, j, allocated = 1024*10
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

        ! Resize the string array if too small
        if (len(output) > allocated / 2) then
            allocated = 2 * allocated
            allocate(character(len=allocated) :: tmp_arr)
            tmp_arr = output
            deallocate(output)
            call move_alloc(tmp_arr, output)
        end if
    end do
end subroutine


!
! Write text to a file
!
! Inputs:
! -------
!
! text : a text to be written
!
! path : path to a text file to be created
!
subroutine write_to_file(text, path)
    character(len=*), intent(in) :: text, path
    integer, parameter :: out_unit=20

    open(unit=out_unit, file=path, action="write", status="replace")
    write(out_unit, "(a)") text
    close(unit=out_unit)
end subroutine

!
! Solves PDE and prints solutions and errors to files
!
! Inputs:
! -------
!
! options : program options
!
subroutine solve_and_create_output(options)
    type(program_settings), intent(in) :: options
    real(dp), allocatable :: data(:,:)
    real(dp), allocatable :: x_points(:), t_points(:)
    character(len=:), allocatable :: data_output

    call solve_equation(options, data, x_points, t_points)
    call print_data(data, x_points, t_points, data_output)
    call write_to_file(data_output, options%output_path)
end subroutine

!
! Reads program settings from command line arguments,
! solves PDE and prints solutions and errors to files
!
! Inputs:
! -------
!
! silent : do not show any output if .true. (used in unit tests)
!
subroutine read_settings_solve_and_create_output(silent)
    logical, intent(in) :: silent
    type(program_settings) :: settings
    logical :: success

    call read_from_command_line(silent=silent, settings=settings, &
                                success=success)

    if (.not. success) then
        if (.not. silent) call exit(41)
        return
    end if

    call solve_and_create_output(options=settings)

    if (.not. silent) then
        print "(a, a, a)", "Solution saved to '", &
            trim(settings%output_path), "'"
    end if

end subroutine


end module AdvectionEquation