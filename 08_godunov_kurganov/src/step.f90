!
! Perform one step of integration
!
module Step
use Types, only: dp
use Settings, only: program_settings
use InitialConditions, only: calculate_initial
use InterfaceFlux, only: interface_flux
implicit none
private
public :: step_finite_volume

contains

!
! Calculate values of state vectors for one step of finate
! volume method for nt time index
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
! fluxes : fluxes for previous time step
!
! eigenvalues : eigenvalues for previous time step
!
!
! Outputs:
! -------
!
! state_vectors : array containing the solution for the equation
!
subroutine step_finite_volume(options, nx, nt, dx, dt, fluxes, &
                              eigenvalues, state_vectors)

    type(program_settings), intent(in) :: options
    integer, intent(in) :: nt, nx
    real(dp), intent(in) :: dx, dt
    real(dp), intent(in) :: fluxes(:, :), eigenvalues(:)
    real(dp), intent(inout) :: state_vectors(:, :, :)
    real(dp) :: a, flux_right_interface(size(state_vectors, 1))
    real(dp) :: flux_left_interface(size(state_vectors, 1))
    integer :: ix

    a = dt / dx

    do ix = 2, nx - 1
        ! Calculate flux through the left cell interface
        call interface_flux( &
            options=options, &
            state_vector_left=state_vectors(:, ix - 1, nt - 1), &
            state_vector_right=state_vectors(:, ix, nt - 1), &
            flux_left=fluxes(:, ix - 1), &
            flux_right=fluxes(:, ix), &
            eigenvalue_left=eigenvalues(ix - 1), &
            eigenvalue_right=eigenvalues(ix), &
            flux=flux_left_interface)

        ! Calculate flux through the right cell interface
        call interface_flux( &
            options=options, &
            state_vector_left=state_vectors(:, ix, nt - 1), &
            state_vector_right=state_vectors(:, ix + 1, nt - 1), &
            flux_left=fluxes(:, ix), &
            flux_right=fluxes(:, ix + 1), &
            eigenvalue_left=eigenvalues(ix), &
            eigenvalue_right=eigenvalues(ix + 1), &
            flux=flux_right_interface)

        state_vectors(:, ix, nt) = state_vectors(:, ix, nt - 1) &
            - a * (flux_right_interface(:) - flux_left_interface(:))
    end do
end subroutine


end module Step
