module CommandLineArgsTest
use Types, only: dp

use AssertsTest, only: assert_equal, assert_true, assert_approx

use CommandLineArgs, only: parse_command_line_arguments, parsed_args, get_positional_value, &
                            get_named_value, ARGUMENT_MAX_LENGTH, allocate_parsed, &
                            parse_current_command_line_arguments, &
                            get_named_value_or_default, has_flag, is_named, &
                            unrecognized_named_args
implicit none
private
public command_line_args_test_all

contains

! parse_current_command_line_arguments
! ------------------

subroutine parse_current_command_line_arguments_test(failures)
    integer, intent(inout) :: failures
    type(parsed_args) :: parsed

    call parse_current_command_line_arguments(parsed)

    call assert_equal(parsed%named_count, 0, __FILE__, __LINE__, failures)
end


! parse_command_line_arguments
! ------------------

subroutine parse_command_line_arguments_test(failures)
    integer, intent(inout) :: failures
    character(len=1024) :: str(6)
    type(parsed_args) :: parsed

    str(1) = "one"
    str(2) = "--compression=23"
    str(3) = "--h"
    str(4) = "two"
    str(5) = "three"
    str(6) = "  "

    call parse_command_line_arguments(str, parsed)

    ! Positional arguments
    call assert_equal(parsed%positional_count, 3, __FILE__, __LINE__, failures)
    call assert_equal(parsed%positional(1), "one", __FILE__, __LINE__, failures)
    call assert_equal(parsed%positional(2), "two", __FILE__, __LINE__, failures)
    call assert_equal(parsed%positional(3), "three", __FILE__, __LINE__, failures)

    ! Named arguments
    call assert_equal(parsed%named_count, 2, __FILE__, __LINE__, failures)
    call assert_equal(parsed%named_name(1), "compression", __FILE__, __LINE__, failures)
    call assert_equal(parsed%named_value(1), "23", __FILE__, __LINE__, failures)
    call assert_equal(parsed%named_name(2), "h", __FILE__, __LINE__, failures)
    call assert_equal(parsed%named_value(2), "", __FILE__, __LINE__, failures)
end

subroutine parse_command_line_arguments_test__no_arguments(failures)
    integer, intent(inout) :: failures
    character(len=1024) :: str(0)
    type(parsed_args) :: parsed

    call parse_command_line_arguments(str, parsed)

    ! Positional argument1
    call assert_equal(parsed%positional_count, 0, __FILE__, __LINE__, failures)
    call assert_equal(parsed%named_count, 0, __FILE__, __LINE__, failures)
end

subroutine parse_command_line_arguments_test__named_arguments(failures)
    integer, intent(inout) :: failures
    character(len=1024) :: str(9)
    type(parsed_args) :: parsed

    str(1) = "--one"
    str(2) = "=32"
    str(3) = "-two"
    str(4) = "="
    str(5) = "234"
    str(6) = "--three"
    str(7) = "--four"
    str(8) = "="
    str(9) = "--five"

    call parse_command_line_arguments(str, parsed)

    ! Positional arguments
    call assert_equal(parsed%positional_count, 0, __FILE__, __LINE__, failures)

    ! Named arguments
    call assert_equal(parsed%named_count, 5, __FILE__, __LINE__, failures)

    call assert_equal(parsed%named_name(1), "one", __FILE__, __LINE__, failures)
    call assert_equal(parsed%named_value(1), "32", __FILE__, __LINE__, failures)

    call assert_equal(parsed%named_name(2), "two", __FILE__, __LINE__, failures)
    call assert_equal(parsed%named_value(2), "234", __FILE__, __LINE__, failures)

    call assert_equal(parsed%named_name(3), "three", __FILE__, __LINE__, failures)
    call assert_equal(parsed%named_value(3), "", __FILE__, __LINE__, failures)

    call assert_equal(parsed%named_name(4), "four", __FILE__, __LINE__, failures)
    call assert_equal(parsed%named_value(4), "", __FILE__, __LINE__, failures)

    call assert_equal(parsed%named_name(5), "five", __FILE__, __LINE__, failures)
    call assert_equal(parsed%named_value(5), "", __FILE__, __LINE__, failures)
end


! get_positional
! ---------------

subroutine get_positional_test__real_dp(failures)
    integer, intent(inout) :: failures
    type(parsed_args) :: parsed
    real(dp) :: result
    logical :: success

    call allocate_parsed(size=2, parsed=parsed)

    parsed%positional_count = 2
    parsed%positional(1) = "43.321"
    parsed%positional(2) = "-10"

    parsed%named_count = 1
    parsed%named_name(1) = "name_one_key"
    parsed%named_value(1) = "name_one_value"

    call get_positional_value(index=1, parsed=parsed, value=result, success=success)
    call assert_true(success, __FILE__, __LINE__, failures)
    call assert_approx(result, 43.321_dp, 1e-5_dp, __FILE__, __LINE__, failures)

    call get_positional_value(index=2, parsed=parsed, value=result, success=success)
    call assert_true(success, __FILE__, __LINE__, failures)
    call assert_approx(result, -10._dp, 1e-5_dp, __FILE__, __LINE__, failures)

    call get_positional_value(index=3, parsed=parsed, value=result, success=success)
    call assert_true(.not. success, __FILE__, __LINE__, failures)
end

subroutine get_positional_test__integer(failures)
    integer, intent(inout) :: failures
    type(parsed_args) :: parsed
    integer :: result
    logical :: success

    call allocate_parsed(size=2, parsed=parsed)

    parsed%positional_count = 2
    parsed%positional(1) = "43"
    parsed%positional(2) = "not a number"

    parsed%named_count = 1
    parsed%named_name(1) = "name_one_key"
    parsed%named_value(1) = "name_one_value"

    call get_positional_value(index=1, parsed=parsed, value=result, success=success)
    call assert_true(success, __FILE__, __LINE__, failures)
    call assert_equal(result, 43, __FILE__, __LINE__, failures)

    call get_positional_value(index=2, parsed=parsed, value=result, success=success)
    call assert_true(.not. success, __FILE__, __LINE__, failures)
end

subroutine get_positional_test__string(failures)
    integer, intent(inout) :: failures
    type(parsed_args) :: parsed
    character(len=1024) :: result
    logical :: success

    call allocate_parsed(size=2, parsed=parsed)

    parsed%positional_count = 1
    parsed%positional(1) = "marmite.jpg"

    parsed%named_count = 1
    parsed%named_name(1) = "name_one_key"
    parsed%named_value(1) = "name_one_value"

    call get_positional_value(index=1, parsed=parsed, value=result, success=success)
    call assert_true(success, __FILE__, __LINE__, failures)
    call assert_equal(result, "marmite.jpg", __FILE__, __LINE__, failures)

    call get_positional_value(index=2, parsed=parsed, value=result, success=success)
    call assert_true(.not. success, __FILE__, __LINE__, failures)
end


! get_named_value
! ---------------

subroutine get_named_value_test__string(failures)
    integer, intent(inout) :: failures
    type(parsed_args) :: parsed
    character(len=ARGUMENT_MAX_LENGTH) :: result
    logical :: success

    call allocate_parsed(size=2, parsed=parsed)

    parsed%positional_count = 2
    parsed%positional(1) = "43.321"
    parsed%positional(2) = "-10"

    parsed%named_count = 2
    parsed%named_name(1) = "name_one_key"
    parsed%named_value(1) = "12.32"

    parsed%named_name(2) = "name_two_key"
    parsed%named_value(2) = "43"

    call get_named_value(name='name_one_key', parsed=parsed, value=result, success=success)
    call assert_true(success, __FILE__, __LINE__, failures)
    call assert_equal(result, "12.32", __FILE__, __LINE__, failures)

    call get_named_value(name='name_two_key', parsed=parsed, value=result, success=success)
    call assert_true(success, __FILE__, __LINE__, failures)
    call assert_equal(result, "43", __FILE__, __LINE__, failures)

    call get_named_value(name='not exist', parsed=parsed, value=result, success=success)
    call assert_true(.not. success, __FILE__, __LINE__, failures)
end

subroutine get_named_value_test__real_dp(failures)
    integer, intent(inout) :: failures
    type(parsed_args) :: parsed
    real(dp) :: result
    logical :: success

    call allocate_parsed(size=2, parsed=parsed)

    parsed%positional_count = 2
    parsed%positional(1) = "43.321"
    parsed%positional(2) = "-10"

    parsed%named_count = 2
    parsed%named_name(1) = "name_one_key"
    parsed%named_value(1) = "12.32"

    parsed%named_name(2) = "name_two_key"
    parsed%named_value(2) = "not a number"

    call get_named_value(name='name_one_key', parsed=parsed, value=result, success=success)
    call assert_true(success, __FILE__, __LINE__, failures)
    call assert_approx(result, 12.32_dp, 1e-5_dp, __FILE__, __LINE__, failures)

    call get_named_value(name='name_two_key', parsed=parsed, value=result, success=success)
    call assert_true(.not. success, __FILE__, __LINE__, failures)

    call get_named_value(name='no key', parsed=parsed, value=result, success=success)
    call assert_true(.not. success, __FILE__, __LINE__, failures)
end

subroutine get_named_value_test__integer(failures)
    integer, intent(inout) :: failures
    type(parsed_args) :: parsed
    integer :: result
    logical :: success

    call allocate_parsed(size=2, parsed=parsed)

    parsed%positional_count = 2
    parsed%positional(1) = "43.321"
    parsed%positional(2) = "-10"

    parsed%named_count = 2
    parsed%named_name(1) = "name_one_key"
    parsed%named_value(1) = "32"

    parsed%named_name(2) = "name_two_key"
    parsed%named_value(2) = "not a number"

    call get_named_value(name='name_one_key', parsed=parsed, value=result, success=success)
    call assert_true(success, __FILE__, __LINE__, failures)
    call assert_equal(result, 32, __FILE__, __LINE__, failures)

    call get_named_value(name='name_two_key', parsed=parsed, value=result, success=success)
    call assert_true(.not. success, __FILE__, __LINE__, failures)

    call get_named_value(name='no key', parsed=parsed, value=result, success=success)
    call assert_true(.not. success, __FILE__, __LINE__, failures)
end


! get_named_value_or_default
! ---------------

subroutine get_named_value_or_default_test__real_dp(failures)
    integer, intent(inout) :: failures
    type(parsed_args) :: parsed
    real(dp) :: result
    logical :: success

    call allocate_parsed(size=2, parsed=parsed)

    parsed%positional_count = 2
    parsed%positional(1) = "43.321"
    parsed%positional(2) = "-10"

    parsed%named_count = 3
    parsed%named_name(1) = "name_one_key"
    parsed%named_value(1) = "12.32"

    parsed%named_name(2) = "name_two_key"
    parsed%named_value(2) = "not a number"

    ! Argument is present
    call get_named_value_or_default(name='name_one_key', parsed=parsed, default=-2.2_dp, &
                                    value=result, success=success)

    call assert_true(success, __FILE__, __LINE__, failures)
    call assert_approx(result, 12.32_dp, 1e-5_dp, __FILE__, __LINE__, failures)

    ! Argument is present but not a number - return error
    call get_named_value_or_default(name='name_two_key', parsed=parsed, default=-2.2_dp, &
                                    value=result, success=success)

    call assert_true(.not. success, __FILE__, __LINE__, failures)


    ! Argument is not present - use default value
    call get_named_value_or_default(name='no key', parsed=parsed, value=result, &
                                    default=-2.2_dp, success=success)

    call assert_true(success, __FILE__, __LINE__, failures)
    call assert_approx(result, -2.2_dp, 1e-5_dp, __FILE__, __LINE__, failures)
end

subroutine get_named_value_or_default_test__integer(failures)
    integer, intent(inout) :: failures
    type(parsed_args) :: parsed
    integer :: result
    logical :: success

    call allocate_parsed(size=2, parsed=parsed)

    parsed%positional_count = 2
    parsed%positional(1) = "43"
    parsed%positional(2) = "-10"

    parsed%named_count = 2
    parsed%named_name(1) = "name_one_key"
    parsed%named_value(1) = "12"

    parsed%named_name(2) = "name_two_key"
    parsed%named_value(2) = "not a number"

    ! Argument is present
    call get_named_value_or_default(name='name_one_key', parsed=parsed, default=-2, &
                                    value=result, success=success)

    call assert_true(success, __FILE__, __LINE__, failures)
    call assert_equal(result, 12, __FILE__, __LINE__, failures)

    ! Argument is present but not a number - return error
    call get_named_value_or_default(name='name_two_key', parsed=parsed, default=-2, &
                                    value=result, success=success)

    call assert_true(.not. success, __FILE__, __LINE__, failures)


    ! Argument is not present - use default value
    call get_named_value_or_default(name='no key', parsed=parsed, value=result, &
                                    default=-2, success=success)

    call assert_true(success, __FILE__, __LINE__, failures)
    call assert_equal(result, -2, __FILE__, __LINE__, failures)
end

subroutine has_flag_test(failures)
    integer, intent(inout) :: failures
    type(parsed_args) :: parsed
    logical :: result

    call allocate_parsed(size=2, parsed=parsed)

    parsed%positional_count = 2
    parsed%positional(1) = "43.321"
    parsed%positional(2) = "-10"

    parsed%named_count = 2
    parsed%named_name(1) = "name_one_key"
    parsed%named_value(1) = "32"

    parsed%named_name(2) = "help"
    parsed%named_value(2) = ""

    result = has_flag(name='help', parsed=parsed)
    call assert_true(result, __FILE__, __LINE__, failures)
end


subroutine is_named_test(failures)
    integer, intent(inout) :: failures

    call assert_true(is_named('-help'), __FILE__, __LINE__, failures)
    call assert_true(is_named('-sd'), __FILE__, __LINE__, failures)
    call assert_true(.not. is_named('-0'), __FILE__, __LINE__, failures)
    call assert_true(.not. is_named('-1'), __FILE__, __LINE__, failures)
    call assert_true(.not. is_named('-2'), __FILE__, __LINE__, failures)
    call assert_true(.not. is_named('-3'), __FILE__, __LINE__, failures)
    call assert_true(.not. is_named('-4'), __FILE__, __LINE__, failures)
    call assert_true(.not. is_named('-5'), __FILE__, __LINE__, failures)
    call assert_true(.not. is_named('-6'), __FILE__, __LINE__, failures)
    call assert_true(.not. is_named('-7'), __FILE__, __LINE__, failures)
    call assert_true(.not. is_named('-8'), __FILE__, __LINE__, failures)
    call assert_true(.not. is_named('-9'), __FILE__, __LINE__, failures)
end

! unrecognized_named_args
! ---------------------

subroutine unrecognized_named_args_test__all_decognized(failures)
   integer, intent(inout) :: failures
    type(parsed_args) :: parsed
    character(len=ARGUMENT_MAX_LENGTH) :: valid_args(2)
    character(len=ARGUMENT_MAX_LENGTH), allocatable :: unrecognized(:)
    integer :: count

    valid_args(1) = "name_one_key"
    valid_args(2) = "help"

    call allocate_parsed(size=2, parsed=parsed)

    parsed%positional_count = 0

    parsed%named_count = 2
    parsed%named_name(1) = "name_one_key"
    parsed%named_value(1) = "32"

    parsed%named_name(2) = "help"
    parsed%named_value(2) = ""

    call unrecognized_named_args(valid=valid_args, parsed=parsed, &
        unrecognized=unrecognized, count=count)

    call assert_equal(count, 0, __FILE__, __LINE__, failures)
end

subroutine unrecognized_named_args_test__unrecognized(failures)
   integer, intent(inout) :: failures
    type(parsed_args) :: parsed
    character(len=ARGUMENT_MAX_LENGTH) :: valid_args(2)
    character(len=ARGUMENT_MAX_LENGTH), allocatable :: unrecognized(:)
    integer :: count

    valid_args(1) = "name_one_key"
    valid_args(2) = "help"

    call allocate_parsed(size=3, parsed=parsed)

    parsed%positional_count = 0

    parsed%named_count = 3
    parsed%named_name(1) = "name_one_key"
    parsed%named_value(1) = "32"

    parsed%named_name(2) = "possum"
    parsed%named_value(2) = "32"

    parsed%named_name(3) = "help"
    parsed%named_value(3) = ""

    call unrecognized_named_args(valid=valid_args, parsed=parsed, &
        unrecognized=unrecognized, count=count)

    call assert_equal(count, 1, __FILE__, __LINE__, failures)
end


subroutine command_line_args_test_all(failures)
    integer, intent(inout) :: failures

    call parse_current_command_line_arguments_test(failures)

    call parse_command_line_arguments_test(failures)
    call parse_command_line_arguments_test__no_arguments(failures)
    call parse_command_line_arguments_test__named_arguments(failures)

    call get_positional_test__real_dp(failures)
    call get_positional_test__integer(failures)
    call get_positional_test__string(failures)

    call get_named_value_test__string(failures)
    call get_named_value_test__real_dp(failures)
    call get_named_value_test__integer(failures)

    call get_named_value_or_default_test__real_dp(failures)
    call get_named_value_or_default_test__integer(failures)

    call has_flag_test(failures)

    call is_named_test(failures)

    call unrecognized_named_args_test__all_decognized(failures)
    call unrecognized_named_args_test__unrecognized(failures)
end

end module CommandLineArgsTest
