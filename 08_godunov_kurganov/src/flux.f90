!
! Calculate flux from unit vector
!
module Flux
use Types, only: dp
implicit none
private
public :: interface_flux

contains


subroutine flux_from_state_vector(state_vector, flux, max_eigenvalue)
    real(dp), intent(in) :: state_vector(:)
    real(dp), intent(out) :: flux(size(state_vector))
    real(dp), intent(out) :: max_eigenvalue


end subroutine


subroutine interface_flux(state_vector_left, state_vector_right, flux)
    real(dp), intent(in) :: state_vector_left(:), state_vector_right(:)
    real(dp), intent(out) :: flux(size(state_vector_left))
    real(dp) :: shock_speed, ul, ur, max_eigenvalue
    real(dp) :: flux_left(size(state_vector_left))
    real(dp) :: flux_right(size(state_vector_left))

    ! Shortcuts
    ul = state_vector_left(1)
    ur = state_vector_right(1)

    call flux_from_state_vector(state_vector=state_vector_left, &
                                flux=flux_left, max_eigenvalue=max_eigenvalue)

    call flux_from_state_vector(state_vector=state_vector_right, &
                                flux=flux_right, max_eigenvalue=max_eigenvalue)

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



end module Flux