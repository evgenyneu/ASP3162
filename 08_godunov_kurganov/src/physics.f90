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
    integer :: nx, ix

    nx = size(state_vectors, 2)

    do ix = 1, nx
        call single_primitive_vector_to_state_vector( &
            primitive = primitive_vectors(:, ix), &
            state_vector = state_vectors(:, ix))
    end do
end subroutine

subroutine single_primitive_vector_to_state_vector(primitive, state_vector)
    real(dp), intent(in) :: primitive(:)
    real(dp), intent(inout) :: state_vector(:)

    ! For Burger's equation the primitive variable is the same
    ! as state state_vector variable u, the velocity
    state_vector = primitive
end subroutine

subroutine many_state_vectors_to_primitive(state_vectors, primitive_vectors)
    real(dp), intent(in) :: state_vectors(:, :, :)
    real(dp), allocatable, intent(out) :: primitive_vectors(:, :, :)
    integer :: nx, nt, ix, it, stat

    nx = size(state_vectors, 2)
    nt = size(state_vectors, 3)

    allocate(primitive_vectors(size(state_vectors, 1), nx, nt), stat=stat)

    if (stat /= 0) then
        write (0, *) "Failed to allocate primitive vector array"
        call exit(41)
    end if

    do it = 1, nt
        do ix = 1, nx
            call single_state_vector_to_primitive( &
                state_vector = state_vectors(:, ix, it), &
                primitive = primitive_vectors(:, ix, it))
        end do
    end do
end subroutine

subroutine single_state_vector_to_primitive(state_vector, primitive)
    real(dp), intent(in) :: state_vector(:)
    real(dp), intent(inout) :: primitive(:)

    ! For Burger's equation the primitive variable is the same
    ! as state state_vector variable u, the velocity
    primitive = state_vector
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