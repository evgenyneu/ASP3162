!
! Describe physics of the problem
!
module Physics
use Types, only: dp
implicit none
private
public :: flux_from_state_vector, &
          max_eigenvalue_from_state_vector, &
          many_state_vectors_to_primitive, &
          many_primitive_vectors_to_state_vectors

contains

subroutine many_primitive_vectors_to_state_vectors(&
    primitive_vectors, state_vectors)

    real(dp), intent(in) :: primitive_vectors(:, :)
    real(dp), intent(out) :: state_vectors(:, :)
    integer :: nx, nt, ix, it

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