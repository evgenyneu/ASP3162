module PhysicsTest
use Types, only: dp
use AssertsTest, only: assert_true, assert_equal, assert_approx
use Physics, only: single_primitive_vector_to_state_vector
implicit none
private
public physics_test_all

contains

subroutine file_exists_test_test(failures)
    integer, intent(inout) :: failures
    real(dp) :: primitive(1) = [2._dp]
    real(dp) :: state_vector(1)

    call single_primitive_vector_to_state_vector(primitive=primitive, &
            state_vector=state_vector)

    call assert_approx(state_vector(1), 2.0_dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)
end


subroutine physics_test_all(failures)
    integer, intent(inout) :: failures

    call file_exists_test_test(failures)
end

end module PhysicsTest
