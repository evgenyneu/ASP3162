!
! Solves the ODE:
!
!   x''(t) + x(t) = 0.
!
module OdeSolver
use Types, only: dp, biggest_i2
use, intrinsic :: ieee_arithmetic, only: ieee_is_finite, ieee_is_nan
implicit none
private
public :: solve_ode

!
! Data for the ODE solution
!
type, public :: ode_solution
    ! arrau of t values
    real(dp), allocatable :: t_values(:)

    ! arrau of x values
    real(dp), allocatable :: x_values(:)

    ! the nubmer of elements in `t_values` and `x_values` arrays
    integer :: size
end type ode_solution

contains

!
! Solves the ODE
!
!   x''(t) + x(t) = 0.
!
! Outputs:
! -------
!
! t_start : intial value of t coordinate
!
! t_end : final value of t coordinate
!
! delta_t : size of the time step
!
!
! Outputs:
! -------
!
! solution : solution to the ODE
!
! success : .true. if the ODE was solved succesfully
!
! error_message : contains the error message, if any errors occured
!
subroutine solve_ode(t_start, t_end, delta_t, solution, success, error_message)
    real(dp), intent(in) :: t_start, t_end, delta_t
    type(ode_solution), intent(out) :: solution
    logical, intent(out) :: success
    character(len=*), intent(out) :: error_message
    integer :: size

    if (abs(delta_t) > .0_dp ) then
        ! size_real = (t_end - t_start) / delta_t

        size = real_to_integer(float=(t_end - t_start) / delta_t, &
                success=success, error_message)

        if (.not. success) return

        ! if (.not. ieee_is_finite(size_real) .or. ieee_is_nan(size_real)) then
        !     success = .false.
        !     error_message = "float arithmetic overflow when calculating"&
        !                    &"the number of points"
        !     return
        ! end if

        ! if (abs(size_real) > real(biggest_i2, dp)) then
        !     success = .false.
        !     error_message = "integer arithmetic overflow when calculating"&
        !                    &"the number of points"
        !     return
        ! else
        !     size = floor(size_real)
        ! end if
    end if

    if (1.e3_dp > real(biggest_i2, dp)) then
        print *, 'hey overflow'
    else
        size = floor(2.2_dp)
    end if

    ! if (.not. ieee_is_finite(size) .or. ieee_is_nan(size)) then
    !     success = .false.
    !     error_message = "arithmetic overflow when calculating"&
    !                    &"the number of points"
    !     return
    ! end if

end subroutine

end module OdeSolver