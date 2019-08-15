!
! Helper functions to deal with floating point numbers
!
module FloatUtils
use Types, only: dp, biggest_i4
use, intrinsic :: ieee_arithmetic, only: ieee_is_finite, ieee_is_nan
implicit none
private
public :: can_convert_real_to_int


contains

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