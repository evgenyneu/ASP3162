module FloatUtilsTest
use Types, only: dp
use FloatUtils, only: can_convert_real_to_int
use AssertsTest, only: assert_true, assert_equal
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


subroutine float_utils_test_all(failures)
    integer, intent(inout) :: failures

    call can_convert_real_to_int_test(failures)
end

end module FloatUtilsTest
