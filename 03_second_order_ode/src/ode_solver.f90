!
! Solves the ODE:
!
!   x''(t) + x(t) = 0.
!
module OdeSolver
use Types, only: dp
use FloatUtils, only: can_convert_real_to_int
use Settings, only: program_settings
implicit none
private
public :: solve_ode, print_solution, solve_and_print

!
! Data for the ODE solution
!
type, public :: ode_solution
    ! array of t values
    real(dp), allocatable :: t_values(:)

    ! array of x values
    real(dp), allocatable :: x_values(:)

    ! array of exact values
    real(dp), allocatable :: x_values_exact(:)

    ! errors
    real(dp), allocatable :: abs_errors(:)

    ! the number of elements in `t_values` and `x_values` arrays
    integer :: size
end type ode_solution

contains

!
! Solves the ODE
!
!   x''(t) + x(t) = 0.
!
! Inputs:
! -------
!
! t_end : final value of t coordinate
!
! delta_t : size of the timestep
!
!
! Outputs:
! -------
!
! solution : solution to the ODE
!
! success : .true. if the ODE was solved successfully
!
! error_message : contains the error message, if any errors occurred
!
subroutine solve_ode(options, solution, success, error_message)
    type(program_settings), intent(in) :: options
    type(ode_solution), intent(out) :: solution
    logical, intent(out) :: success
    character(len=*), intent(out) :: error_message
    real(dp) :: t_end, delta_t
    integer :: i
    real(dp) :: size_real, t_start

    t_end = options%t_end
    delta_t = options%delta_t

    t_start = 0._dp

    if (.not. (abs(delta_t) > .0_dp )) then
        success = .false.
        error_message = "can not divide by zero"
        return
    end if

    size_real = (t_end - t_start) / delta_t

    call can_convert_real_to_int(float=size_real, &
        success=success, error_message=error_message)

    if (.not. success) return
    solution%size = ceiling(size_real)
    allocate(solution%t_values(solution%size))
    allocate(solution%x_values(solution%size))
    allocate(solution%x_values_exact(solution%size))
    allocate(solution%abs_errors(solution%size))

    solution%t_values(1) = t_start
    solution%t_values(2) = t_start + delta_t

    solution%x_values(1) = 1._dp
    solution%x_values(2) = 1._dp - 0.5_dp * delta_t**2

    do i = 3, solution%size
        solution%t_values(i) = t_start + delta_t * (i - 1)

        solution%x_values(i) = -solution%x_values(i - 2) + &
            solution%x_values(i - 1) * (2 - delta_t**2)
    end do

    solution%x_values_exact = cos(solution%t_values)
    solution%abs_errors = abs(solution%x_values - solution%x_values_exact)
end subroutine


!
! Solves the ODE and prints result to o
!
! Inputs:
! -------
!
! solution : solution to the ODE
!
!
! Outputs:
! -------
!
! output : output text
!
subroutine print_solution(solution, output)
    type(ode_solution), intent(in) :: solution
    character(len=:), allocatable, intent(out) :: output
    character(len=:), allocatable :: tmp_arr
    integer :: i
    character(len=1024) :: buffer
    integer :: allocated = 2024

    allocate(character(len=allocated) :: output)
    output = ""

    write(buffer, "(3(a, ', '), a)") "t", "x", "exact", "abs_error"
    output = output // trim(buffer) // new_line('A')

    do i = 1, solution%size
        write(buffer, "(3(ES24.17, ','), ES24.17)") solution%t_values(i), &
            solution%x_values(i), solution%x_values_exact(i), &
            solution%abs_errors(i)

        output = output // trim(buffer) // new_line('A')

        ! Resize the string array if two small
        if (len(output) > allocated / 2) then
            allocated = 2 * allocated
            allocate(character(len=allocated) :: tmp_arr)
            tmp_arr = output
            deallocate(output)
            call move_alloc(tmp_arr, output)
        end if
    end do
end subroutine

subroutine solve_and_print(options, silent)
    type(program_settings), intent(in) :: options
    logical, intent(in) :: silent
    type(ode_solution) :: solution
    logical :: success
    character(len=1024) :: error_message
    character(len=:), allocatable :: output

    call solve_ode(options=options, &
                   solution=solution, success=success, &
                   error_message=error_message)

    if (.not. success) then
        if (.not. silent) then
            write (0, *) error_message
            call exit(40)
        end if
    end if

    call print_solution(solution=solution, output=output)

    if (.not. silent) then
        print *, output
    end if
end subroutine

end module OdeSolver