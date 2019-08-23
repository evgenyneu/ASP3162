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

    ! Path to the errors file that will be filled with
    ! the errors data
    character(len=4096) :: errors_path

    ! The number of x point in the grid
    integer :: nx

    ! The number of time points in the grid
    integer :: nt

    ! The alpha parameter of the numerical solution
    ! of the heat equation
    !
    ! alpha = k dt / dx^2
    !
    ! Values greater than 0.5 produce numerically unstable solutions
    ! for forward differencing method.
    !
    real(dp) :: alpha

    ! Thermal diffusivity of the rod in m^2 s^{-1} units
    real(dp) :: k
end type program_settings

! Help message to be shown
character(len=1024), parameter :: HELP_MESSAGE = NEW_LINE('h')//"&
    &This program solves the heat equation"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &  dT/dt = k d^2T/dx^2"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &with initial condition"//NEW_LINE('h')//"&
    &  T(x,0) = 100 sin(pi x / L)"//NEW_LINE('h')//"&
    &and boundary conditions"//NEW_LINE('h')//"&
    &   T(0,t) = T(L,t) = 0,"//NEW_LINE('h')//"&
    & where L = 1 m."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &Usage:&
    &"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    & ./build/main OUTPUT ERRORS [--nx=20] [--nt=300] &
    &[--alpha=0.2] [--k=2.28e-5]"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    OUTPUT : path to the output data file"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    ERRORS : path to the output errors file"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --nx=NUMBER : number of x points in the grid,"//NEW_LINE('h')//"&
    &                  including the points on the edges."//NEW_LINE('h')//"&
    &                  Default: 21."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --nt=NUMBER : number of t points in the grid,"//NEW_LINE('h')//"&
    &                  Default: 300."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --alpha=NUMBER : The alpha parameter of the numerical"//NEW_LINE('h')//"&
    &     solution of the heat equation. Values larger than"//NEW_LINE('h')//"&
    &     0.5 results in unstable solutions. Default: 0.25."//NEW_LINE('h')//"&
    &"//NEW_LINE('h')//"&
    &    --k=NUMBER : Thermal diffusivity of the rod in m^2 s^{-1}&
    & units."//NEW_LINE('h')//"&
    &                 Default: 2.28e-5."//NEW_LINE('h')//"&
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

    ! Check unrecognized parameters
    ! ----------

    valid_args(1) = "nx"
    valid_args(2) = "nt"
    valid_args(3) = "alpha"
    valid_args(4) = "k"

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

    if (parsed%positional_count /= 2) then
        error_message = "ERROR: OUTPUT and ERRORS parameters are missing."&
            //NEW_LINE('h')//" &
            &Run with --help for help."
        return
    end if

    call get_positional_value(index=1, parsed=parsed, &
                              value=settings%output_path, &
                              success=success)

    if (.not. success) then
        error_message = "ERROR: OUTPUT parameter is missing."//NEW_LINE('h')//"&
                        &Run with --help for help."
        return
    end if

    ! ERRORS
    ! --------------

    call get_positional_value(index=2, parsed=parsed, &
                              value=settings%errors_path, &
                              success=success)

    if (.not. success) then
        error_message = "ERROR: ERRORS parameter is missing."//NEW_LINE('h')//"&
                        &Run with --help for help."
        return
    end if

    ! nx
    ! --------------

    call get_named_value_or_default(name='nx', parsed=parsed, &
                                    default=DEFAULT_NX, &
                                    value=settings%nx, success=success)

    if (.not. success) then
        error_message = "ERROR: nx is not a number."//NEW_LINE('h')//"&
                        &Run with --help for help."
        return
    end if

    ! nt
    ! --------------

    call get_named_value_or_default(name='nt', parsed=parsed, &
                                    default=DEFAULT_NT, &
                                    value=settings%nt, success=success)

    if (.not. success) then
        error_message = "ERROR: nt is not a number."//NEW_LINE('h')//"&
                        &Run with --help for help."
        return
    end if

    ! alpha
    ! --------------

    call get_named_value_or_default(name='alpha', parsed=parsed, &
                                    default=DEFAULT_ALPHA, &
                                    value=settings%alpha, success=success)

    if (.not. success) then
        error_message = "ERROR: alpha is not a number."//NEW_LINE('h')//"&
                        &Run with --help for help."
        return
    end if

    ! k
    ! --------------

    call get_named_value_or_default(name='k', parsed=parsed, &
                                    default=DEFAULT_K, &
                                    value=settings%k, success=success)

    if (.not. success) then
        error_message = "ERROR: k is not a number."//NEW_LINE('h')//"&
                        &Run with --help for help."
        return
    end if

end subroutine

end module Settings