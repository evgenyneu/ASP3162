!
! Solves a PDE
!
module Equation
use Types, only: dp
use Constants, only: pi
use Settings, only: program_settings, read_from_command_line
use FloatUtils, only: linspace
use Output, only: write_output
use Grid, only: set_grid
use InitialConditions, only: set_initial
use Physics, only: max_eigenvalue_from_state_vector, &
                   many_state_vectors_to_primitive, &
                   calculate_fluxes

use Step, only: step_finite_volume

implicit none
private
public :: solve_equation, solve_and_create_output, &
          read_settings_solve_and_create_output, remove_ghost_cells, &
          resize_arrays

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
! solution : array containing the solution for the equation
!
! t_points : A 1D array containing the values of the time coordinate
!
subroutine resize_arrays(new_size, keep_elements, solution, t_points)
    integer, intent(in) :: new_size, keep_elements
    real(dp), allocatable, intent(inout) :: solution(:, :, :)
    real(dp), allocatable :: solution_buffer(:, :, :)
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

    allocate(solution_buffer(size(solution, 1), size(solution, 2), new_size))
    solution_buffer = 0
    solution_buffer(:, :, 1:keep_elements) = solution
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
! solution : 2D array containing the solution for the PDE's
!        first coordinate is x, second is time.
!
subroutine remove_ghost_cells(solution)
    real(dp), allocatable, intent(inout) :: solution(:, :, :)
    real(dp), allocatable :: solution_buffer(:, :, :)

    allocate(solution_buffer(size(solution, 1), &
                             size(solution, 2) - 2, &
                             size(solution, 3)))

    solution_buffer = 0
    solution_buffer(:, :, : ) = solution(:, 2 : size(solution, 2) - 1, :)
    deallocate(solution)
    call move_alloc(solution_buffer, solution)
end subroutine


subroutine max_eigenvalue_from_state_vectors(state_vectors, max_eigenvalue)
    real(dp), intent(in) :: state_vectors(:, :)
    real(dp), intent(out) :: max_eigenvalue
    real(dp) :: max_eigenvalue_cell
    integer :: ix
    max_eigenvalue = 0

    do ix = 1, size(state_vectors, 2)
        call max_eigenvalue_from_state_vector( &
            state_vector=state_vectors(:,ix), &
            max_eigenvalue=max_eigenvalue_cell)

        max_eigenvalue = max(max_eigenvalue, abs(max_eigenvalue_cell))
    end do
end subroutine

subroutine get_time_step(state_vectors, dx, courant_factor, dt)
    real(dp), intent(in) :: state_vectors(:, :), dx, courant_factor
    real(dp), intent(out) :: dt
    real(dp) :: max_eigenvalue

    call max_eigenvalue_from_state_vectors( &
        state_vectors=state_vectors, &
        max_eigenvalue=max_eigenvalue)

    dt = courant_factor * dx / max_eigenvalue
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
!
! Outputs:
! -------
!
! nt : the number of t points for which solution has been calculated.
!
! nt_allocated : the number of t points allocated in the arrays.
!
! solution : array containing the solution for the equation
!
! t_points : A 1D array containing the values of the time coordinate
!
! fluxes : array of flux vectors
!
! eigenvalues : array of eigenvalues
!
subroutine iterate(options, tmax, dx, &
                   nt, nt_allocated, solution, t_points, &
                   fluxes, eigenvalues)

    type(program_settings), intent(in) :: options
    integer, intent(inout) :: nt_allocated
    integer, intent(out) :: nt
    real(dp), intent(in) :: tmax, dx
    real(dp), intent(inout) :: fluxes(:, :), eigenvalues(:)
    real(dp), allocatable, intent(inout) :: solution(:, :, :)
    real(dp), allocatable, intent(inout) :: t_points(:)
    real(dp) :: dt
    integer :: nx

    nx = size(solution, 2) ! number of x points plus two ghost points
    nt = 1

    ! Calculate numerical solution
    do while (t_points(nt) < tmax)
        ! Update the ghost cells.
        ! The leftmost cell gets the values of nx-1 x cell
        ! and the rightmost cell gets the value of the second x cell.
        solution(:, 1, nt) = solution(:, nx - 1, nt)
        solution(:, nx, nt) = solution(:, 2, nt)

        call calculate_fluxes(state_vectors=solution(:, :, nt), fluxes=fluxes)

        ! Update the time step
        call get_time_step(state_vectors=solution(:, :, nt), dx=dx, &
                      courant_factor=options%courant_factor, dt=dt)

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

       call step_finite_volume(options=options, nx=nx, nt=nt, dx=dx, dt=dt, &
                               solution=solution)
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
! primitive_vectors : array containing the solution for
!        the equation first coordinate is x, second is time.
!
! x_points : A 1D array containing the values of the x coordinate
!
! t_points : A 1D array containing the values of the time coordinate
!
subroutine solve_equation(options, primitive_vectors, x_points, t_points)
    type(program_settings), intent(in) :: options
    real(dp), allocatable, intent(out) :: primitive_vectors(:, :, :)
    real(dp), allocatable, intent(out) :: x_points(:), t_points(:)
    real(dp), allocatable :: solution(:, :, :)
    real(dp), allocatable :: fluxes(:, :), eigenvalues(:)
    real(dp) :: dx, tmin, tmax, courant
    integer :: nt, nt_allocated

    ! Assign shortcut variables from settings
    ! ----------

    tmin = options%t_start
    tmax = options%t_end
    courant = options%courant_factor

    ! Initialize the arrays
    call set_grid(options=options, solution=solution, &
                  x_points=x_points, t_points=t_points, &
                  fluxes=fluxes, eigenvalues=eigenvalues, &
                  nt_allocated=nt_allocated)

    ! Set initial conditions
    ! -------

    t_points(1) = tmin

    call set_initial(type=options%initial_conditions, &
                     x_points=x_points, solution=solution)

    ! Calculate the steps
    dx = x_points(2) - x_points(1)

    call iterate(options=options, tmax=tmax, dx=dx, &
                 nt=nt, nt_allocated=nt_allocated, solution=solution, &
                 t_points=t_points, fluxes=fluxes, eigenvalues=eigenvalues)

    ! Remove unused elements from t dimension of arrays
    call resize_arrays(new_size=nt, keep_elements=nt, &
                       solution=solution, t_points=t_points)

    call remove_ghost_cells(solution)

    call many_state_vectors_to_primitive( &
        state_vectors=solution, &
        primitive_vectors=primitive_vectors)
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
    real(dp), allocatable :: solution(:, :, :)
    real(dp), allocatable :: x_points(:), t_points(:)

    call solve_equation(options, solution, x_points, t_points)

    call write_output(filename=options%output_path, &
                      solution=solution, &
                      x_points=x_points, t_points=t_points)
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


end module Equation