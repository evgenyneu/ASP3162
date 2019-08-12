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

    call allocate_parsed(size=2, parsed=parsed)

    parsed%positional_count = 0
    parsed%named_count = 0

    call read_from_parsed_command_line(parsed=parsed, settings=settings, error_message=error_message)

    call assert_true(string_is_empty(error_message), __FILE__, __LINE__, failures)
    call assert_approx(settings%t_end, 6.283185_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(settings%delta_t, 0.1_dp, 1e-5_dp, __FILE__, __LINE__, failures)
end

subroutine read_from_parsed_command_line_test__named(failures)
    integer, intent(inout) :: failures
    type(parsed_args) :: parsed
    type(program_settings) :: settings
    character(len=1024) :: error_message

    call allocate_parsed(size=2, parsed=parsed)

    parsed%positional_count = 0

    parsed%named_count = 2
    parsed%named_name(1) = "t_end"
    parsed%named_value(1) = "2.31"

    parsed%named_name(2) = "delta_t"
    parsed%named_value(2) = "0.01"

    call read_from_parsed_command_line(parsed=parsed, settings=settings, error_message=error_message)

    call assert_true(string_is_empty(error_message), __FILE__, __LINE__, failures)
    call assert_approx(settings%t_end, 2.31_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(settings%delta_t, 0.01_dp, 1e-5_dp, __FILE__, __LINE__, failures)
end

subroutine read_from_parsed_command_line_test__t_end_not_a_number(failures)
    integer, intent(inout) :: failures
    type(parsed_args) :: parsed
    type(program_settings) :: settings
    character(len=1024) :: error_message

    call allocate_parsed(size=2, parsed=parsed)

    parsed%positional_count = 0

    parsed%named_count = 2
    parsed%named_name(1) = "t_end"
    parsed%named_value(1) = "not a number"

    parsed%named_name(2) = "max_iterations"
    parsed%named_value(2) = "17"

    call read_from_parsed_command_line(parsed=parsed, settings=settings, error_message=error_message)

    call assert_true(.not. string_is_empty(error_message), __FILE__, __LINE__, failures)
    call assert_string_starts_with(error_message, "ERROR: t_end is not a number", &
        __FILE__, __LINE__, failures)
end

subroutine read_from_parsed_command_line_test__delta_t_not_a_number(failures)
    integer, intent(inout) :: failures
    type(parsed_args) :: parsed
    type(program_settings) :: settings
    character(len=1024) :: error_message

    call allocate_parsed(size=2, parsed=parsed)

    parsed%positional_count = 0

    parsed%named_count = 2
    parsed%named_name(1) = "t_end"
    parsed%named_value(1) = "2.32"

    parsed%named_name(2) = "delta_t"
    parsed%named_value(2) = "not a number"

    call read_from_parsed_command_line(parsed=parsed, settings=settings, error_message=error_message)

    call assert_true(.not. string_is_empty(error_message), __FILE__, __LINE__, failures)
    call assert_string_starts_with(error_message, "ERROR: delta_t is not a number", &
        __FILE__, __LINE__, failures)
end


subroutine show_help_test(failures)
    integer, intent(inout) :: failures
    type(parsed_args) :: parsed
    type(program_settings) :: settings
    character(len=1024) :: error_message

    call allocate_parsed(size=2, parsed=parsed)

    parsed%positional_count = 0
    parsed%named_count = 1

    parsed%named_name(1) = "help"
    parsed%named_value(1) = ""

    call read_from_parsed_command_line(parsed=parsed, settings=settings, error_message=error_message)

    call assert_true(.not. string_is_empty(error_message), __FILE__, __LINE__, failures)

    call assert_string_starts_with(error_message, &
                                   NEW_LINE('h')//"This program solves ODE", &
                                   __FILE__, __LINE__, failures)
end


! read_from_parsed_command_line
! --------------

subroutine read_from_command_line_test(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: settings
    logical :: success

    call read_from_command_line(silent=.true., settings=settings, success=success)

    call assert_true(success, __FILE__, __LINE__, failures)
    call assert_approx(settings%t_end, 6.283185_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(settings%delta_t, 0.1_dp, 1e-5_dp, __FILE__, __LINE__, failures)
end


subroutine settings_test_all(failures)
    integer, intent(inout) :: failures

    call read_from_parsed_command_line_test__no_args(failures)
    call read_from_parsed_command_line_test__named(failures)
    call read_from_parsed_command_line_test__t_end_not_a_number(failures)
    call read_from_parsed_command_line_test__delta_t_not_a_number(failures)

    call show_help_test(failures)

    call read_from_command_line_test(failures)
end

end module SettingsTest
