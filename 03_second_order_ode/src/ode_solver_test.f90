module OdeSolverTest
use Types, only: dp
use Constants, only: pi
use Settings, only: program_settings

use OdeSolver, only: solve_ode, ode_solution, print_solution, solve_and_print, &
                        read_settings_solve_and_print

use AssertsTest, only: assert_true, assert_equal, assert_approx, &
                        assert_string_starts_with
implicit none
private
public ode_solver_test_all

contains


subroutine solve_ode_test(failures)
    integer, intent(inout) :: failures
    type(ode_solution) :: solution
    type(program_settings) :: options
    logical :: success
    character(len=1024) :: error_message

    options%t_end = 2 * pi
    options%delta_t = 0.1_dp

    call solve_ode(options=options, &
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
    call assert_approx(solution%x_values(4), 0.9552995_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(solution%x_values(62), 0.983728_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(solution%x_values(63), 0.996753_dp, 1e-5_dp, __FILE__, __LINE__, failures)

    call assert_approx(solution%x_values_exact(1), 1._dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(solution%x_values_exact(2), 0.995_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(solution%x_values_exact(3), 0.98006_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(solution%x_values_exact(4), 0.95533_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(solution%x_values_exact(62), 0.983268_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(solution%x_values_exact(63), 0.9965420_dp, 1e-5_dp, __FILE__, __LINE__, failures)
end

subroutine print_solution_test(failures)
    integer, intent(inout) :: failures
    type(ode_solution) :: solution
    logical :: success
    character(len=1024) :: error_message
    character(len=:), allocatable :: output
    type(program_settings) :: options

    options%t_end = 2 * pi
    options%delta_t = 0.1_dp

    call solve_ode(options=options, &
                   solution=solution, success=success, &
                   error_message=error_message)

    call print_solution(solution=solution, output=output, print_last=.false.)

    call assert_string_starts_with(output, "t,x,exact,abs_error", &
        __FILE__, __LINE__, failures)

    call assert_equal(len(trim(output)), 6320, __FILE__, __LINE__, failures)
    call assert_true(index(output, "1.20000000") > 0, __FILE__, __LINE__, failures)
    call assert_true(index(output, "6.2000000") > 0, __FILE__, __LINE__, failures)
end

subroutine print_solution_test__print_last(failures)
    integer, intent(inout) :: failures
    type(ode_solution) :: solution
    logical :: success
    character(len=1024) :: error_message
    character(len=:), allocatable :: output
    type(program_settings) :: options

    options%t_end = 2 * pi
    options%delta_t = 0.1_dp

    call solve_ode(options=options, &
                   solution=solution, success=success, &
                   error_message=error_message)

    call print_solution(solution=solution, output=output, print_last=.true.)

    call assert_string_starts_with(output, "t,x,exact,abs_error", &
        __FILE__, __LINE__, failures)

    call assert_equal(len(trim(output)), 120, __FILE__, __LINE__, failures)
    call assert_true(index(output, "6.2000000") > 0, __FILE__, __LINE__, failures)
end

subroutine solve_and_print_test(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: options

    options%t_end = 2 * pi
    options%delta_t = 0.1_dp

    call solve_and_print(options=options, silent=.true.)

    call assert_true(.true., __FILE__, __LINE__, failures)
end

subroutine read_settings_solve_and_print_test(failures)
    integer, intent(inout) :: failures

    call read_settings_solve_and_print(silent=.true.)

    call assert_true(.true., __FILE__, __LINE__, failures)
end

subroutine ode_solver_test_all(failures)
    integer, intent(inout) :: failures

    call solve_ode_test(failures)
    call print_solution_test(failures)
    call solve_and_print_test(failures)
    call print_solution_test__print_last(failures)
    call read_settings_solve_and_print_test(failures)
end

end module OdeSolverTest
