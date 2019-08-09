module OdeSolverTest
use Types, only: dp
use Constants, only: pi
use OdeSolver, only: solve_ode
use AssertsTest, only: assert_true
implicit none
private
public ode_solver_test_all

contains


subroutine find_root_test(failures)
    integer, intent(inout) :: failures

    call solve_ode(t_start=0._dp, t_end=2._dp*pi, delta_t=0.1_dp)

    call assert_true(.true., __FILE__, __LINE__, failures)
end

subroutine ode_solver_test_all(failures)
    integer, intent(inout) :: failures

    call find_root_test(failures)
end

end module OdeSolverTest
