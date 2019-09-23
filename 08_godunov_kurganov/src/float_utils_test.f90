module FloatUtilsTest
use Types, only: dp
use FloatUtils, only: can_convert_real_to_int, linspace
use AssertsTest, only: assert_true, assert_equal, assert_approx
implicit none
private
public float_utils_test_all

contains

subroutine can_convert_real_to_int_test(failures)
    integer, intent(inout) :: failures
    logical :: success
    character(len=1024) :: error_message

    call can_convert_real_to_int(float=32.23_dp, success=success, &
        error_message=error_message)

    call assert_true(success, __FILE__, __LINE__, failures)

    ! Overflow
    call can_convert_real_to_int(float=1e23_dp, success=success, &
        error_message=error_message)

    call assert_true(.not. success, __FILE__, __LINE__, failures)

    call assert_equal(error_message, &
            "Can not convert   9.999999999999999E+22 to integer", &
            __FILE__, __LINE__, failures)
end

! linspace
! -----------

subroutine linspace_test(failures)
    integer, intent(inout) :: failures
    real(dp) :: list(5)

    call linspace(from=0._dp, to=1._dp, array=list)

    call assert_approx(list(1), 0.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(list(2), 0.25_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(list(3), 0.5_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(list(4), 0.75_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(list(5), 1._dp, 1e-5_dp, __FILE__, __LINE__, failures)
end

subroutine linspace_test2(failures)
    integer, intent(inout) :: failures
    real(dp) :: list(5)

    call linspace(from=10._dp, to=20._dp, array=list)

    call assert_approx(list(1), 10.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(list(2), 12.5_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(list(3), 15.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(list(4), 17.5_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(list(5), 20._dp, 1e-5_dp, __FILE__, __LINE__, failures)
end

subroutine linspace_test3(failures)
    integer, intent(inout) :: failures
    real(dp) :: list(912)

    call linspace(from=2._dp/3._dp, to=7._dp/9._dp, array=list)

    call assert_approx(list(1), 0.666666666666667_dp, 1e-15_dp, __FILE__, __LINE__, failures)
    call assert_approx(list(2), 0.666788632760093_dp, 1e-15_dp, __FILE__, __LINE__, failures)
    call assert_approx(list(73), 0.675448225393341_dp, 1e-15_dp, __FILE__, __LINE__, failures)
    call assert_approx(list(417), 0.717404561531894_dp, 1e-15_dp, __FILE__, __LINE__, failures)
    call assert_approx(list(911), 0.777655811684352_dp, 1e-15_dp, __FILE__, __LINE__, failures)
    call assert_approx(list(912), 0.777777777777778_dp, 1e-15_dp, __FILE__, __LINE__, failures)
end

subroutine float_utils_test_all(failures)
    integer, intent(inout) :: failures

    call can_convert_real_to_int_test(failures)
    call linspace_test(failures)
    call linspace_test2(failures)
    call linspace_test3(failures)
end

end module FloatUtilsTest
