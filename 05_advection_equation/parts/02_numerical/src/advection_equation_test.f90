module AdvectionEquationTest
use Types, only: dp
use AssertsTest, only: assert_true, assert_approx, assert_equal
use Constants, only: pi
use, intrinsic :: ieee_arithmetic, only: ieee_is_nan

use AdvectionEquation, only: solve_equation, print_data, &
    solve_and_create_output, read_settings_solve_and_create_output, &
    write_to_file

use Settings, only: program_settings
use FileUtils, only: file_exists, delete_file
implicit none
private
public advection_equation_test_all

contains

subroutine solve_eqn_test(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: options
    real(dp), allocatable :: solution(:,:)
    real(dp), allocatable :: x_points(:), t_points(:)

    options%x_start = -pi/2
    options%x_end = pi/2
    options%nx = 600
    options%t_start = 0
    options%t_end = 1.4_dp
    options%nt = 280

    call solve_equation(options, solution, x_points, t_points)

    call assert_true(.true., __FILE__, __LINE__, failures)

    ! x_points
    ! ----------

    call assert_approx(x_points(1), -1.57079_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(x_points(2), -1.56555_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(x_points(600), 1.57079_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    ! t_points
    ! ----------

    call assert_approx(t_points(1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(t_points(2), 0.501792e-2_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(t_points(280), 1.4_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    ! solution
    ! ----------

    call assert_approx(solution(1, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(300, 1), 0.99999_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(600, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(1, 200), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(300, 142), -55477.776052_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_true(ieee_is_nan(solution(300, 200)), __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(600, 200), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    ! call assert_approx(data(1, 100), 0.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    ! call assert_approx(data(10, 100), 50.61869_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    ! call assert_approx(data(20, 100), 0.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)

    ! call assert_approx(errors(1, 1), 0.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    ! call assert_approx(errors(10, 1), 0.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    ! call assert_approx(errors(20, 1), 0.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)

    ! call assert_approx(errors(1, 10), 0.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    ! call assert_approx(errors(10, 10), 0.65785847e-2_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    ! call assert_approx(errors(10, 50), .27244811e-1_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    ! call assert_approx(errors(20, 10), 0.0_dp, 1e-5_dp, __FILE__, __LINE__, failures)
end

! subroutine print_data_test(failures)
!     integer, intent(inout) :: failures
!     real(dp) :: data(3,3), value(4)
!     real(dp) :: x_points(3), t_points(3)
!     character(len=:), allocatable :: output
!     integer, parameter :: unit=15

!     data = reshape((/ 1, 2, 3, 4, 5, 6, 7, 8, 9 /), shape(data))
!     x_points = [1.1_dp, 1.2_dp, 1.3_dp]
!     t_points = [0.1_dp, 0.2_dp, 0.3_dp]

!     call print_data(data, x_points, t_points, output)

!     ! Verify the data
!     ! ----------

!     call write_to_file(output, "test_data")

!     open (unit=unit, file="test_data", status='old',    &
!         access='sequential', form='formatted', action='read' )

!     read (unit, *) value
!     call assert_approx(value(1), 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(value(2), 1.1_dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(value(3), 1.2_dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(value(4), 1.3_dp, 1e-5_dp, __FILE__, __LINE__, failures)

!     read (unit, *) value
!     call assert_approx(value(1), 0.1_dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(value(2), 1._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(value(3), 2._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(value(4), 3._dp, 1e-5_dp, __FILE__, __LINE__, failures)

!     read (unit, *) value
!     call assert_approx(value(1), 0.2_dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(value(2), 4._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(value(3), 5._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(value(4), 6._dp, 1e-5_dp, __FILE__, __LINE__, failures)

!     read (unit, *) value
!     call assert_approx(value(1), 0.3_dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(value(2), 7._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(value(3), 8._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(value(4), 9._dp, 1e-5_dp, __FILE__, __LINE__, failures)

!     close(unit=unit)

!     call delete_file("test_data")
! end

! subroutine solve_and_create_output_test(failures)
!     integer, intent(inout) :: failures
!     type(program_settings) :: options
!     real(dp) :: data(4)
!     integer, parameter :: unit=15

!     options%nx = 3
!     options%nt = 3
!     options%alpha = 0.25_dp
!     options%k = 2.28e-5
!     options%output_path = "test_output.txt"
!     options%errors_path = "test_errors.txt"

!     call solve_and_create_output(options)

!     call assert_true(file_exists("test_output.txt"), __FILE__, __LINE__, failures)
!     call assert_true(file_exists("test_errors.txt"), __FILE__, __LINE__, failures)

!     ! Check output file
!     ! ----------

!     open (unit=unit, file="test_output.txt", status='old',    &
!         access='sequential', form='formatted', action='read' )

!     read (unit, *) data
!     call assert_approx(data(1), 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(2), 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(3), 0.5_dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(4), 1._dp, 1e-5_dp, __FILE__, __LINE__, failures)

!     read (unit, *) data
!     call assert_approx(data(1), 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(2), 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(3), 100._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(4), 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)

!     read (unit, *) data
!     call assert_approx(data(1), 2741.22797_dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(2), 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(3), 50._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(4), 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)

!     read (unit, *) data
!     call assert_approx(data(1), 5482.455946_dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(2), 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(3), 25._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(4), 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)

!     close(unit=unit)


!     ! Check errors file
!     ! ----------

!     open (unit=unit, file="test_errors.txt", status='old',    &
!         access='sequential', form='formatted', action='read' )

!     read (unit, *) data
!     call assert_approx(data(1), 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(2), 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(3), 0.5_dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(4), 1._dp, 1e-5_dp, __FILE__, __LINE__, failures)

!     read (unit, *) data
!     call assert_approx(data(1), 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(2), 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(3), 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(4), 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)

!     read (unit, *) data
!     call assert_approx(data(1), 2741.22797_dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(2), 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(3), 3.9641485_dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(4), 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)

!     read (unit, *) data
!     call assert_approx(data(1), 5482.455946_dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(2), 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(3), 4.1212933_dp, 1e-5_dp, __FILE__, __LINE__, failures)
!     call assert_approx(data(4), 0._dp, 1e-5_dp, __FILE__, __LINE__, failures)

!     close(unit=unit)

!     call delete_file("test_output.txt")
!     call delete_file("test_errors.txt")
! end

! subroutine read_settings_solve_and_create_output_test(failures)
!     integer, intent(inout) :: failures

!     call read_settings_solve_and_create_output(.true.)
!     call assert_true(.true., __FILE__, __LINE__, failures)
! end


subroutine advection_equation_test_all(failures)
    integer, intent(inout) :: failures

    call solve_eqn_test(failures)

    ! call print_data_test(failures)

    ! call solve_and_create_output_test(failures)

    ! call read_settings_solve_and_create_output_test(failures)
end

end module AdvectionEquationTest
