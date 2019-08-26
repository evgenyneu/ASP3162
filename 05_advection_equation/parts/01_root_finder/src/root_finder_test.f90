module RootFinderTest
use Types, only: dp
use AssertsTest, only: assert_approx, assert_true
use RootFinder, only: do_it, find_root, my_function, my_function_derivative
use Settings, only: program_settings
implicit none
private
public root_finder_test_all

contains

! ! do_it
! ! ---------

! subroutine do_it_test(failures)
!     integer, intent(inout) :: failures

!     call do_it(silent=.true.)

!     call assert_true(.true., __FILE__, __LINE__, failures)
! end


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

    call assert_approx(result, 0.6438924_dp, 1e-5_dp, __FILE__, __LINE__, failures)
end


subroutine root_finder_test_all(failures)
    integer, intent(inout) :: failures

    call my_function_test(failures)
    call my_function_derivative_test(failures)
    call find_root_test(failures)
    ! call do_it_test(failures)
end

end module
