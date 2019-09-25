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
public :: step_finite_volume, calculate_interface_fluxes

contains

!
! Calculate values of state vectors for one step of finate
! volume method for nt time index
!
! Inputs:
! -------
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
! eigenvalues : eigenvalues for previous time step
!
! interface_fluxes : fluxes through cell interfaces
!
! Outputs:
! -------
!
! state_vectors : array containing the solution for the equation
!
subroutine step_finite_volume(nx, nt, dx, dt, interface_fluxes, state_vectors)
    integer, intent(in) :: nt, nx
    real(dp), intent(in) :: dx, dt
    real(dp), intent(in) :: interface_fluxes(:, :)
    real(dp), intent(inout) :: state_vectors(:, :, :)
    real(dp) :: a
    integer :: i

    a = dt / dx

    forall(i = 2 : nx - 1)
        state_vectors(:, i, nt) = state_vectors(:, i, nt - 1) &
            - a * (interface_fluxes(:, i) - interface_fluxes(:, i-1))
    end forall
end subroutine


!
! Calculate fluxes through cell interfaces
!
! Inputs:
! -------
!
! options : program options
!
! nx : total number of x points in solution array.
!
! fluxes : fluxes for previous time step
!
! eigenvalues : eigenvalues for previous time step
!
! state_vectors : array containing the solution for the equation
!
! Outputs:
! -------
!
! interface_fluxes : fluxes through cell interfaces
!
subroutine calculate_interface_fluxes(options, nx, fluxes, &
                                      eigenvalues, state_vectors, &
                                      interface_fluxes)

    type(program_settings), intent(in) :: options
    integer, intent(in) :: nx
    real(dp), intent(in) :: fluxes(:, :), eigenvalues(:)
    real(dp), intent(in) :: state_vectors(:, :)
    real(dp), intent(out) :: interface_fluxes(:, :)
    integer :: ix

    do ix = 2, nx
        call interface_flux( &
            options=options, &
            state_vector_left=state_vectors(:, ix - 1), &
            state_vector_right=state_vectors(:, ix), &
            flux_left=fluxes(:, ix - 1), &
            flux_right=fluxes(:, ix), &
            eigenvalue_left=eigenvalues(ix - 1), &
            eigenvalue_right=eigenvalues(ix), &
            flux=interface_fluxes(:, ix-1))
    end do
end subroutine


end module Step
