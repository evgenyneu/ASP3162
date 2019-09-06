module StringTest
use Types, only: dp

use AssertsTest, only: assert_approx, assert_true, &
                        assert_equal

use String, only: string_starts_with, string_is_empty, string_to_number
implicit none
private
public string_test_all

contains

! string_starts_with
! ----------------

subroutine string_starts_with_test(failures)
    integer, intent(inout) :: failures
    logical :: result

    result = string_starts_with("hello world", "hello")

    call assert_true(result, __FILE__, __LINE__, failures)
end

subroutine string_starts_with_failure_test(failures)
    integer, intent(inout) :: failures
    logical :: result

    result = string_starts_with("hello world", "possum")

    call assert_true(.not. result, __FILE__, __LINE__, failures)
end

subroutine string_starts_with_empty_strings_test(failures)
    integer, intent(inout) :: failures
    logical :: result

    result = string_starts_with("", "")

    call assert_true(result, __FILE__, __LINE__, failures)
end


! string_is_empty
! ----------------

subroutine string_is_empty_test__empty(failures)
    integer, intent(inout) :: failures
    logical :: result

    result = string_is_empty("   ")

    call assert_true(result, __FILE__, __LINE__, failures)
end

subroutine string_is_empty_test__not_empty(failures)
    integer, intent(inout) :: failures
    logical :: result

    result = string_is_empty("possum")

    call assert_true(.not. result, __FILE__, __LINE__, failures)
end

! string_to_number real(dp)
! -----------------

subroutine string_to_number_test__real_dp_success(failures)
    integer, intent(inout) :: failures
    logical :: success
    real(dp) :: result

    call string_to_number("-12.42", result, success)

    call assert_true(success, __FILE__, __LINE__, failures)
    call assert_approx(result, -12.42_dp, 1e-5_dp, __FILE__, __LINE__, failures)
end

subroutine string_to_number_test__real_dp_failure(failures)
    integer, intent(inout) :: failures
    logical :: success
    real(dp) :: result

    call string_to_number("not a number", result, success)

    call assert_true(.not. success, __FILE__, __LINE__, failures)
end

! string_to_number integer(dp)
! -----------------

subroutine string_to_number_test__integer_success(failures)
    integer, intent(inout) :: failures
    logical :: success
    integer :: result

    call string_to_number("-12", result, success)

    call assert_true(success, __FILE__, __LINE__, failures)
    call assert_equal(result, -12, __FILE__, __LINE__, failures)
end

subroutine string_to_number_test__integer_failure(failures)
    integer, intent(inout) :: failures
    logical :: success
    integer :: result

    call string_to_number("not a number", result, success)

    call assert_true(.not. success, __FILE__, __LINE__, failures)
end


subroutine string_test_all(failures)
    integer, intent(inout) :: failures

    call string_starts_with_failure_test(failures)
    call string_starts_with_test(failures)
    call string_starts_with_empty_strings_test(failures)

    call string_is_empty_test__empty(failures)
    call string_is_empty_test__not_empty(failures)

    call string_to_number_test__real_dp_success(failures)
    call string_to_number_test__real_dp_failure(failures)

    call string_to_number_test__integer_success(failures)
    call string_to_number_test__integer_failure(failures)
end

end module StringTest
