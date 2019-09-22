!
! Calculate flux from unit vector
!
module Flux
use Types, only: dp
use Settings, only: program_settings
implicit none
private
public :: interface_flux, flux_from_state_vector, &
          max_eigenvalue_from_state_vector

contains

subroutine max_eigenvalue_from_state_vector(state_vector, max_eigenvalue)
    real(dp), intent(in) :: state_vector(:)
    real(dp), intent(out) :: max_eigenvalue

    ! Flux for Burgers equation
    max_eigenvalue = state_vector(1)
end subroutine


subroutine flux_from_state_vector(state_vector, flux)
    real(dp), intent(in) :: state_vector(:)
    real(dp), intent(out) :: flux(size(state_vector))

    ! Flux for Burgers equation
    flux(1) = 0.5_dp * state_vector(1)**2
end subroutine


subroutine interface_flux(options, state_vector_left, state_vector_right, flux)
    type(program_settings), intent(in) :: options
    real(dp), intent(in) :: state_vector_left(:), state_vector_right(:)
    real(dp), intent(out) :: flux(size(state_vector_left))
    real(dp) :: shock_speed, ul, ur
    real(dp) :: flux_left(size(state_vector_left))
    real(dp) :: flux_right(size(state_vector_left))
    real(dp) :: eigenvalue_left, eigenvalue_right, max_eigenvalue

    ! Shortcuts
    ul = state_vector_left(1)
    ur = state_vector_right(1)

    call flux_from_state_vector(state_vector=state_vector_left, &
                                flux=flux_left)

    call flux_from_state_vector(state_vector=state_vector_right, &
                                flux=flux_right)

    select case (options%method)
        case ("godunov")
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
    case ("kurganov")
        ! Find maximum eigenvalue from left and right state vectors
        max_eigenvalue = 0
        call max_eigenvalue_from_state_vector(&
            state_vector=state_vector_left, &
            max_eigenvalue=eigenvalue_left)

        call max_eigenvalue_from_state_vector(&
            state_vector=state_vector_right, &
            max_eigenvalue=eigenvalue_right)

        max_eigenvalue = max(max_eigenvalue, abs(eigenvalue_left), &
                             abs(eigenvalue_right))

        flux = 0.5_dp * (flux_left + flux_right - max_eigenvalue * &
                (state_vector_right - state_vector_left))
    case default
       print "(a, a)", "ERROR: unknown method ", trim(options%method)
       call exit(41)
    end select
end subroutine


end module Flux