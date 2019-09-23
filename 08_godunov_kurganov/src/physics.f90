!
! Describe physics of the problem
!
module Physics
use Types, only: dp
implicit none
private
public :: many_state_vectors_to_primitive, &
          many_primitive_vectors_to_state_vectors, &
          calculate_fluxes, calculate_eigenvalues

contains

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

subroutine many_state_vectors_to_primitive(state_vectors, primitive_vectors)
    real(dp), intent(in) :: state_vectors(:, :, :)
    real(dp), allocatable, intent(out) :: primitive_vectors(:, :, :)
    integer :: nx, nt, stat, i, j

    nx = size(state_vectors, 2)
    nt = size(state_vectors, 3)

    allocate(primitive_vectors(size(state_vectors, 1), nx, nt), stat=stat)

    if (stat /= 0) then
        write (0, *) "Failed to allocate primitive vector array"
        call exit(41)
    end if

    FORALL(i = 1:nx, j = 1:nt)
        primitive_vectors(1, i, j) = state_vectors(1, i, j)
    END FORALL
end subroutine

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