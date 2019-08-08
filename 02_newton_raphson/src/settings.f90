!
! Manage settings of the program
!
module Settings
use Types, only: dp
use String, only: string_is_empty

use CommandLineArgs, only: parsed_args, get_positional_value,&
                            get_named_value_or_default, has_flag, &
                            parse_current_command_line_arguments
implicit none
private
public :: read_from_parsed_command_line, read_from_command_line

!
! Stores program settings:
!
type, public :: program_settings
    ! the starting value for x for the root finding algorithm.
    real(dp) :: x_start

    ! convergence tolerance for Newton-Raphson method.
    real(dp) :: tolerance

    ! the maximum number of iterations of the Newton-Raphson method.
    integer :: max_iterations
end type program_settings

! Help message to be shown
character(len=1024), parameter :: HELP_MESSAGE = NEW_LINE('h')//"&
    &This program finds a single root of equation "//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    cos(x) - x = 0"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &using Newton-Raphson method.&
    &"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &Usage:&
    &"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    & ./build/main XSTART [--tolerance=1e-5] [--max_iterations=20]"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    XSTART : the starting x value for finding the root. Ex: 0.5."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    tolerance : convergence tolerance for Newton-Raphson method."//NEW_LINE('h')//"&
    &                Default: 1.e-5."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    max_iterations : the maximum number of iterations of "//NEW_LINE('h')//"&
    &                     the Newton-Raphson method."//NEW_LINE('h')//"&
    &                     Default: 20."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --help : show this message"//NEW_LINE('h')

! Default values for the settings
! ------

real(dp), parameter :: DEFAULT_TOLERANCE = 1.e-5
integer, parameter :: DEFAULT_MAX_ITERATIONS = 20

contains

!
! Reads settings from parsed command line arguments.
! Shows errors to output if command line arguments were incorrect.
!
! Outputs:
! -------
!
! settings : parsed line arguments.
!
! success : .true. if all settings were successfully read and we are ready
!                  to run the program
!
! silent : do not show any output when .true. (used in unit tests)
!
subroutine read_from_command_line(silent, settings, success)
    logical, intent(in) :: silent
    type(program_settings), intent(out) :: settings
    logical, intent(out) :: success
    type(parsed_args) :: parsed
    character(len=1024) :: error_message

    call parse_current_command_line_arguments(parsed)

    call read_from_parsed_command_line(parsed=parsed, settings=settings, &
                                       error_message=error_message)

    if (.not. string_is_empty(error_message)) then
        ! Detected errors in command line arguments
        if (.not. silent) write (0, *) trim(error_message)
        success = .false.
        return
    end if

    success = .true.
end subroutine


!
! Reads settings from parsed command line arguments.
!
! Inputs:
! --------
!
! parsed: object containing the parsed command line arguments.
!
!
! Outputs:
! -------
!
! settings : parsed line arguments.
!
! error_message : an error message to be shown to the user. Empty if no error.
!
subroutine read_from_parsed_command_line(parsed, settings, error_message)
    type(parsed_args), intent(in) :: parsed
    type(program_settings), intent(out) :: settings
    character(len=*), intent(out) :: error_message
    logical :: success
    error_message = ""
    settings%x_start = 0
    settings%tolerance = 0
    settings%max_iterations = 0

    ! help
    ! --------------

    if (has_flag(name='help', parsed=parsed) .or. &
        has_flag(name='h', parsed=parsed)) then

        error_message = HELP_MESSAGE
        return
    end if

    ! x-value
    ! --------------

    if (parsed%positional_count /= 1) then
        error_message = "ERROR: XSTART is missing."//NEW_LINE('h')//" &
                        &Run with --help for help."
        return
    end if

    call get_positional_value(index=1, parsed=parsed, value=settings%x_start, success=success)

    if (.not. success) then
        error_message = "ERROR: XSTART is not a number."//NEW_LINE('h')//"&
                        &Run with --help for help."
        return
    end if

    ! tolerance
    ! --------------

    call get_named_value_or_default(name='tolerance', parsed=parsed, &
                                    default=DEFAULT_TOLERANCE, &
                                    value=settings%tolerance, success=success)

    if (.not. success) then
        error_message = "ERROR: tolerance is not a number."//NEW_LINE('h')//"&
                        &Run with --help for help."
        return
    end if


    ! max_iterations
    ! --------------

    call get_named_value_or_default(name='max_iterations', parsed=parsed, &
                                    default=DEFAULT_MAX_ITERATIONS, &
                                    value=settings%max_iterations, success=success)

    if (.not. success) then
        error_message = "ERROR: max_iterations is not an integer number."//NEW_LINE('h')//"&
                        &Run with --help for help."
        return
    end if

end subroutine

end module Settings