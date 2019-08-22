!
! Parse command line arguments
!
module CommandLineArgs
use Types, only: dp
use string, only: string_starts_with, string_is_empty, string_to_number
implicit none
private
public ::   parse_command_line_arguments, get_positional_value, get_named_value, &
            ARGUMENT_MAX_LENGTH, allocate_parsed, parse_current_command_line_arguments, &
            get_named_value_or_default, has_flag, is_named, &
            unrecognized_named_args

! The maximum length of a single parameter
integer, parameter :: ARGUMENT_MAX_LENGTH = 1024 * 10

!
! Contains the parsed arguments, which are separated into three parts:
!
!  1. Positional arguments
!
!     Arguments without names, which are idenfitified on their position.
!     For example, the program "jpg_to_pdf" is called like this:
!
!       $ jpg_to_pdf possum.jpg possum.pdf --silent --compression=9
!
!     has two positional arguments: "possum.jpg" and "possum.pdf".
!
!  2. Named arguments
!
!     Arguments that have names and values, supplied as -NAME=value or --NAME=value. For example,
!
!       $ jpg_to_pdf possum.jpg possum.pdf --silent --compression=9
!
!     the program is called with a single named argument "compression" with value "9".
!
!  3. Flags
!
!     These are named arguments without values. For example,
!
!       $ jpg_to_pdf possum.jpg possum.pdf --silent --compression=9
!
!     has a single flag "silent".
!
type, public :: parsed_args
    ! Array contains the values of the positional arguments
    character(len=ARGUMENT_MAX_LENGTH), allocatable :: positional(:)

    ! Total number of positional arguments
    integer :: positional_count

    ! Array contains the names of the named arguments
    character(len=ARGUMENT_MAX_LENGTH), allocatable :: named_name(:)

    ! Array contains the values of the named arguments
    character(len=ARGUMENT_MAX_LENGTH), allocatable :: named_value(:)

    ! Total number of named arguments
    integer :: named_count
end type parsed_args

!
! Get the `value` of the positional argument as a number.
!
! For example, for program called as
!
!   $ compress 23.43 --quality=90
!
! the value of the first positional argument will be 23.23.
!
!
! Inputs:
! --------
!
! index : index of the positional argument (1 is first argument, 2 is second etc.)
!
! parsed : object containing the parsed command line arguments.
!
!
! Outputs:
! -------
!
! value : the value of the positional argument.
!
! success : .true. if the value was successfuly extracted from the command line arguments.
!
interface get_positional_value
    module procedure get_positional_value_real_dp, &
        get_positional_value_integer, get_positional_value_string
end interface

!
! Get the `value` of the named argument as a string or number.
!
! For example, for program called as
!
!   $ compress 23.43 --quality=90
!
! the value of the first the named argument 'quality' will be 23.23.
!
! Inputs:
! --------
!
! name : name of the named argument.
!
! parsed : object containing the parsed command line arguments.
!
!
! Outputs:
! -------
!
! value : the value of the positional argument.
!
! success : .true. if the value was successfully extracted from the command line arguments.
!
interface get_named_value
    module procedure get_named_value_string, get_named_value_real_dp, get_named_value_integer
end interface

!
! Get the `value` of the named argument as a string or number.
! If the named argument is not present, use the supplied `default` value instead.
!
! Inputs:
! --------
!
! name : name of the named argument.
!
! parsed : object containing the parsed command line arguments.
!
! default : default value that will be used if the argument is not present.
!
!
! Outputs:
! -------
!
! value : the value of the positional argument.
!
! success : .true. if the value was successfully extracted from the command line arguments.
!
interface get_named_value_or_default
    module procedure get_named_value_or_default_real_dp, get_named_value_or_default_integer
end interface



contains

!
! Allocates memeory for the object containing parsed arguments
!
! Inputs:
! --------
!
! size : the number of positional or named arguments (whichever is the largest)
!        that we are expecting to store in this object
!
! Outputs:
! -------
!
! parsed : parsed line arguments.
!
subroutine allocate_parsed(size, parsed)
    integer, intent(in) :: size
    type(parsed_args), intent(inout) :: parsed

    allocate(parsed%positional(size))
    allocate(parsed%named_name(size))
    allocate(parsed%named_value(size))
end subroutine

!
! Parses command line arguments that are supplied to the executable.
!
! Outputs:
! -------
!
! parsed : parsed line arguments.
!
subroutine parse_current_command_line_arguments(parsed)
    type(parsed_args), intent(out) :: parsed
    integer :: i
    integer :: count
    character(len=ARGUMENT_MAX_LENGTH) :: argument
    character(len=ARGUMENT_MAX_LENGTH), allocatable :: all_arguments(:)

    count = command_argument_count()
    allocate(all_arguments(count))

    do i = 1, count
        call get_command_argument(i, argument)
        all_arguments(i) = argument
    end do

    call parse_command_line_arguments(all_arguments, parsed)
end subroutine

!
! Parses command line arguments and separates them into three categories:
! positional, named and flags.
!
! Inputs:
! --------
!
! arguments : an array of command line arguments, which are strings without spaces
!             that come from `get_command_argument` function.
!
!             For example, if user called program `compress` with following arguments:
!
!               $ compress file.jpg --quality=23 -width = 15 --silent
!
!             the `arguments` array will contain elements:
!               ["file.jpg", "--quality=23", "-width", "=", "15", "--silent"]
!
! Outputs:
! -------
!
! parsed : parsed line arguments.
!
subroutine parse_command_line_arguments(arguments, parsed)
    character(len=*), intent(in) :: arguments(:)
    type(parsed_args), intent(out) :: parsed
    integer :: i
    integer :: name_start_index
    integer :: name_end_index
    integer :: advance_index
    character(len=ARGUMENT_MAX_LENGTH) :: argument, name, value

    parsed%positional_count = 0
    parsed%named_count = 0
    i = 0

    call allocate_parsed(size=size(arguments), parsed=parsed)

    argument_loop: do
        i = i + 1
        if (i > size(arguments)) exit argument_loop
        argument = arguments(i)

        if (is_named(argument)) then
            ! Named argument or a flag. Extract the name and value

            name_start_index = 2
            if (string_starts_with(argument, "--")) name_start_index = 3

            ! The `=` separates name from the value:
            name_end_index = index(argument, '=') - 1

            if (name_end_index == -1) then
                ! no '=' separator found
                name_end_index = len(argument)
            end if

            name = argument(name_start_index: name_end_index)
            if (string_is_empty(name)) cycle argument_loop

            ! Extract value of named argument
            call extract_value_from_arguments(arguments=arguments, start_index=i, &
                                              value=value, &
                                              advance_index=advance_index)

            i = i + advance_index

            parsed%named_count = parsed%named_count + 1
            parsed%named_name(parsed%named_count) = name
            parsed%named_value(parsed%named_count) = value
        else if (string_is_empty(argument)) then
            ! Argument is empty
        else
            ! Positional argument
            parsed%positional_count = parsed%positional_count + 1
            parsed%positional(parsed%positional_count) = argument
        end if
    end do argument_loop
end subroutine


!
! Extracts a value from a named argument, starting from `start_index` elements
! of the list of `arguments`.
!
! Example:
!
! There are three cases that we need to handle:
!
! Case 1:
! -------
!
! Suppose `arguments` is an array:
!
!  ["file.jpg", "--quality=23", "--silent"]
!
! and we need to extract the value of the `quality` command line argument.
!
! Then `extract_value_from_argument_at_index` will be called with `start_index=2'
! which corresponds to the `--quality=23` element of `arguments` array.
! The function will then search for separator `=` in `--quality=23`, and use the text `23`
! after `=` as the output `value` argument. This is a simple case.
!
! Case 2:
! -------
!
! More complicated case is when name and separator `=` are not located in the same element
! of `arguments`, for example:
!
!   ["file.jpg", "quality", "=23", "--silent"]
!
! This will happen when user used a space between quality and `=` in the command line:
!   $ compress file.jpg --quality =23  --silent.
!
! Here this function  will still be called with `start_index=2`, but
! will need to look at then next element and search for separator `=` and value.
!
! Case 3:
! -------
!
! The final case is when name, separator `=` and value are supplied in defferent
! elements of the `arguments` array.
!
! Inputs:
! --------
!
! arguments : an array of command line arguments.
!             See parse_command_line_arguments documentation for more info.
!
!
! start_index : an index of an element from `arguments` from which to start to extract the value.
!
! Outputs:
! -------
!
! value : the value of the named parameter. For example, for "--quantity=23",
!         the returned value will be "23". If no value is specified ("--silent"),
!         the returned `value` will be an empty string.
!
! advance_index : index of the element containing the value minus `start_index`.
!
!                 For example, if the value was specified in the same element as the name
!                 (Case 1), then `advance_index=0`.
!                 If the value is located in the next element (Case 2), then `advance_index=1`.
!                 For Case 3, `advance_index=2`.
!
subroutine extract_value_from_arguments(arguments, start_index, value, advance_index)
    character(len=*), intent(in) :: arguments(:)
    integer, intent(in) :: start_index
    character(len=*), intent(out) :: value
    integer, intent(out) :: advance_index
    integer :: i, value_separator_index
    character(len=ARGUMENT_MAX_LENGTH) :: argument
    value = ""
    advance_index = 0

    i = start_index - 1

    argument_loop: do
        i = i + 1
        if (i > size(arguments)) exit argument_loop
        argument = arguments(i)

        ! Look for the name/value separator
        value_separator_index = index(argument, '=')

        if (value_separator_index == 0) then ! Separator is not found
            if (i > start_index) then ! This is the second argument
                ! Name/value separator is not found in the second argument
                ! This means there is no value supplied for the argument
                exit argument_loop
            end if

            ! Separator is not found in the first argument, which also contains the name
            ! Check if separator is in the next argument
            cycle argument_loop
        else
            ! Separator is found

            if (i > start_index) then ! This is the second argument
                ! Separator is in the next argument - advance the index
                advance_index = advance_index + 1

                if (value_separator_index /= 1) then
                    ! The separator is not the first text in the second argument
                    ! This is not a well-formed name=value pair - exit
                    exit argument_loop
                end if
            end if

            ! Try extracting the value after the separator
            if (value_separator_index < len(argument)) then
                value = argument(value_separator_index + 1:)
            end if

            if (string_is_empty(value)) then
                ! Value is empty, look for the value in the next argument
                if (i == size(arguments)) then
                    ! There is no next argument, meaning the value is not supplied. Exit
                    exit argument_loop
                end if

                if (is_value(arguments(i+1))) value = arguments(i+1)

                ! The value is in the next argument - advance the index
                if (.not. string_is_empty(value)) advance_index = advance_index + 1
            end if

            ! Value extracted - return it
            exit argument_loop
        end if
    end do argument_loop
end subroutine

!
! Determine if the entire argument is a value
! An argument is a value unless it starts with `-`, `--`, or `=` characters.
!
! For example, "--color=23" is not value, but "23" is.
!
! Inputs:
! --------
!
! argument : a single command line argument.
!
!
! Outputs:
! -------
!
! Returns : .true. if an argument contains a value.
!
function is_value(argument) result(result)
    character(len=*), intent(in) :: argument
    logical :: result
    result = .false.

    if (string_starts_with(argument, "-") .or. string_starts_with(argument, "--")) then
        ! The argument contains another flag or named argument instead of the value. Exit.
        return
    end if

    if (string_starts_with(argument, "=")) then
        ! The argument contains name/value separator instead of the value. Exit.
        return
    end if

    result = .true.
end function


!
! Determines if a flag with a given name is present.
! A flag is a named argument without a value.
!
! For example, here we call a program with a flag 'help'
!
!   $ compress --help
!
! Inputs:
! --------
!
! name : name of the named argument.
!
! parsed : object containing the parsed command line arguments.
!
!
! Outputs:
! -------
!
! Returns : .true. if the flag is present.
!           Note that we return true even if the flag has a value.
!
function has_flag(name, parsed) result(result)
    character(len=*), intent(in) :: name
    type(parsed_args), intent(in) :: parsed
    logical :: result, success
    character(len=ARGUMENT_MAX_LENGTH) :: text_value

    call get_named_value_string(name=name, parsed=parsed, value=text_value, success=success)

    result = success
end function

! get_positional_value
! --------------------

subroutine get_positional_value_real_dp(index, parsed, value, success)
    integer, intent(in) :: index
    type(parsed_args), intent(in) :: parsed
    real(dp), intent(out) :: value
    logical, intent(out) :: success

    success = .true.

    if (index > parsed%positional_count .or. index < 0) then
        success = .false.
        return
    end if

    call string_to_number(parsed%positional(index), value, success)
end subroutine

subroutine get_positional_value_integer(index, parsed, value, success)
    integer, intent(in) :: index
    type(parsed_args), intent(in) :: parsed
    integer, intent(out) :: value
    logical, intent(out) :: success

    success = .true.

    if (index > parsed%positional_count .or. index < 0) then
        success = .false.
        return
    end if

    call string_to_number(parsed%positional(index), value, success)
end subroutine

subroutine get_positional_value_string(index, parsed, value, success)
    integer, intent(in) :: index
    type(parsed_args), intent(in) :: parsed
    character(len=*), intent(out) :: value
    logical, intent(out) :: success

    success = .true.

    if (index > parsed%positional_count .or. index < 0) then
        success = .false.
        return
    end if

    value = parsed%positional(index)
end subroutine



! get_named_value
! --------------------

subroutine get_named_value_string(name, parsed, value, success)
    character(len=*), intent(in) :: name
    type(parsed_args), intent(in) :: parsed
    character(len=*), intent(out) :: value
    logical, intent(out) :: success
    integer :: i

    success = .false.

    named_arg_loop: do i = 1, parsed%named_count
        if (parsed%named_name(i) == name) then
            value = parsed%named_value(i)
            success = .true.
            exit named_arg_loop
        end if
    end do named_arg_loop
end subroutine


subroutine get_named_value_real_dp(name, parsed, value, success)
    character(len=*), intent(in) :: name
    type(parsed_args), intent(in) :: parsed
    real(dp), intent(out) :: value
    logical, intent(out) :: success
    character(len=ARGUMENT_MAX_LENGTH) :: text_value

    success = .true.

    call get_named_value_string(name=name, parsed=parsed, value=text_value, success=success)
    if (.not. success) return
    call string_to_number(text_value, value, success)
end subroutine


subroutine get_named_value_integer(name, parsed, value, success)
    character(len=*), intent(in) :: name
    type(parsed_args), intent(in) :: parsed
    integer, intent(out) :: value
    logical, intent(out) :: success
    character(len=ARGUMENT_MAX_LENGTH) :: text_value

    success = .true.

    call get_named_value_string(name=name, parsed=parsed, value=text_value, success=success)
    if (.not. success) return
    call string_to_number(text_value, value, success)
end subroutine


! get_named_value_or_default
! ---------------

subroutine get_named_value_or_default_real_dp(name, parsed, default, value, success)
    character(len=*), intent(in) :: name
    type(parsed_args), intent(in) :: parsed
    real(dp), intent(in) :: default
    real(dp), intent(out) :: value
    logical, intent(out) :: success
    character(len=ARGUMENT_MAX_LENGTH) :: text_value

    success = .true.

    call get_named_value_string(name=name, parsed=parsed, value=text_value, success=success)

    if (.not. success) then
        ! Named argument is not present. Use the default value.
        value = default
        success = .true.
        return
    end if

    call string_to_number(text_value, value, success)
end subroutine


subroutine get_named_value_or_default_integer(name, parsed, default, value, success)
    character(len=*), intent(in) :: name
    type(parsed_args), intent(in) :: parsed
    integer, intent(in) :: default
    integer, intent(out) :: value
    logical, intent(out) :: success
    character(len=ARGUMENT_MAX_LENGTH) :: text_value

    success = .true.

    call get_named_value_string(name=name, parsed=parsed, value=text_value, success=success)

    if (.not. success) then
        ! Named argument is not present. Use the default value.
        value = default
        success = .true.
        return
    end if

    call string_to_number(text_value, value, success)
end subroutine



!
! Deternimes if the argument is a named argument.
! For example "--help" is a named argument, and "file.jpg" is not.
! This functino is needed to distigush named arguments that start with '-'
! from negative numbers, like -3.
!
! Inputs:
! --------
!
! str : a string containing a command line argument
!
!
! Outputs:
! -------
!
! Returns : .true. if an argument contains a named argument
!
function is_named(str) result(result)
    character(len=*), intent(in) :: str
    logical :: result
    integer :: flag_name_start_index
    integer :: char_index


    if (string_starts_with(str, "-") .or. string_starts_with(str, "--")) then
        if (string_starts_with(str, "-")) flag_name_start_index = 2
        if (string_starts_with(str, "--")) flag_name_start_index = 3

        if (len(str) <= flag_name_start_index) then
            result = .false.
            return
        end if

        char_index = ICHAR(str(flag_name_start_index:flag_name_start_index))

        if (char_index >= 49 .and. char_index <=57) then
            ! This is a number 0 - 9
            result = .false.
            return
        end if

        result = .true.
    else
        result = .false.
    end if
end function

!
! Check if there are parsed named arguments that are not expected.
!
! Inputs:
! --------
!
! valid : array of valid named arguments.
!
! parsed : parsed arguments.
!
!             See parse_command_line_arguments documentation for more info.
!
! Outputs:
! -------
!
! unrecognized : array of parsed arguments that are not
!                present in `valid` array.
!
! count : size of `unrecognized` array.
!
subroutine unrecognized_named_args(valid, parsed, unrecognized, count)
    character(len=*), intent(in) :: valid(:)
    type(parsed_args), intent(in) :: parsed
    character(len=ARGUMENT_MAX_LENGTH), allocatable, intent(out) :: unrecognized(:)
    integer, intent(out) :: count
    integer :: i, j
    character(len=ARGUMENT_MAX_LENGTH) :: parsed_name

    count = 0

    allocate(unrecognized(parsed%named_count))

    named_loop: do i = 1, parsed%named_count
        parsed_name = parsed%named_name(i)

        do j = 1, size(valid)
            if (parsed_name == valid(j)) cycle named_loop
        end do

        ! Have not found parsed_name in the list of valid names
        count = count + 1
        unrecognized(count) = parsed_name
    end do named_loop
end subroutine

end module CommandLineArgs