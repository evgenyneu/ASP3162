module OdeSolverTest
use Types, only: dp
use Constants, only: pi
use OdeSolver, only: solve_ode, ode_solution
use AssertsTest, only: assert_true, assert_equal, assert_approx
implicit none
private
public ode_solver_test_all

contains


subroutine find_root_test(failures)
    integer, intent(inout) :: failures
    type(ode_solution) :: solution
    logical :: success
    character(len=1024) :: error_message

    call solve_ode(t_start=0._dp, t_end=2._dp*pi, delta_t=0.1_dp, &
                   solution=solution, success=success, &
                   error_message=error_message)

    call assert_true(success, __FILE__, __LINE__, failures)
    call assert_equal(solution%size, 63, __FILE__, __LINE__, failures)

    call assert_approx(solution%t_values(1), 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(solution%t_values(2), 0.1_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(solution%t_values(3), 0.2_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(solution%t_values(62), 6.1_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(solution%t_values(63), 6.2_dp, 1e-5_dp, __FILE__, __LINE__, failures)

    call assert_approx(solution%x_values(1), 1._dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(solution%x_values(2), 0.995_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(solution%x_values(3), 0.98005_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(solution%x_values(62), 0.983728_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(solution%x_values(63), 0.996753_dp, 1e-5_dp, __FILE__, __LINE__, failures)
end

subroutine ode_solver_test_all(failures)
    integer, intent(inout) :: failures

    call find_root_test(failures)
end

end module OdeSolverTest
