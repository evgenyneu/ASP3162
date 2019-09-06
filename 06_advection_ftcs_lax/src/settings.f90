!
! Manage settings of the program
!
module Settings
use Types, only: dp
use String, only: string_is_empty
use Constants, only: pi

use CommandLineArgs, only: parsed_args, get_positional_value,&
                            get_named_value_or_default, has_flag, &
                            parse_current_command_line_arguments, &
                            unrecognized_named_args, ARGUMENT_MAX_LENGTH
implicit none
private
public :: read_from_parsed_command_line, read_from_command_line

integer, parameter :: HELP_MESSAGE_LENGTH = 4096

!
! Stores program settings:
!
type, public :: program_settings
    ! Path to the output file that will be filled with
    ! solution data
    character(len=4096) :: output_path

    ! The smallest x value
    real(dp) :: x_start

    ! The largest x value
    real(dp) :: x_end

    ! The number of x points in the grid
    integer :: nx

    ! The smallest t value
    real(dp) :: t_start

    ! The largest t value
    real(dp) :: t_end

    ! The velocity parameter of the advection equation
    real(dp) :: velocity

    ! Neumerical method used: ('ftcs', 'lax')
    character(len=1024) :: method
end type program_settings

! Help message to be shown
character(len=HELP_MESSAGE_LENGTH), parameter :: HELP_MESSAGE = NEW_LINE('h')//"&
    &This program solves advection equation"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &  u_t + v u_x = 0"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &Usage:&
    &"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    & ./build/main OUTPUT [--method=lax] [--x_start=-1.5] [--x_end=1.5]"//NEW_LINE('h')//"&
    &    [--nx=100] [--t_start=0] [--t_end=1.4] [--velocity=1]"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    OUTPUT : path to the output data file"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --method=NAME : numerical method to use"//NEW_LINE('h')//"&
    &                  (ftcs, lax). "//NEW_LINE('h')//"&
    &                  Default: lax."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --x_start=NUMBER : the smallest x value,"//NEW_LINE('h')//"&
    &                  Default: 0."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --x_end=NUMBER : the largest x value,"//NEW_LINE('h')//"&
    &                  Default: 1."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --nx=NUMBER : number of x points in the grid,"//NEW_LINE('h')//"&
    &                  Default: 101."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --t_start=NUMBER : the smallest t value,"//NEW_LINE('h')//"&
    &                  Default: 0."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --t_end=NUMBER : the largest t value,"//NEW_LINE('h')//"&
    &                  Default: 1."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --velocity=NUMBER : value of velocity parameter,"//NEW_LINE('h')//"&
    &                  Default: 1."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --help  : show this message."//NEW_LINE('h')

! Default values for the settings
! ------

real(dp), parameter :: DEFAULT_X_START = 0._dp
real(dp), parameter :: DEFAULT_X_END = 1._dp
integer, parameter :: DEFAULT_NX = 101

real(dp), parameter :: DEFAULT_T_START = 0._dp
real(dp), parameter :: DEFAULT_T_END = 1._dp
real(dp), parameter :: DEFAULT_VELOCITY = 1.0_dp

character(len=100), parameter :: DEFAULT_METHOD = "lax"
character(len=100), parameter :: ALLOWED_METHODS(2) = &
     [character(len=100) :: 'ftcs', 'lax']

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
    character(len=HELP_MESSAGE_LENGTH) :: error_message

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
! Make an error message shown to the user
!
! Inputs:
! --------
!
! text: message to be shown
!
!
! Outputs:
! -------
!
! message : the full message shown to user.
!
subroutine make_message(text, message)
    character(len=*), intent(in) :: text
    character(len=*), intent(out) :: message

     write(message, '(a, a, a, a, a)') "ERROR: ", text, ".", NEW_LINE('h'), &
        "Run with --help for help."
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
    character(len=ARGUMENT_MAX_LENGTH), allocatable :: unrecognized(:)
    integer :: unrecognized_count
    character(len=ARGUMENT_MAX_LENGTH) :: valid_args(10)

    error_message = ""

    ! help
    ! --------------

    if (has_flag(name='help', parsed=parsed) .or. &
        has_flag(name='h', parsed=parsed)) then

        error_message = HELP_MESSAGE
        return
    end if

    ! Check unrecognized parameters
    ! ----------

    valid_args(1) = "x_start"
    valid_args(2) = "x_end"
    valid_args(3) = "nx"
    valid_args(4) = "t_start"
    valid_args(5) = "t_end"
    valid_args(6) = "nt"
    valid_args(7) = "velocity"
    valid_args(8) = "method"
    valid_args(9) = "h"
    valid_args(10) = "help"

    call unrecognized_named_args(valid=valid_args, parsed=parsed, &
        unrecognized=unrecognized, count=unrecognized_count)

    if (unrecognized_count > 0) then
        write(error_message, '(a, a, a)') &
            "ERROR: Unrecognized parameter '", &
            trim(unrecognized(1)), &
            "'. Run with --help for help."
        return
    end if

    ! OUTPUT
    ! --------------

    if (parsed%positional_count /= 1) then
        call make_message("OUTPUT parameter is missing", error_message)
        return
    end if

    call get_positional_value(index=1, parsed=parsed, &
                              value=settings%output_path, &
                              success=success)

    if (.not. success) then
        call make_message("OUTPUT parameter is missing", error_message)
        return
    end if


    ! x_start
    ! --------------

    call get_named_value_or_default(name='x_start', parsed=parsed, &
                                    default=DEFAULT_X_START, &
                                    value=settings%x_start, success=success)

    if (.not. success) then
        call make_message("x_start is not a number", error_message)
        return
    end if


    ! x_end
    ! --------------

    call get_named_value_or_default(name='x_end', parsed=parsed, &
                                    default=DEFAULT_X_END, &
                                    value=settings%x_end, success=success)

    if (.not. success) then
        call make_message("x_end is not a number", error_message)
        return
    end if


    ! nx
    ! --------------

    call get_named_value_or_default(name='nx', parsed=parsed, &
                                    default=DEFAULT_NX, &
                                    value=settings%nx, success=success)

    if (.not. success) then
        call make_message("nx is not a number", error_message)
        return
    end if


    ! t_start
    ! --------------

    call get_named_value_or_default(name='t_start', parsed=parsed, &
                                    default=DEFAULT_T_START, &
                                    value=settings%t_start, success=success)

    if (.not. success) then
        call make_message("t_start is not a number", error_message)
        return
    end if


    ! t_end
    ! --------------

    call get_named_value_or_default(name='t_end', parsed=parsed, &
                                    default=DEFAULT_T_END, &
                                    value=settings%t_end, success=success)

    if (.not. success) then
        call make_message("t_end is not a number", error_message)
        return
    end if


    ! velocity
    ! --------------

    call get_named_value_or_default(name='velocity', parsed=parsed, &
                                    default=DEFAULT_VELOCITY, &
                                    value=settings%velocity, success=success)

    if (.not. success) then
        call make_message("velocity is not a number", error_message)
        return
    end if

    ! method
    ! --------------

    call get_named_value_or_default(name='method', parsed=parsed, &
                                    default=DEFAULT_METHOD, &
                                    value=settings%method, success=success)

    if (.not. success) then
        call make_message("Failed to read method", error_message)
        return
    end if

    if (.not. any(ALLOWED_METHODS == settings%method)) then
        call make_message("Incorrect method name", error_message)
        return
    end if
end subroutine

end module Settings