!
! Helper functions to deal with floating point numbers
!
module FloatUtils
use Types, only: dp, biggest_i4
use, intrinsic :: ieee_arithmetic, only: ieee_is_finite, ieee_is_nan
implicit none
private
public :: can_convert_real_to_int, linspace


contains

!
! Generates evenly spaced numbers from `from` to `to` (inclusive).
!
! Inputs:
! -------
!
! from, to : the lower and upper boundaries of the numbers to generate
!
! Outputs:
! -------
!
! array : Array of evenly spaced numbers
!
subroutine linspace(from, to, array)
    real(dp), intent(in) :: from, to
    real(dp), intent(out) :: array(:)
    real(dp) :: range
    integer :: n, i
    n = size(array)
    range = to - from

    if (n == 0) return

    if (n == 1) then
        array(1) = from
        return
    end if

    do i=1, n
        array(i) = from + range * (i - 1) / (n - 1)
    end do
end subroutine


!
! Check if the real number can be converted to integer. We check if the real
! number is finite and ensure there is no overflow
! (i.e. check the real number is not larger than the largest integer).
!
! Inputs:
! -------
!
! float : float number to check
!
!
! Outputs:
! -------
!
! success : .true. if the real number can be converted to integer
!
! error_message : contains the error message, if any errors occurred
!
subroutine can_convert_real_to_int(float, success, error_message)
    real(dp), intent(in) :: float
    logical, intent(out) :: success
    character(len=*), intent(out) :: error_message

    if (.not. ieee_is_finite(float) .or. ieee_is_nan(float)) then
        success = .false.
        error_message = "float arithmetic overflow"
        return
    end if

    if (abs(float) > real(biggest_i4, dp)) then
        success = .false.
        write(error_message, '(a, x, ES23.15, x, a)') &
            "Can not convert", float, "to integer"
        return
    end if

    success = .true.
end subroutine

end module FloatUtils
