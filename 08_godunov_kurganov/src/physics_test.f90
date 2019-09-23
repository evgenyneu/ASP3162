module PhysicsTest
use Types, only: dp
use AssertsTest, only: assert_true, assert_equal, assert_approx

use Physics, only: many_primitive_vectors_to_state_vectors, &
                   many_state_vectors_to_primitive, &
                   calculate_fluxes, calculate_eigenvalues

implicit none
private
public physics_test_all

contains

subroutine many_primitive_vectors_to_state_vectors_test(failures)
    integer, intent(inout) :: failures
    real(dp) :: primitive_vectors(1, 3)
    real(dp) :: state_vectors(1, 3)

    primitive_vectors(1, :) = [1, 2, 3]

    call many_primitive_vectors_to_state_vectors(&
        primitive_vectors=primitive_vectors, &
        state_vectors=state_vectors)

    call assert_approx(state_vectors(1, 1), 1.0_dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)

    call assert_approx(state_vectors(1, 2), 2.0_dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)

    call assert_approx(state_vectors(1, 3), 3.0_dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)
end

subroutine many_state_vectors_to_primitive_test(failures)
    integer, intent(inout) :: failures
    real(dp) :: state_vectors(1, 3, 2)
    real(dp) :: primitive_vectors(1, 3, 2)

    state_vectors = reshape([1, 2, 3, 4, 5, 6], shape(state_vectors))

    call many_state_vectors_to_primitive(&
        state_vectors=state_vectors, &
        primitive_vectors=primitive_vectors)

    call assert_approx(primitive_vectors(1, 1, 1), 1.0_dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)

    call assert_approx(primitive_vectors(1, 2, 1), 2.0_dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)

    call assert_approx(primitive_vectors(1, 3, 1), 3.0_dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)

    call assert_approx(primitive_vectors(1, 1, 2), 4.0_dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)

    call assert_approx(primitive_vectors(1, 2, 2), 5.0_dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)

    call assert_approx(primitive_vectors(1, 3, 2), 6.0_dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)
end

subroutine calculate_fluxes_test(failures)
    integer, intent(inout) :: failures
    real(dp) :: state_vectors(1, 3)
    real(dp) :: fluxes(1, 3)

    state_vectors(1, :) = [1, 2, 3]

    call calculate_fluxes(state_vectors, fluxes)

    call assert_approx(fluxes(1, 1), 0.5_dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)

    call assert_approx(fluxes(1, 2), 2._dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)

    call assert_approx(fluxes(1, 3), 4.5_dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)
end

subroutine calculate_eigenvalues_test(failures)
    integer, intent(inout) :: failures
    real(dp) :: state_vectors(1, 3)
    real(dp) :: eigenvalues(3)

    state_vectors(1, :) = [1, 2, 3]

    call calculate_eigenvalues(state_vectors, eigenvalues)

    call assert_approx(eigenvalues(1), 1._dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)

    call assert_approx(eigenvalues(2), 2._dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)

    call assert_approx(eigenvalues(3), 3._dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)
end


subroutine physics_test_all(failures)
    integer, intent(inout) :: failures

    call many_primitive_vectors_to_state_vectors_test(failures)
    call many_state_vectors_to_primitive_test(failures)
    call calculate_fluxes_test(failures)
    call calculate_eigenvalues_test(failures)
end

end module PhysicsTest
