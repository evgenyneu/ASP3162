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
public :: solve_equation, print_output, solve_and_create_output, &
          read_settings_solve_and_create_output

contains


!
! Solve the advection equation using cetered-difference method
! for space coordinate
!
! Inputs:
! -------
!
! nx : number of x points
!
! nt : number of t points
!
! nx : size of space step
!
! nx : size of time step
!
!
! Outputs:
! -------
!
! solution : 2D array containing the solution for the advection equation
!        first coordinate is x, second is time.
!
subroutine solve_centered(tmin, tmax, nx, nt, nt_allocated, &
                          dx, dt, v, solution, t_points)

    integer, intent(in) :: nx
    integer, intent(inout) :: nt, nt_allocated
    real(dp), intent(in) :: tmin, tmax, dx, dt, v
    real(dp), allocatable, intent(inout) :: solution(:,:)
    real(dp), allocatable :: solution_buffer(:,:)
    real(dp), allocatable, intent(inout) :: t_points(:)
    real(dp), allocatable :: t_points_buffer(:)
    real(dp) :: a, t
    integer :: n, i

    ! Pre-calculate the multiplier
    a = 0.5_dp * v * dt / dx

    t = tmin

    ! Calculate numerical solution
    do while (t < tmax)
        t = t + dt
        nt = nt + 1

        ! Make the the t axis larger in the arrays, if necessary
        if (nt > nt_allocated / 2) then
            ! Enlarge t_points array
            ! -------

            nt_allocated = 2 * nt_allocated
            allocate(t_points_buffer(nt_allocated))
            t_points_buffer = 0
            t_points_buffer(1:size(t_points)) = t_points
            deallocate(t_points)
            call move_alloc(t_points_buffer, t_points)

            ! Enlarge t axis of the solution array
            ! -------

            allocate(solution_buffer(nx, nt_allocated))
            solution_buffer = 0
            solution_buffer(:, 1: size(solution, 2)) = solution
            deallocate(solution)
            call move_alloc(solution_buffer, solution)
        end if

        ! Calculate t values for all x except the edges
        solution(2 : nx - 1, nt + 1) = solution(2 : nx - 1, nt) &
                - a * (solution(3 : nx, nt) - solution(1 : nx - 2, nt))

        ! Left edge
        solution(1, nt + 1) = solution(1, nt) &
                - a * (solution(2, nt) - solution(nx, nt))

        ! Right edge
        solution(nx, nt + 1) = solution(nx, nt) &
                - a * (solution(1, nt) - solution(nx - 1, nt))
    end do
end subroutine


!
! Solve the advection equation using upwind method
! for space coordinate
!
! Inputs:
! -------
!
! nx : number of x points
!
! nt : number of t points
!
! nx : size of space step
!
! nx : size of time step
!
!
! Outputs:
! -------
!
! solution : 2D array containing the solution for the advection equation
!        first coordinate is x, second is time.
!
subroutine solve_upwind(nx, nt, dx, dt, solution)
    integer, intent(in) :: nx, nt
    real(dp), intent(in) :: dx, dt
    real(dp), allocatable, intent(inout) :: solution(:,:)
    real(dp) :: a
    integer :: n, ix, q

    ! Pre-calculate the multiplier
    a = 0.5_dp * dt / dx

    ! Calculate numerical solution
    do n = 1, nt - 1
        do ix = 1, nx - 2
            if (solution(ix + 1, n) > 0) then
                q = 0
            else
                ! Add 1 to the x index if velocity is negative
                q = 1
            end if

            solution(ix + 1, n + 1) = solution(ix + 1, n) &
                - a * (solution(ix + 1 + q, n)**2 - solution(ix + q, n)**2)
        end do
    end do
end subroutine


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
    real(dp) :: xmin, xmax, dx, tmin, tmax, dt, v
    integer :: nx, nt, nt_allocated

    ! Assign shortcuts variables from settings
    xmin = options%x_start
    xmax = options%x_end
    nx = options%nx

    tmin = options%t_start
    tmax = options%t_end
    v = options%velocity

    nt = 0
    nt_allocated = 10

    ! Allocate the arrays
    allocate(solution(nx, nt_allocated))
    allocate(x_points(nx))
    allocate(t_points(nt_allocated))

    ! Assign evenly spaced x values
    call linspace(xmin, xmax, x_points)
    ! call linspace(t0, t1, t_points)

    solution = 0
    t_points = 0

    ! Set initial conditions
    where (x_points > 0.25 .and. x_points <= 0.75)
        solution(:, 1) = 1
    elsewhere
        solution(:, 1) = 0
    end where

    ! Calculate the steps
    dx = x_points(2) - x_points(1)
    dt = 0.5_dp * dx / v

    select case (options%method)
        case ("centered")
           call solve_centered(tmin=tmin, tmax=tmax, nx=nx, nt=nt, &
                nt_allocated=nt_allocated, &
                dx=dx, dt=dt, v=v, solution=solution, t_points=t_points)
        case ("upwind")
           ! call solve_upwind(nx=nx, nt=nt, dx=dx, dt=dt, solution=solution)
        case default
           print "(a, a)", "ERROR: unknown method ", trim(options%method)
           call exit(41)
    end select
end subroutine


!
! Prints solution to a binary data file. See README.md for description
! of the file format.
!
! Inputs:
! --------
!
! filename : Name of the data file to print output to
!
! solution : 2D array containing the solution (values of v)
!            the first coordinate is x, the second is t.
!
! x_points : A 1D array containing the values of x
!
! t_points : A 1D array containing the values of t
!
subroutine print_output(filename, solution, x_points, t_points)
    character(len=*), intent(in) :: filename
    real(dp), intent(in) :: solution(:, :)
    real(dp), intent(in) :: x_points(:), t_points(:)

    integer, parameter :: out_unit=20

    open(unit=out_unit, file=filename, form="unformatted", action="write", &
        status="replace")

    write(out_unit) size(x_points)
    write(out_unit) size(t_points)
    write(out_unit) x_points
    write(out_unit) t_points
    write(out_unit) solution

    close(unit=out_unit)
end subroutine


!
! Solves PDE and prints solutions to a file
!
! Inputs:
! -------
!
! options : program options
!
subroutine solve_and_create_output(options)
    type(program_settings), intent(in) :: options
    real(dp), allocatable :: solution(:,:)
    real(dp), allocatable :: x_points(:), t_points(:)

    call solve_equation(options, solution, x_points, t_points)

    call print_output(filename=options%output_path, &
                      solution=solution, x_points=x_points, t_points=t_points)
end subroutine


!
! Reads program settings from command line arguments,
! solves PDE and prints solutions to a file
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