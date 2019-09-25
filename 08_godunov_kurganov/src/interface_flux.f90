!
! Calculate the flux through interface between two cells
!
module InterfaceFlux
use Types, only: dp
use Settings, only: program_settings
implicit none
private
public :: calculate_interface_fluxes, single_interface_flux, godunov_flux

contains

!
! Calculate flux through cell interface using Godunov's method
!
! Inputs:
! -------
!
! state_vector_left,
! state_vector_right : state vectors on both sides of the cell interface
!
! flux_left,
! flux_right : values of flux in the cells on both sides of cell interface
!
! Outputs:
! -------
!
! flux : flux through cell interface
!
subroutine godunov_flux(state_vector_left, state_vector_right, &
                        flux_left, flux_right, flux)
    real(dp), intent(in) :: state_vector_left(:), state_vector_right(:)
    real(dp), intent(in) :: flux_left(:), flux_right(:)
    real(dp), intent(out) :: flux(size(state_vector_left))
    real(dp) :: shock_speed, ul, ur

    ! Shortcuts
    ul = state_vector_left(1)
    ur = state_vector_right(1)

    if (ul > ur) then
        shock_speed = 0.5_dp * (ul + ur)

        if (shock_speed > 0) then
            flux = flux_left
        else
            flux = flux_right
        end if
    else
        if (ul > 0) then
            flux = flux_left
        else if (ur < 0) then
            flux = flux_right
        else
            flux = 0
        end if
    end if
end subroutine

!
! Calculate flux through a single cell interface
!
! Inputs:
! -------
!
! options : program options
!
! state_vector_left,
! state_vector_right : state vectors on both sides of the cell interface
!
! flux_left,
! flux_right : values of flux in the cells on both sides of cell interface
!
! eigenvalue_left,
! eigenvalue_right : eigenvalues for the cells on both sides of cell interface
!
! Outputs:
! -------
!
! flux : flux through cell interface
!
subroutine single_interface_flux(options, &
                          state_vector_left, state_vector_right, &
                          flux_left, flux_right, &
                          eigenvalue_left, eigenvalue_right, &
                          flux)

    type(program_settings), intent(in) :: options
    real(dp), intent(in) :: state_vector_left(:), state_vector_right(:)
    real(dp), intent(out) :: flux(size(state_vector_left))
    real(dp), intent(in) :: flux_left(:), flux_right(:)
    real(dp), intent(in) :: eigenvalue_left, eigenvalue_right
    real(dp) :: max_eigenvalue

    select case (options%method)
    case ("godunov")
        call godunov_flux(state_vector_left=state_vector_left, &
                          state_vector_right=state_vector_right, &
                          flux_left=flux_left, flux_right=flux_right, &
                          flux=flux)

    case ("kurganov")
        max_eigenvalue = max(eigenvalue_left, eigenvalue_right)

        flux = 0.5_dp * (flux_left + flux_right - max_eigenvalue * &
                (state_vector_right - state_vector_left))

    case default
       print "(a, a)", "ERROR: unknown method ", trim(options%method)
       call exit(41)
    end select
end subroutine


!
! Calculate fluxes through cell interfaces
!
! Inputs:
! -------
!
! options : program options
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
subroutine calculate_interface_fluxes(options, fluxes, &
                                      eigenvalues, state_vectors, &
                                      interface_fluxes)

    type(program_settings), intent(in) :: options
    real(dp), intent(in) :: fluxes(:, :), eigenvalues(:)
    real(dp), intent(in) :: state_vectors(:, :)
    real(dp), intent(out) :: interface_fluxes(:, :)
    integer :: nx
    integer :: ix

    ! Number of x values
    nx = size(state_vectors, 2) - 2  ! subtract two ghost points

    do ix = 1, nx + 1
        call single_interface_flux( &
            options=options, &
            state_vector_left=state_vectors(:, ix), &
            state_vector_right=state_vectors(:, ix + 1), &
            flux_left=fluxes(:, ix), &
            flux_right=fluxes(:, ix + 1), &
            eigenvalue_left=eigenvalues(ix), &
            eigenvalue_right=eigenvalues(ix + 1), &
            flux=interface_fluxes(:, ix))
    end do
end subroutine


end module InterfaceFlux
