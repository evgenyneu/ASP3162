!
! Calculate the flux through interface between two cells
!
module InterfaceFlux
use Types, only: dp
use Settings, only: program_settings
implicit none
private
public :: interface_flux

contains

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


subroutine interface_flux(options, &
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


end module InterfaceFlux