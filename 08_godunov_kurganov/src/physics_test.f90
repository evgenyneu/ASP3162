module PhysicsTest
use Types, only: dp
use AssertsTest, only: assert_true, assert_equal, assert_approx

use Physics, only: many_primitive_vectors_to_state_vectors
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

subroutine physics_test_all(failures)
    integer, intent(inout) :: failures

    call many_primitive_vectors_to_state_vectors_test(failures)
end

end module PhysicsTest
