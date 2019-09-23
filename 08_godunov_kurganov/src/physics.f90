!
! Physics of the problem (calculation of fluxes, eigenvalues etc.)
!
module Physics
use Types, only: dp
implicit none
private
public :: many_state_vectors_to_primitive, &
          many_primitive_vectors_to_state_vectors, &
          calculate_fluxes, calculate_eigenvalues

contains


!
! Returns an array containing state variables from
! given an array of primitive variables
!
! Inputs:
! -------
!
! primitive_vectors : array containing primitive vectors
!
!
! Outputs:
! -------
!
! state_vectors : array containing state vectors
!
subroutine many_primitive_vectors_to_state_vectors(&
    primitive_vectors, state_vectors)

    real(dp), intent(in) :: primitive_vectors(:, :)
    real(dp), intent(out) :: state_vectors(:, :)
    integer :: i

    forall(i = 1: size(state_vectors, 2))
        ! For Burgers' equation primitive vector is also a state vector
        state_vectors(:, i) = primitive_vectors(:, i)
    end forall
end subroutine

!
! Returns an array containing state variables from
! given an array of primitive variables
!
! Inputs:
! -------
!
! state_vectors : array containing state vectors
!
!
! Outputs:
! -------
!
! primitive_vectors : array containing primitive vectors
!
subroutine many_state_vectors_to_primitive(state_vectors, primitive_vectors)
    real(dp), intent(in) :: state_vectors(:, :, :)
    real(dp), intent(inout) :: primitive_vectors(:, :, :)
    integer :: nx, nt, i, j

    nx = size(state_vectors, 2)
    nt = size(state_vectors, 3)

    forall(i = 1:nx, j = 1:nt)
        primitive_vectors(1, i, j) = state_vectors(1, i, j)
    end forall
end subroutine


!
! Calculates fluxes from state vectors
!
! Inputs:
! -------
!
! state_vectors : array containing state vectors
!
!
! Outputs:
! -------
!
! fluxes : array containing fluxes
!
subroutine calculate_fluxes(state_vectors, fluxes)
    real(dp), intent(in) :: state_vectors(:, :)
    real(dp), intent(inout) :: fluxes(:, :)
    integer :: i

    forall(i = 1: size(state_vectors, 2))
        ! Flux for Burgers equation
        fluxes(1, i) = 0.5_dp * state_vectors(1, i)**2
    end forall
end subroutine

subroutine calculate_eigenvalues(state_vectors, eigenvalues)
    real(dp), intent(in) :: state_vectors(:, :)
    real(dp), intent(out) :: eigenvalues(:)
    integer :: i

    forall(i = 1: size(state_vectors, 2))
        ! Eigenvalue for Burgers equation is velocity
        eigenvalues(i) = abs(state_vectors(1, i))
    end forall
end subroutine


end module Physics