module HeatEquationTest
use Types, only: dp
use AssertsTest, only: assert_true
use HeatEquation, only: solve_heat_equation
use Settings, only: program_settings
implicit none
private
public heat_equation_test_all

contains

subroutine solve_heat_eqn_test(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: options

    options%nx = 20
    options%nt = 100
    options%alpha = 0.25_dp
    options%k = 2.28e-5

    call solve_heat_equation(options)

    call assert_true(.true., __FILE__, __LINE__, failures)
end

subroutine heat_equation_test_all(failures)
    integer, intent(inout) :: failures

    call solve_heat_eqn_test(failures)
end

end module HeatEquationTest
