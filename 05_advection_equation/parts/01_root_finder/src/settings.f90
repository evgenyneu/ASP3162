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

    ! The number of time points in the grid
    integer :: nt

    ! The starting value for v for the root finding algorithm.
    real(dp) :: root_finder_v_start

    ! Convergence tolerance for Newton-Raphson method.
    real(dp) :: root_finder_tolerance

    ! The maximum number of iterations of the Newton-Raphson method.
    integer :: root_finder_max_iterations
end type program_settings

! Help message to be shown
character(len=1024), parameter :: HELP_MESSAGE = NEW_LINE('h')//"&
    &This program solves equation"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &  cos(x - v * t) - v = 0"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &for different values of x and t"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &Usage:&
    &"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    & ./build/main OUTPUT [--x_start=-1.5] [--x_end=1.5] &
    &[--nx=100] [--t_start=0] [--t_end=1.4] &
    &[--nt=8] [--v_start=0.5] [--v_start=0.5] &
    &[--tolerance=1.0e-5] [--max_iterations=1000]"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    OUTPUT : path to the output data file"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --x_start=NUMBER : the smallest x value,"//NEW_LINE('h')//"&
    &                  Default: -1.5."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --x_end=NUMBER : the largest x value,"//NEW_LINE('h')//"&
    &                  Default: 1.5."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --nx=NUMBER : number of x points in the grid,"//NEW_LINE('h')//"&
    &                  Default: 100."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --t_start=NUMBER : the smallest t value,"//NEW_LINE('h')//"&
    &                  Default: 0."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --t_end=NUMBER : the largest t value,"//NEW_LINE('h')//"&
    &                  Default: 1.4."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --nt=NUMBER : number of t points in the grid,"//NEW_LINE('h')//"&
    &                  Default: 8."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --v_start=NUMBER : The starting value for v for the root finding &
    &algorithm.,"//NEW_LINE('h')//"&
    &                  Default: 0.5."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --tolerance=NUMBER : tolerance for Newton-Raphson &
    &method.,"//NEW_LINE('h')//"&
    &                  Default: 1e-5."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --max_iterations=NUMBER : maximum number of &
    &iterations for Newton-Raphson method"//NEW_LINE('h')//"&
    &                  Default: 1000."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --help  : show this message."//NEW_LINE('h')

! Default values for the settings
! ------

integer, parameter :: DEFAULT_NX = 21
integer, parameter :: DEFAULT_NT = 300
real(dp), parameter :: DEFAULT_ALPHA = 0.25
real(dp), parameter :: DEFAULT_K = 2.28e-5

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
    character(len=ARGUMENT_MAX_LENGTH) :: valid_args(4)

    error_message = ""

    ! help
    ! --------------

    if (has_flag(name='help', parsed=parsed) .or. &
        has_flag(name='h', parsed=parsed)) then

        error_message = HELP_MESSAGE
        return
    end if

    ! ! Check unrecognized parameters
    ! ! ----------

    ! valid_args(1) = "nx"
    ! valid_args(2) = "nt"
    ! valid_args(3) = "alpha"
    ! valid_args(4) = "k"

    ! call unrecognized_named_args(valid=valid_args, parsed=parsed, &
    !     unrecognized=unrecognized, count=unrecognized_count)

    ! if (unrecognized_count > 0) then
    !     write(error_message, '(a, a, a)') &
    !         "ERROR: Unrecognized parameter '", &
    !         trim(unrecognized(1)), &
    !         "'. Run with --help for help."
    !     return
    ! end if

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

    ! ! ERRORS
    ! ! --------------

    ! call get_positional_value(index=2, parsed=parsed, &
    !                           value=settings%errors_path, &
    !                           success=success)

    ! if (.not. success) then
    !     error_message = "ERROR: ERRORS parameter is missing."//NEW_LINE('h')//"&
    !                     &Run with --help for help."
    !     return
    ! end if

    ! ! nx
    ! ! --------------

    ! call get_named_value_or_default(name='nx', parsed=parsed, &
    !                                 default=DEFAULT_NX, &
    !                                 value=settings%nx, success=success)

    ! if (.not. success) then
    !     error_message = "ERROR: nx is not a number."//NEW_LINE('h')//"&
    !                     &Run with --help for help."
    !     return
    ! end if

    ! ! nt
    ! ! --------------

    ! call get_named_value_or_default(name='nt', parsed=parsed, &
    !                                 default=DEFAULT_NT, &
    !                                 value=settings%nt, success=success)

    ! if (.not. success) then
    !     error_message = "ERROR: nt is not a number."//NEW_LINE('h')//"&
    !                     &Run with --help for help."
    !     return
    ! end if

    ! ! alpha
    ! ! --------------

    ! call get_named_value_or_default(name='alpha', parsed=parsed, &
    !                                 default=DEFAULT_ALPHA, &
    !                                 value=settings%alpha, success=success)

    ! if (.not. success) then
    !     error_message = "ERROR: alpha is not a number."//NEW_LINE('h')//"&
    !                     &Run with --help for help."
    !     return
    ! end if

    ! ! k
    ! ! --------------

    ! call get_named_value_or_default(name='k', parsed=parsed, &
    !                                 default=DEFAULT_K, &
    !                                 value=settings%k, success=success)

    ! if (.not. success) then
    !     error_message = "ERROR: k is not a number."//NEW_LINE('h')//"&
    !                     &Run with --help for help."
    !     return
    ! end if

end subroutine

end module Settings