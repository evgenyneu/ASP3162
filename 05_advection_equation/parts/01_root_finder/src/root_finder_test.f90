module RootFinderTest
use Types, only: dp
use AssertsTest, only: assert_approx, assert_true
use Constants, only: pi

use RootFinder, only: find_roots_and_print_output, &
                      find_root, my_function, my_function_derivative, &
                      find_many_roots

use Settings, only: program_settings
implicit none
private
public root_finder_test_all

contains

! find_roots_and_print_output
! ---------

subroutine find_roots_and_print_output_test(failures)
    integer, intent(inout) :: failures

    call find_roots_and_print_output(silent=.true.)

    call assert_true(.true., __FILE__, __LINE__, failures)
end


! my_function
! -----------

subroutine my_function_test(failures)
    integer, intent(inout) :: failures
    real(dp) :: result

    result = my_function(v=0.5_dp, x=0._dp, t=0._dp)
    call assert_approx(result, 0.5_dp, 1e-5_dp, __FILE__, __LINE__, failures)

    result = my_function(v=0.5_dp, x=-0.2_dp, t=0.2_dp)
    call assert_approx(result, 0.4553364_dp, 1e-5_dp, __FILE__, &
                       __LINE__, failures)
end


! my_function_derivative
! -----------

subroutine my_function_derivative_test(failures)
    integer, intent(inout) :: failures
    real(dp) :: result

    result = my_function_derivative(v=0.5_dp, x=0._dp, t=0._dp)
    call assert_approx(result, -1._dp, 1e-5_dp, __FILE__, __LINE__, failures)

    result = my_function_derivative(v=0.2_dp, x=0.1_dp, t=0.2_dp)
    call assert_approx(result, -0.988007_dp, 1e-5_dp, __FILE__, &
                       __LINE__, failures)
end


! find_root
! -----------

subroutine find_root_test(failures)
    integer, intent(inout) :: failures
    real(dp) :: result
    logical :: success
    type(program_settings) :: options

    options%root_finder_v_start = 0.5_dp
    options%root_finder_tolerance = 1e-5_dp
    options%root_finder_max_iterations = 20

    result = find_root(options=options, x=1._dp, t=0.2_dp, success=success)

    call assert_true(success, __FILE__, __LINE__, failures)
    call assert_approx(result, 0.6438924_dp, 1e-5_dp, __FILE__, __LINE__, failures)
end


! find_many_roots_test
! -----------

subroutine find_many_roots_test(failures)
    integer, intent(inout) :: failures
    real(dp) :: result
    logical :: success
    type(program_settings) :: options
    real(dp), allocatable :: solution(:,:)
    real(dp), allocatable :: x_points(:), t_points(:)
    real(dp) :: error_x, error_t

    options%x_start = -1.57_dp
    options%x_end = 1.57_dp
    options%nx = 100
    options%t_start = 0._dp
    options%t_end = 1.4_dp
    options%nt = 8

    options%root_finder_v_start = 0.5_dp
    options%root_finder_tolerance = 1e-5_dp
    options%root_finder_max_iterations = 300

    call find_many_roots(options=options, solution=solution, &
                         x_points=x_points, t_points=t_points, &
                         success=success, error_x=error_x, error_t=error_t)

    call assert_true(success, __FILE__, __LINE__, failures)

    ! Verify x_points
    ! --------------

    call assert_approx(x_points(1), -1.57_dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)

    call assert_approx(x_points(2), -1.5382828_dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)

    call assert_approx(x_points(99), 1.5382828_dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)

    call assert_approx(x_points(100), 1.57_dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)

    ! Verify t_points
    ! --------------

    call assert_approx(t_points(1), 0._dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)

    call assert_approx(t_points(2), 0.2_dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)

    call assert_approx(t_points(7), 1.2_dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)

    call assert_approx(t_points(8), 1.4_dp, 1e-5_dp, &
                       __FILE__, __LINE__, failures)
end


subroutine root_finder_test_all(failures)
    integer, intent(inout) :: failures

    call my_function_test(failures)
    call my_function_derivative_test(failures)
    call find_root_test(failures)
    call find_many_roots_test(failures)
    call find_roots_and_print_output_test(failures)
end

end module
