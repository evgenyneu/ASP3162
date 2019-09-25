!
! Perform one step of integration
!
module Step
use Types, only: dp
use Settings, only: program_settings
use InitialConditions, only: calculate_initial
use InterfaceFlux, only: single_interface_flux
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
! dx : size of space step
!
! nt : the current time index in solutions array for which the solution needs
!      to be calcualted.
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
subroutine step_finite_volume(dx, nt, dt, interface_fluxes, state_vectors)
    integer, intent(in) :: nt
    real(dp), intent(in) :: dx, dt
    real(dp), intent(in) :: interface_fluxes(:, :)
    real(dp), intent(inout) :: state_vectors(:, :, :)
    real(dp) :: a
    integer :: i, nx

    a = dt / dx

    ! Number of x values
    nx = size(state_vectors, 2) - 2  ! subtract two ghost points

    forall(i = 2 : nx + 1)
        state_vectors(:, i, nt) = state_vectors(:, i, nt - 1) &
            - a * (interface_fluxes(:, i) - interface_fluxes(:, i-1))
    end forall
end subroutine

end module Step
