module HeatEquationTest
use Types, only: dp
use AssertsTest, only: assert_true, assert_approx
use HeatEquation, only: solve_heat_equation
use Settings, only: program_settings
implicit none
private
public heat_equation_test_all

contains

subroutine solve_heat_eqn_test(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: options
    real(dp), allocatable :: data(:,:), errors(:,:)
    real(dp), allocatable :: x_points(:), t_points(:)

    options%nx = 20
    options%nt = 100
    options%alpha = 0.25_dp
    options%k = 2.28e-5

    call solve_heat_equation(options, data, errors, x_points, t_points)

    call assert_approx(x_points(1), 0.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(x_points(10), 0.4736842_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(x_points(20), 1.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)

    call assert_approx(t_points(1), 0.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(t_points(2), 27.412279_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(t_points(3), 54.82455_dp, 1e-5_dp, __FILE__, __LINE__, failures)

    call assert_approx(data(1, 1), 0.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(data(10, 1), 99.658449_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(data(20, 1), 0.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)

    call assert_approx(data(1, 100), 0.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(data(10, 100), 50.61869_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(data(20, 100), 0.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)

    call assert_approx(errors(1, 1), 0.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(errors(10, 1), 0.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(errors(20, 1), 0.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)

    call assert_approx(errors(1, 10), 0.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(errors(10, 10), 0.5703221_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(errors(10, 50), 2.393750_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(errors(20, 10), 0.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)
end

subroutine heat_equation_test_all(failures)
    integer, intent(inout) :: failures

    call solve_heat_eqn_test(failures)
end

end module HeatEquationTest
