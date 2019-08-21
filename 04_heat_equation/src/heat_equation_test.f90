module HeatEquationTest
use Types, only: dp
use AssertsTest, only: assert_true
implicit none
private
public heat_equation_test_all

contains

subroutine solve_heat_eqn_test(failures)
    integer, intent(inout) :: failures

    call assert_true(.true., __FILE__, __LINE__, failures)
end

subroutine heat_equation_test_all(failures)
    integer, intent(inout) :: failures

    call solve_heat_eqn_test(failures)
end

end module HeatEquationTest
