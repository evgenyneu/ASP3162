!
! Solves an advection equation
!
module AdvectionEquation
use Types, only: dp
use Constants, only: pi
use Settings, only: program_settings, read_from_command_line
use FloatUtils, only: linspace
use Output, only: write_output
use Grid, only: set_grid
use InitialConditions, only: set_initial
use Step, only: step_exact, step_ftcs, step_lax, step_upwind, step_lax_wendroff
implicit none
private
public :: solve_equation, solve_and_create_output, &
          read_settings_solve_and_create_output, remove_ghost_cells

contains


!
! Change the size of the time dimension in solution and t_points arrays
!
! Inputs:
! -------
!
! new_size : The new size of the time dimensions
!
! keep_elements : the number of elements to keep in resized array
!
!
! Outputs:
! -------
!
! solution : 2D array containing the solution for the advection equation
!        first coordinate is x, second is time.
!
! t_points : A 1D array containing the values of the time coordinate
!
subroutine resize_arrays(new_size, keep_elements, solution, t_points)
    integer, intent(in) :: new_size, keep_elements
    real(dp), allocatable, intent(inout) :: solution(:,:)
    real(dp), allocatable :: solution_buffer(:,:)
    real(dp), allocatable, intent(inout) :: t_points(:)
    real(dp), allocatable :: t_points_buffer(:)

    ! Enlarge t_points array
    ! -------

    allocate(t_points_buffer(new_size))
    t_points_buffer = 0
    t_points_buffer(1:keep_elements) = t_points
    deallocate(t_points)
    call move_alloc(t_points_buffer, t_points)

    ! Enlarge t axis of the solution array
    ! -------

    allocate(solution_buffer(size(solution, 1), new_size))
    solution_buffer = 0
    solution_buffer(:, 1:keep_elements) = solution
    deallocate(solution)
    call move_alloc(solution_buffer, solution)
end subroutine


!
! Removes the ghost cells, which are the values corresponding to
! the first and last x-values. The ghost cells are temporary cells
! and are not needed after the solution has been calculated.
!
! Outputs:
! -------
!
! solution : 2D array containing the solution for the advection equation
!        first coordinate is x, second is time.
!
subroutine remove_ghost_cells(solution)
    real(dp), allocatable, intent(inout) :: solution(:,:)
    real(dp), allocatable :: solution_buffer(:,:)

    allocate(solution_buffer(size(solution, 1) - 2, size(solution, 2)))
    solution_buffer = 0
    solution_buffer(:, :) = solution(2 : size(solution, 1) - 1,:)
    deallocate(solution)
    call move_alloc(solution_buffer, solution)
end subroutine


!
! Iterate over the time values and solve the equation
! for each of them
!
! Inputs:
! -------
!
! options : program options
!
! tmax : the largest time value
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
! nt : the number of t points for which solution has been calculated.
!
! nt_allocated : the number of t points allocated in the arrays.
!
! solution : 2D array containing the solution for the advection equation
!        first coordinate is x, second is time.
!
! x_points : A 1D array containing the values of the x coordinate
!
! t_points : A 1D array containing the values of the time coordinate
!  first coordinate is x, second is time.
!
subroutine iterate(options, tmax, dx, dt, v, &
                   nt, nt_allocated, solution, x_points, t_points)

    type(program_settings), intent(in) :: options
    integer, intent(inout) :: nt_allocated
    integer, intent(out) :: nt
    real(dp), intent(in) :: tmax, dx, dt, v
    real(dp), allocatable, intent(in) :: x_points(:)
    real(dp), allocatable, intent(inout) :: solution(:,:)
    real(dp), allocatable, intent(inout) :: t_points(:)
    integer :: nx

    nx = size(solution, 1) ! number of x points plus two ghost points
    nt = 1

    ! Calculate numerical solution
    do while (t_points(nt) < tmax)
        ! Update the ghost cells.
        ! The leftmost cell gets the values of nx-1 x cell
        ! and the rightmost cell gets the value of the second x cell.
        solution(1, nt) = solution(nx - 1, nt)
        solution(nx, nt) = solution(2, nt)

        ! Increment the time value
        nt = nt + 1
        t_points(nt) = t_points(nt - 1) + dt

        ! Resize the time dimension of the arrays if needed
        if (nt > nt_allocated / 2) then
            nt_allocated = 2 * nt_allocated

            call resize_arrays(new_size=nt_allocated, &
                               keep_elements=size(t_points), &
                               solution=solution, t_points=t_points)
        end if

        select case (options%method)
        case ("exact")
           call step_exact(t=t_points(nt), x_points=x_points,&
                           nx=nx, nt=nt, dx=dx, dt=dt, v=v, &
                           solution=solution)
        case ("ftcs")
           call step_ftcs(nx=nx, nt=nt, dx=dx, dt=dt, v=v, solution=solution)
        case ("lax")
           call step_lax(nx=nx, nt=nt, dx=dx, dt=dt, v=v, solution=solution)
        case ("upwind")
           call step_upwind(nx=nx, nt=nt, dx=dx, dt=dt, v=v, solution=solution)
        case ("lax-wendroff")
           call step_lax_wendroff(nx=nx, nt=nt, dx=dx, dt=dt, v=v, &
                                  solution=solution)
        case default
           print "(a, a)", "ERROR: unknown method ", trim(options%method)
           call exit(41)
        end select
    end do
end subroutine


!
! Solve the advection equation
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
    real(dp) :: dx, tmin, tmax, dt, v
    integer :: nt, nt_allocated

    ! Assign shortcut variables from settings
    ! ----------

    tmin = options%t_start
    tmax = options%t_end
    v = options%velocity

    ! Initialize the arrays
    call set_grid(options=options, solution=solution, &
                  x_points=x_points, t_points=t_points, &
                  nt_allocated=nt_allocated)

    ! Set initial conditions
    ! -------

    t_points(1) = tmin

    call set_initial(type=options%initial_conditions, &
                     x_points=x_points, solution=solution)

    ! Calculate the steps
    dx = x_points(2) - x_points(1)
    dt = 0.5_dp * dx / v

    call iterate(options=options, tmax=tmax, dx=dx, dt=dt, v=v, &
                 nt=nt, nt_allocated=nt_allocated, solution=solution, &
                 x_points=x_points, t_points=t_points)

    ! Remove unused elements from t dimension of arrays
    call resize_arrays(new_size=nt, keep_elements=nt, &
                       solution=solution, t_points=t_points)

    call remove_ghost_cells(solution)
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

    call write_output(filename=options%output_path, &
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