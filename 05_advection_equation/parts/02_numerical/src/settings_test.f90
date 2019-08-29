module SettingsTest
use Types, only: dp
use AssertsTest, only: assert_equal, assert_true, assert_approx, assert_string_starts_with
use CommandLineArgs, only: parsed_args, allocate_parsed
use Settings, only: read_from_command_line, read_from_parsed_command_line, program_settings
use String, only: string_starts_with, string_is_empty
implicit none
private
public settings_test_all

contains

! read_from_parsed_command_line
! ----------------

subroutine read_from_parsed_command_line_test__no_args(failures)
    integer, intent(inout) :: failures
    type(parsed_args) :: parsed
    type(program_settings) :: settings
    character(len=1024) :: error_message

    call allocate_parsed(size=1, parsed=parsed)

    parsed%positional_count = 1
    parsed%positional(1) = "data.bin"
    parsed%named_count = 0

    call read_from_parsed_command_line(parsed=parsed, settings=settings, error_message=error_message)

    call assert_true(string_is_empty(error_message), __FILE__, __LINE__, failures)
    call assert_equal(settings%output_path, "data.bin", __FILE__, __LINE__, failures)

    call assert_approx(settings%x_start, -1.5_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(settings%x_end, 1.5_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_equal(settings%nx, 100, __FILE__, __LINE__, failures)

    call assert_approx(settings%t_start, 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(settings%t_end, 1.4_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_equal(settings%nt, 8, __FILE__, __LINE__, failures)
end

subroutine read_from_parsed_command_line_test__named(failures)
    integer, intent(inout) :: failures
    type(parsed_args) :: parsed
    type(program_settings) :: settings
    character(len=1024) :: error_message

    call allocate_parsed(size=6, parsed=parsed)

    parsed%positional_count = 1
    parsed%positional(1) = "data.bin"

    parsed%named_count = 6

    parsed%named_name(1) = "x_start"
    parsed%named_value(1) = "0.123"

    parsed%named_name(2) = "x_end"
    parsed%named_value(2) = "0.3434"

    parsed%named_name(3) = "nx"
    parsed%named_value(3) = "42"


    parsed%named_name(4) = "t_start"
    parsed%named_value(4) = "0.111"

    parsed%named_name(5) = "t_end"
    parsed%named_value(5) = "0.222"

    parsed%named_name(6) = "nt"
    parsed%named_value(6) = "132"


    call read_from_parsed_command_line(parsed=parsed, settings=settings, error_message=error_message)

    call assert_true(string_is_empty(error_message), __FILE__, __LINE__, failures)

    call assert_approx(settings%x_start, 0.123_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(settings%x_end, 0.3434_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_equal(settings%nx, 42, __FILE__, __LINE__, failures)

    call assert_approx(settings%t_start, 0.111_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(settings%t_end, 0.222_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_equal(settings%nt, 132, __FILE__, __LINE__, failures)
end


subroutine show_help_test(failures)
    integer, intent(inout) :: failures
    type(parsed_args) :: parsed
    type(program_settings) :: settings
    character(len=2024) :: error_message

    call allocate_parsed(size=1, parsed=parsed)

    parsed%positional_count = 0
    parsed%named_count = 1

    parsed%named_name(1) = "help"
    parsed%named_value(1) = ""

    call read_from_parsed_command_line(parsed=parsed, settings=settings, &
                                       error_message=error_message)

    call assert_true(.not. string_is_empty(error_message), __FILE__, &
                     __LINE__, failures)

    call assert_string_starts_with(error_message, &
            NEW_LINE('h')//"This program solves equation", &
            __FILE__, __LINE__, failures)
end


! read_from_parsed_command_line
! --------------

subroutine read_from_command_line_test(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: settings
    logical :: success

    call read_from_command_line(silent=.true., settings=settings, success=success)

    call assert_true(.not. success, __FILE__, __LINE__, failures)
end


subroutine settings_test_all(failures)
    integer, intent(inout) :: failures

    call read_from_parsed_command_line_test__no_args(failures)
    call read_from_parsed_command_line_test__named(failures)
    call show_help_test(failures)
    call read_from_command_line_test(failures)
end

end module SettingsTest
