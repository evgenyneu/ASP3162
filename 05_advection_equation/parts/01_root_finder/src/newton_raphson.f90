!
! Approximating a single root of f(x) = 0 using Newton-Raphson method.
!
module NewtonRaphson
use Types, only: dp
use, intrinsic :: ieee_arithmetic, only: ieee_is_finite, ieee_is_nan
implicit none
private
public :: approximate_root

interface
    !
    ! Interface of the function f(x) and its derivative
    !
    ! Inputs:
    ! --------
    !
    ! x : value of independent variable
    !
    ! Outputs:
    ! -------
    !
    ! Returns: value of f(x) or its derivative.
    !
    real(dp) function func_interface(x)
        use types, only: dp
        implicit none
        real(dp), intent(in) :: x
    end function
end interface

contains

!
! Approximate root of the equation
!
!   f(x) = 0
!
! Inputs:
! --------
!
! x_start : the starting value for x for the root finding algorithm.
!
! func : function f(x).
!
! derivative : function f'(x).
!
! tolerance : convergence tolerance for Newton-Raphson method.
!
! max_iterations : the maximum number of iterations of the Newton-Raphson method.
!
! Outputs:
! -------
!
! success : .true. if algorithm converged to a solution.
!
! Returns: approximation of the root of equation f(x) = 0.
!
function approximate_root(x_start, func, derivative, tolerance, &
                          max_iterations, success) result(result)

    real(dp), intent(in) :: x_start, tolerance
    logical, intent(out) :: success
    integer, intent(in) :: max_iterations
    procedure(func_interface) :: func, derivative
    real(dp) :: result, dx, derivative_value
    integer :: i
    result = x_start
    success = .false.

    do i = 1, max_iterations
        derivative_value = derivative(result)

        if (abs(derivative_value) > .0_dp ) then
            dx = func(result) / derivative_value
        else
            ! Can't divide by zero
            return
        end if

        if (.not. ieee_is_finite(dx) .or. ieee_is_nan(dx)) then
            ! dx is infinite or is not a number.
            ! This can be a consequence of division of large number by a very small number,
            ! which makes the result fall outside the range of the floating point data type
            return
        end if

        result = result - dx

        if (abs(dx) < tolerance) then
            ! The answer is within our tolerance
            success = .true.
            return
        end if
    end do
end function

end module NewtonRaphson