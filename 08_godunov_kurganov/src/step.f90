!
! Perform one step of integration
!
module Step
use Types, only: dp
use Settings, only: program_settings
use InitialConditions, only: calculate_initial
use Flux, only: interface_flux
implicit none
private
public :: step_finite_volume

contains

!
! Calculate solution for one step of finate volume method for nt time index
!
! Inputs:
! -------
!
! options : program options
!
! nx : total number of x points in solution array.
!
! nt : the current time index in solutions array for which the solution needs
!      to be calcualted.
!
! dx : size of space step
!
! dt : size of time step
!
!
! Outputs:
! -------
!
! solution : array containing the solution for the equation
!
subroutine step_finite_volume(options, nx, nt, dx, dt, solution)
    type(program_settings), intent(in) :: options
    integer, intent(in) :: nt, nx
    real(dp), intent(in) :: dx, dt
    real(dp), intent(inout) :: solution(:, :, :)
    real(dp) :: a, flux_right_interface(size(solution, 1))
    real(dp) :: flux_left_interface(size(solution, 1))
    integer :: ix

    a = dt / dx

    do ix = 2, nx - 1
        ! Calculate flux through the left cell interface
        call interface_flux( &
            options=options, &
            state_vector_left=solution(:, ix - 1, nt - 1), &
            state_vector_right=solution(:, ix, nt - 1), &
            flux=flux_left_interface)

        ! Calculate flux through the right cell interface
        call interface_flux( &
            options=options, &
            state_vector_left=solution(:, ix, nt - 1), &
            state_vector_right=solution(:, ix + 1, nt - 1), &
            flux=flux_right_interface)

        solution(:, ix, nt) = solution(:, ix, nt - 1) &
            - a * (flux_right_interface(:) - flux_left_interface(:))
    end do
end subroutine


end module Step