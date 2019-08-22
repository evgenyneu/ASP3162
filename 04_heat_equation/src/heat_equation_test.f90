module HeatEquationTest
use Types, only: dp
use AssertsTest, only: assert_true, assert_approx, assert_equal
use HeatEquation, only: solve_heat_equation, print_data
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

subroutine print_data_test(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: options
    real(dp) :: data(3,3)
    real(dp) :: x_points(3), t_points(3), read_data(16)
    character(len=:), allocatable :: output

    data = reshape((/ 1, 2, 3, 4, 5, 6, 7, 8, 9 /), shape(data))
    x_points = [1.1_dp, 1.2_dp, 1.3_dp]
    t_points = [0.1_dp, 0.2_dp, 0.3_dp]

    call print_data(data, x_points, t_points, output)

    read(output, *) read_data

    call assert_approx(read_data(1), 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(read_data(2), 1.1_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(read_data(3), 1.2_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(read_data(4), 1.3_dp, 1e-5_dp, __FILE__, __LINE__, failures)

    call assert_approx(read_data(5), 0.1_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(read_data(6), 1._dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(read_data(7), 2._dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(read_data(8), 3._dp, 1e-5_dp, __FILE__, __LINE__, failures)

    call assert_approx(read_data(9), 0.2_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(read_data(10), 4._dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(read_data(11), 5._dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(read_data(12), 6._dp, 1e-5_dp, __FILE__, __LINE__, failures)

    call assert_approx(read_data(13), 0.3_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(read_data(14), 7._dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(read_data(15), 8._dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(read_data(16), 9._dp, 1e-5_dp, __FILE__, __LINE__, failures)
end

subroutine heat_equation_test_all(failures)
    integer, intent(inout) :: failures

    call solve_heat_eqn_test(failures)

    call print_data_test(failures)
end

end module HeatEquationTest
