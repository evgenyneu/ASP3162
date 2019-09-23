!
! Desribe physics of the problem
!
module Physics
use Types, only: dp
implicit none
private
public :: flux_from_state_vector, &
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

end module Physics