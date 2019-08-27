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
    ! call assert_equal(settings%errors_path, "errors.txt", __FILE__, __LINE__, failures)
    ! call assert_equal(settings%nx, 21, __FILE__, __LINE__, failures)
    ! call assert_equal(settings%nt, 300, __FILE__, __LINE__, failures)
    ! call assert_approx(settings%k, 2.28e-5_dp, 1e-5_dp, __FILE__, __LINE__, failures)
end

! subroutine read_from_parsed_command_line_test__named(failures)
!     integer, intent(inout) :: failures
!     type(parsed_args) :: parsed
!     type(program_settings) :: settings
!     character(len=1024) :: error_message

!     call allocate_parsed(size=4, parsed=parsed)

!     parsed%positional_count = 2
!     parsed%positional(1) = "data.txt"
!     parsed%positional(2) = "errors.txt"

!     parsed%named_count = 4
!     parsed%named_name(1) = "nx"
!     parsed%named_value(1) = "32"

!     parsed%named_name(2) = "nt"
!     parsed%named_value(2) = "118"

!     parsed%named_name(3) = "alpha"
!     parsed%named_value(3) = "0.55"

!     parsed%named_name(4) = "k"
!     parsed%named_value(4) = "1.2e-2"

!     call read_from_parsed_command_line(parsed=parsed, settings=settings, error_message=error_message)

!     call assert_true(string_is_empty(error_message), __FILE__, __LINE__, failures)
!     call assert_equal(settings%nx, 32, __FILE__, __LINE__, failures)
!     call assert_equal(settings%nt, 118, __FILE__, __LINE__, failures)
!     call assert_approx(settings%alpha, 0.55_dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(settings%k, 0.012_dp, 1e-5_dp, __FILE__, __LINE__, failures)
! end


! subroutine show_help_test(failures)
!     integer, intent(inout) :: failures
!     type(parsed_args) :: parsed
!     type(program_settings) :: settings
!     character(len=1024) :: error_message

!     call allocate_parsed(size=2, parsed=parsed)

!     parsed%positional_count = 0
!     parsed%named_count = 1

!     parsed%named_name(1) = "help"
!     parsed%named_value(1) = ""

!     call read_from_parsed_command_line(parsed=parsed, settings=settings, error_message=error_message)

!     call assert_true(.not. string_is_empty(error_message), __FILE__, __LINE__, failures)

!     call assert_string_starts_with(error_message, &
!             NEW_LINE('h')//"This program solves the heat equation", &
!             __FILE__, __LINE__, failures)
! end


! ! read_from_parsed_command_line
! ! --------------

! subroutine read_from_command_line_test(failures)
!     integer, intent(inout) :: failures
!     type(program_settings) :: settings
!     logical :: success

!     call read_from_command_line(silent=.true., settings=settings, success=success)

!     call assert_true(.not. success, __FILE__, __LINE__, failures)
! end


subroutine settings_test_all(failures)
    integer, intent(inout) :: failures

    call read_from_parsed_command_line_test__no_args(failures)
    ! call read_from_parsed_command_line_test__named(failures)

    ! call show_help_test(failures)

    ! call read_from_command_line_test(failures)
end

end module SettingsTest
