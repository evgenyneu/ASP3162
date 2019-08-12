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

!
! Stores program settings:
!
type, public :: program_settings
    ! inal value of t coordinate
    real(dp) :: t_end

    ! size of the timestep
    real(dp) :: delta_t
end type program_settings

! Help message to be shown
character(len=1024), parameter :: HELP_MESSAGE = NEW_LINE('h')//"&
    &This program solves ODE"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &  x''(t) + x(t) = 0"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &with initial conditions x(0) = 1, x'(0) = 0."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &Usage:&
    &"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    & ./build/main [--t_end=6.2] [--delta_t=0.1]"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    t_end   : the end value for t,"//NEW_LINE('h')//"&
    &               Default: 6.28."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    delta_t : size of the timestep,"//NEW_LINE('h')//"&
    &               Default: 0.1."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --help  : show this message."//NEW_LINE('h')

! Default values for the settings
! ------

real(dp), parameter :: DEFAULT_T_END = 2._dp * pi
real(dp), parameter :: DEFAULT_DELTA_T = 0.1_dp

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
    character(len=ARGUMENT_MAX_LENGTH), allocatable :: unrecognized(:)
    integer :: unrecognized_count
    character(len=ARGUMENT_MAX_LENGTH) :: valid_args(2)

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

    if (parsed%positional_count /= 0) then
        error_message = "ERROR: Unrecognized parameters."//NEW_LINE('h')//" &
                        &Run with --help for help."
        return
    end if

    valid_args(1) = "t_end"
    valid_args(1) = "delta_t"

    call unrecognized_named_args(valid=valid_args, parsed=parsed, &
        unrecognized=unrecognized, count=unrecognized_count)

    if (unrecognized_count > 0) then
        write(error_message, '(a, a, a)') &
            "ERROR: Unrecognized parameter '", &
            trim(unrecognized(1)), &
            "'. Run with --help for help."
        return
    end if


    ! t_end
    ! --------------

    call get_named_value_or_default(name='t_end', parsed=parsed, &
                                    default=DEFAULT_T_END, &
                                    value=settings%t_end, success=success)

    if (.not. success) then
        error_message = "ERROR: t_end is not a number."//NEW_LINE('h')//"&
                        &Run with --help for help."
        return
    end if


    ! delta_t
    ! --------------

    call get_named_value_or_default(name='delta_t', parsed=parsed, &
                                    default=DEFAULT_DELTA_T, &
                                    value=settings%delta_t, success=success)

    if (.not. success) then
        error_message = "ERROR: delta_t is not a number."//NEW_LINE('h')//"&
                        &Run with --help for help."
        return
    end if

end subroutine

end module Settings