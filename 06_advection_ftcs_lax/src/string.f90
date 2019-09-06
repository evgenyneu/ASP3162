!
! Functions that help to work with strings
!
module String
use Types, only: dp
implicit none
private
public :: string_starts_with, string_is_empty, string_to_number

interface string_to_number
    module procedure string_to_real_dp, string_to_integer
end interface

contains

!
! Check if a string starts with a given substring
!
! Inputs:
! --------
!
! str : a string.
!
! substring : a substring.
!
! Outputs:
! -------
!
! Returns: .true. if `str` starts with `substring`.
!
function string_starts_with(str, substring) result(result)
    character(len=*), intent(in) :: str, substring
    logical :: result

    result = index(str, substring) == 1
end function


!
! Check if a string is empty (zero length or contains spaces)
!
! Inputs:
! --------
!
! str : a string.
!
! Outputs:
! -------
!
! Returns: .true. if `str` is empty
!
function string_is_empty(str) result(result)
    character(len=*), intent(in) :: str
    logical :: result

    result = len(trim(str)) == 0
end function


!
! Convert a string to a real double precision number
!
! Inputs:
! --------
!
! str : a string
!
! Outputs:
! -------
!
! success : .true. if conversion was successful.
!
! number: the number converted from `str`
!
subroutine string_to_real_dp(str, number, success)
    character(len=*), intent(in) :: str
    real(dp), intent(out) :: number
    logical, intent(out) :: success
    integer :: iostat

    read(str, *, iostat = iostat) number
    success = iostat == 0
end subroutine

!
! Convert a string to an integer number
!
! Inputs:
! --------
!
! str : a string
!
! Outputs:
! -------
!
! success : .true. if conversion was successful.
!
! number: the number converted from `str`
!
subroutine string_to_integer(str, number, success)
    character(len=*), intent(in) :: str
    integer, intent(out) :: number
    logical, intent(out) :: success
    integer :: iostat

    read(str, *, iostat = iostat) number
    success = iostat == 0
end subroutine

end module String