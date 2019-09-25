! Assertions to be used in unit tests

module AssertsTest
use Types, only: dp
use String, only: string_starts_with
implicit none
private
public assert_true, assert_approx, assert_equal, assert_string_starts_with

!
! Check if two floating point values are close to each other.
! Here we calculate relative differences between `value` and `expectation`
! numbers:
!
!  difference = abs(value - expectation) / abs(expectation)
!
! and then ensure that the difference is smaller than `tolerance`.
!
! Shows an error message and increments `failures` if two numbers are
! further apart.
!
! Example, check that `result` contains a value that is within 1e-5 from
! 43.321:
!
!   call assert_approx(result, 43.321_dp, 1e-5_dp, __FILE__, __LINE__, &
!                      failures)
!
! Inputs:
! --------
! value, expectation : two values to be compared
!
! tolerance : the maximum allowed relative difference between two values.
!
! filename : the name of the test file, usually set to __FILE__
!
! line : the line number where this function is called, usually set to __LINE__
!
! failures : the counter of failed unit tests. If this assertion fails,
!            the counter is incremented.
!
interface assert_approx
    module procedure assert_approx_real_dp
end interface

!
! Verify that two values are equal (numbers or strings).
! Shows an error message and increments `failures` if two values not equal.
!
! Example, check that `result` is equal to number 43:
!
!   call assert_equal(result, 43, __FILE__, __LINE__, failures)
!
! Inputs:
! --------
! value, expectation : two values to be compared
!
! filename : the name of the test file, usually set to __FILE__
!
! line : the line number where this function is called, usually set to __LINE__
!
! failures : the counter of failed unit tests. If this assertion failes,
!            the counter is incremented.
!
interface assert_equal
    module procedure assert_equal_int, assert_equal_str
end interface

contains

!
! Prints a unit test error message to the output. For example,
! an error message for file "command_line_args_test.f90", line 161, and
! error message "43 != 42" will look like this:
!
!   ERROR at command_line_args_test.f90:161: 43 != 42
!
! Inputs:
! --------
!
! filename : the name of the test file, usually set to __FILE__
!
! line : the line number where this function is called, usually set to __LINE__
!
! message : the error message to be printed.
!
subroutine print_error(filename, line, message)
    character(*), intent(in) :: filename, message
    integer, intent(in) :: line

    print '(a, "ERROR at ", a, ":", i0, ": ", a, a)', NEW_LINE('h'), filename, &
    line, trim(message), NEW_LINE('h')
end

!
! Prints a progress dot to the output
!
subroutine print_dot()
    write(*, fmt="(1x,a)", advance="no") '·'
end

!
! Shows an error message and increments `failures` if `condition` is .false.
!
! Example, check that `success` variable is .true.:
!
!   call assert_true(success, __FILE__, __LINE__, failures)
!
! Inputs:
! --------
! condition : a logical condition to be checked.
!
! filename : the name of the test file, usually set to __FILE__
!
! line : the line number where this function is called, usually set to __LINE__
!
! failures : the counter of failed unit tests. If this assertion failes,
!            the counter is incremented.
!
subroutine assert_true(condition, filename, line, failures)
    character(*), intent(in) :: filename
    integer, intent(in) :: line
    logical, intent(in) :: condition
    integer, intent(inout) :: failures

    call print_dot()

    if (condition .neqv. .true.) then
        call print_error(filename, line, "Expected condition to be true")
        failures = failures + 1
    end if
end

subroutine assert_equal_int(value, expectation, filename, line, failures)
    character(*), intent(in) :: filename
    integer, intent(in) :: line
    integer, intent(in) :: value, expectation
    integer, intent(inout) :: failures
    character(len=1024) :: error_message

    call print_dot()

    if (value /= expectation) then
        write(error_message, '(i0, " != ", i0)') value, expectation
        call print_error(filename, line, error_message)
        failures = failures + 1
    end if
end

subroutine assert_equal_str(value, expectation, filename, line, failures)
    character(*), intent(in) :: filename, value, expectation
    integer, intent(in) :: line
    integer, intent(inout) :: failures
    character(len=1024) :: error_message

    call print_dot()

    if (value .ne. expectation) then
        write(error_message, '(a, " != ", a)') trim(value), trim(expectation)
        call print_error(filename, line, error_message)
        failures = failures + 1
    end if
end

!
! Shows an error message and increments `failures` if `value` string
! does not start with `substring`
!
! Example, check that `message` starts with "ERROR" text:
!
!   call assert_true(message, "ERROR",  __FILE__, __LINE__, failures)
!
! Inputs:
! --------
! value : a string.
!
! substring : a substring.
!
! line : the line number where this function is called, usually set to __LINE__
!
! failures : the counter of failed unit tests. If this assertion failes,
!            the counter is incremented.
!
subroutine assert_string_starts_with(value, substring, filename, line, failures)
    character(*), intent(in) :: filename, value, substring
    integer, intent(in) :: line
    integer, intent(inout) :: failures
    character(len=4094) :: error_message

    call print_dot()

    if (.not. string_starts_with(value, substring)) then

        write(error_message, '(a, a, a, a)') "'", trim(value), &
            "' does not start with ", trim(substring)

        call print_error(filename, line, error_message)
        failures = failures + 1
    end if
end

subroutine assert_approx_real_dp(value, expectation, tolerance, filename, line, failures)
    character(*), intent(in) :: filename
    integer, intent(in) :: line
    real(dp), intent(in) :: value, expectation, tolerance
    integer, intent(inout) :: failures
    character(len=1024) :: error_message
    real(dp) :: difference

    call print_dot()

    if (abs(expectation) < 1.e-80_dp) then
        ! If expectation is very small, calculate absolute difference
        ! between expectation and actual value
        difference = abs(value - expectation)
    else
        ! Otherwise, calculate relative difference
        difference = abs(value - expectation)/abs(expectation)
    end if

    if (difference > tolerance  .or. &
        ! Handle NaN case
        (ISNAN(value) .neqv. ISNAN(expectation))) then

        write(error_message, '(G0, " != ", G0)') value, expectation
        call print_error(filename, line, error_message)
        failures = failures + 1
    end if
end


end module AssertsTest
