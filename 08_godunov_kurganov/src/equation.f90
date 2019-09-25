!
! Solves a PDE
!
module Equation
use Types, only: dp
use Constants, only: pi
use Settings, only: program_settings, read_from_command_line
use FloatUtils, only: linspace
use Output, only: write_output
use Grid, only: set_grid, allocate_primitive_array
use InitialConditions, only: set_initial
use Physics, only: many_state_vectors_to_primitive, &
                   calculate_fluxes, calculate_eigenvalues

use Step, only: step_finite_volume
use InterfaceFlux, only : calculate_interface_fluxes

implicit none
private
public :: solve_equation, solve_and_create_output, &
          read_settings_solve_and_create_output, remove_ghost_cells, &
          resize_arrays

contains


!
! Change the size of the time dimension in state_vectors and t_points arrays
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
! state_vectors : array containing the solution for the equation
!
! t_points : A 1D array containing the values of the time coordinate
!
subroutine resize_arrays(new_size, keep_elements, state_vectors, t_points)
    integer, intent(in) :: new_size, keep_elements
    real(dp), allocatable, intent(inout) :: state_vectors(:, :, :)
    real(dp), allocatable :: state_vectors_buffer(:, :, :)
    real(dp), allocatable, intent(inout) :: t_points(:)
    real(dp), allocatable :: t_points_buffer(:)

    ! Enlarge t_points array
    ! -------

    allocate(t_points_buffer(new_size))
    t_points_buffer = 0
    t_points_buffer(1:keep_elements) = t_points
    deallocate(t_points)
    call move_alloc(t_points_buffer, t_points)

    ! Enlarge t axis of the state_vectors array
    ! -------

    allocate(state_vectors_buffer(size(state_vectors, 1), &
             size(state_vectors, 2), new_size))

    state_vectors_buffer = 0
    state_vectors_buffer(:, :, 1:keep_elements) = state_vectors
    deallocate(state_vectors)
    call move_alloc(state_vectors_buffer, state_vectors)
end subroutine


!
! Removes the ghost cells, which are the values corresponding to
! the first and last x-values. The ghost cells are temporary cells
! and are not needed after the state vectors has been calculated.
!
! Outputs:
! -------
!
! state_vectors : array containing the solution
!
subroutine remove_ghost_cells(state_vectors)
    real(dp), allocatable, intent(inout) :: state_vectors(:, :, :)
    real(dp), allocatable :: state_vectors_buffer(:, :, :)

    allocate(state_vectors_buffer(size(state_vectors, 1), &
                                  size(state_vectors, 2) - 2, &
                                  size(state_vectors, 3)))

    state_vectors_buffer = 0
    state_vectors_buffer(:, :, : ) = state_vectors(&
                                    :, 2 : size(state_vectors, 2) - 1, :)

    deallocate(state_vectors)
    call move_alloc(state_vectors_buffer, state_vectors)
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
! nt : the number of t points for which state vectors has been calculated.
!
! nt_allocated : the number of t points allocated in the arrays.
!
! state_vectors : array containing the solution
!
! t_points : A 1D array containing the values of the time coordinate
!
! fluxes : array of flux vectors
!
! eigenvalues : array of eigenvalues
!
subroutine iterate(options, tmax, dx, &
                   nt, nt_allocated, state_vectors, t_points, &
                   fluxes, eigenvalues)

    type(program_settings), intent(in) :: options
    integer, intent(inout) :: nt_allocated
    integer, intent(out) :: nt
    real(dp), intent(in) :: tmax, dx
    real(dp), intent(inout) :: fluxes(:, :), eigenvalues(:)
    real(dp), allocatable, intent(inout) :: state_vectors(:, :, :)
    real(dp), allocatable, intent(inout) :: t_points(:)

    real(dp) :: interface_fluxes(size(state_vectors,1), &
                                size(state_vectors,2) - 1)

    real(dp) :: dt
    integer :: nx

    nx = size(state_vectors, 2) ! number of x points plus two ghost points
    nt = 1

    ! Calculate state vectors for all time steps
    do while (t_points(nt) < tmax)
        ! Update the ghost cells.
        state_vectors(:, 1, nt) = state_vectors(:, nx - 1, nt)
        state_vectors(:, nx, nt) = state_vectors(:, 2, nt)

        ! Calculate fluxes and eigenvalues for all the cells at current
        ! time index. The flux/eigenvalues will be used to calculate
        ! the state vectors for the next time index
        call calculate_fluxes(state_vectors=state_vectors(:, :, nt), &
                              fluxes=fluxes)

        call calculate_eigenvalues(state_vectors=state_vectors(:, :, nt), &
                                   eigenvalues=eigenvalues)

        ! Increment the time value
        nt = nt + 1
        dt = options%courant_factor * dx / maxval(eigenvalues)
        t_points(nt) = t_points(nt - 1) + dt

        ! Resize the time dimension of the arrays if needed
        if (nt > nt_allocated / 2) then
            nt_allocated = 2 * nt_allocated

            call resize_arrays(new_size=nt_allocated, &
                               keep_elements=size(t_points), &
                               state_vectors=state_vectors, t_points=t_points)
        end if

        call calculate_interface_fluxes(options=options, nx=nx, &
                    fluxes=fluxes, &
                    eigenvalues=eigenvalues, &
                    state_vectors=state_vectors(:,:,nt-1), &
                    interface_fluxes=interface_fluxes)

        call step_finite_volume(nx=nx, nt=nt, dx=dx, dt=dt, &
                               state_vectors=state_vectors, &
                               interface_fluxes=interface_fluxes)
    end do
end subroutine


!
! Solve the equation
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
! primitive_vectors : array containing the solution.
!           These are vectors of primitive variables for all
!           position and time values.
!
! x_points : A 1D array containing the values of the x coordinate
!
! t_points : A 1D array containing the values of the time coordinate
!
subroutine solve_equation(options, primitive_vectors, x_points, t_points)
    type(program_settings), intent(in) :: options
    real(dp), allocatable, intent(out) :: primitive_vectors(:, :, :)
    real(dp), allocatable, intent(out) :: x_points(:), t_points(:)
    real(dp), allocatable :: state_vectors(:, :, :)
    real(dp), allocatable :: fluxes(:, :), eigenvalues(:)
    real(dp) :: dx, tmin, tmax, courant
    integer :: nt, nt_allocated

    ! Assign shortcut variables from settings
    ! ----------

    tmin = options%t_start
    tmax = options%t_end
    courant = options%courant_factor

    ! Initialize the arrays
    call set_grid(options=options, state_vectors=state_vectors, &
                  x_points=x_points, t_points=t_points, &
                  fluxes=fluxes, eigenvalues=eigenvalues, &
                  nt_allocated=nt_allocated)

    ! Set initial conditions
    ! -------

    t_points(1) = tmin

    call set_initial(type=options%initial_conditions, &
                     x_points=x_points, state_vectors=state_vectors)

    ! Calculate the steps
    dx = x_points(2) - x_points(1)

    ! Calculate state vectors for all time steps
    call iterate(options=options, tmax=tmax, dx=dx, &
                 nt=nt, nt_allocated=nt_allocated, &
                 state_vectors=state_vectors, &
                 t_points=t_points, fluxes=fluxes, eigenvalues=eigenvalues)

    ! Remove unused elements from t dimension of arrays
    call resize_arrays(new_size=nt, keep_elements=nt, &
                       state_vectors=state_vectors, t_points=t_points)

    call remove_ghost_cells(state_vectors)

    call allocate_primitive_array(array_shape=shape(state_vectors), &
        primitive_vectors=primitive_vectors)

    call many_state_vectors_to_primitive( &
        state_vectors=state_vectors, &
        primitive_vectors=primitive_vectors)
end subroutine


!
! Solves PDE and prints solution containing primitive variables to a file
!
! Inputs:
! -------
!
! options : program options
!
subroutine solve_and_create_output(options)
    type(program_settings), intent(in) :: options
    real(dp), allocatable :: primitive_vectors(:, :, :)
    real(dp), allocatable :: x_points(:), t_points(:)

    call solve_equation(options, primitive_vectors, x_points, t_points)

    call write_output(filename=options%output_path, &
                      primitive_vectors=primitive_vectors, &
                      x_points=x_points, t_points=t_points)
end subroutine


!
! Reads program settings from command line arguments,
! solves PDE and prints solution containing primitive variables to a file
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
