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
    ! Interface of the function f and its derivative
    !
    ! Inputs:
    ! --------
    !
    ! v : value of the independent variable
    !
    ! x, t : value of parameters
    !
    ! Outputs:
    ! -------
    !
    ! Returns: value of f or its derivative.
    !
    real(dp) function func_interface(v, x, t)
        use types, only: dp
        implicit none
        real(dp), intent(in) :: v, x, t
    end function
end interface

contains

!
! Approximate root of the equation
!
!   f = 0
!
! Inputs:
! --------
!
! v_start : the starting value for v for the root finding algorithm.
!
! func : function f.
!
! derivative : function f'.
!
! x, t : value of parameters passed to f and f'
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
function approximate_root(v_start, func, derivative, &
                          x, t, tolerance, &
                          max_iterations, success) result(result)

    real(dp), intent(in) :: v_start, x, t, tolerance
    logical, intent(out) :: success
    integer, intent(in) :: max_iterations
    procedure(func_interface) :: func, derivative
    real(dp) :: result, dv, derivative_value
    integer :: i
    result = v_start
    success = .false.

    do i = 1, max_iterations
        derivative_value = derivative(v=result, x=x, t=t)

        if (abs(derivative_value) > .0_dp ) then
            dv = func(v=result, x=x, t=t) / derivative_value
        else
            ! Can't divide by zero
            return
        end if

        if (.not. ieee_is_finite(dv) .or. ieee_is_nan(dv)) then
            ! dv is infinite or is not a number.
            ! This can be a consequence of division of large number by a very small number,
            ! which makes the result fall outside the range of the floating point data type
            return
        end if

        result = result - dv

        if (abs(dv) < tolerance) then
            ! The answer is within our tolerance
            success = .true.
            return
        end if
    end do
end function

end module NewtonRaphson