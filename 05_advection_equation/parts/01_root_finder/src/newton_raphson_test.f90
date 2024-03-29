module NewtonRaphsonTest
use Types, only: dp
use AssertsTest, only: assert_approx, assert_true
use RootFinder, only: my_function, my_function_derivative
use NewtonRaphson, only: approximate_root

implicit none
private
public newton_raphson_test_all

contains

subroutine find_root_test(failures)
    integer, intent(inout) :: failures
    real(dp) :: result
    logical :: success

    result = approximate_root(v_start=0.5_dp, &
                              func=my_function, &
                              derivative=my_function_derivative, &
                              x = 0.0_dp, &
                              t = 0.0_dp, &
                              tolerance=1e-5_dp, &
                              max_iterations = 20, &
                              success=success)

    call assert_true(success, __FILE__, __LINE__, failures)
    call assert_approx(result, 1.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)


    ! Test different value of x and t
    ! ---------------

    result = approximate_root(v_start=0.5_dp, &
                              func=my_function, &
                              derivative=my_function_derivative, &
                              x = 1.0_dp, &
                              t = 0.0_dp, &
                              tolerance=1e-5_dp, &
                              max_iterations = 20, &
                              success=success)

    call assert_true(success, __FILE__, __LINE__, failures)
    call assert_approx(result, 0.540302_dp, 1e-5_dp, __FILE__, &
                       __LINE__, failures)


    ! Test different value of x and t
    ! ---------------

    result = approximate_root(v_start=0.5_dp, &
                              func=my_function, &
                              derivative=my_function_derivative, &
                              x = 1.0_dp, &
                              t = 0.4_dp, &
                              tolerance=1e-5_dp, &
                              max_iterations = 20, &
                              success=success)

    call assert_true(success, __FILE__, __LINE__, failures)
    call assert_approx(result, 0.7699615_dp, 1e-5_dp, __FILE__, &
                       __LINE__, failures)
end

subroutine find_root_test_did_not_converge(failures)
    integer, intent(inout) :: failures
    real(dp) :: result
    logical :: success

    result = approximate_root(v_start=0.5_dp, &
                              func=my_function, &
                              derivative=my_function_derivative, &
                              x = 0.2_dp, &
                              t = 1._dp, &
                              tolerance=1e-5_dp, &
                              max_iterations = 2, &
                              success=success)

    call assert_true(.not. success, __FILE__, __LINE__, failures)
end

subroutine newton_raphson_test_all(failures)
    integer, intent(inout) :: failures

    call find_root_test(failures)
    call find_root_test_did_not_converge(failures)
end

end module NewtonRaphsonTest
