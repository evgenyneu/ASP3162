module AdvectionEquationTest
use Types, only: dp
use AssertsTest, only: assert_true, assert_approx, assert_equal
use Constants, only: pi
use, intrinsic :: ieee_arithmetic, only: ieee_is_nan

use AdvectionEquation, only: solve_equation, print_output, &
    solve_and_create_output, read_settings_solve_and_create_output

use Settings, only: program_settings
use FileUtils, only: file_exists, delete_file
implicit none
private
public advection_equation_test_all

contains


subroutine solve_eqn_ftcs_test(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: options
    real(dp), allocatable :: solution(:,:)
    real(dp), allocatable :: x_points(:), t_points(:)

    options%method = 'ftcs'
    options%x_start = 0
    options%x_end = 1
    options%nx = 101
    options%t_start = 0
    options%t_end = 1
    options%velocity = 1.0_dp

    call solve_equation(options, solution, x_points, t_points)

    call assert_true(.true., __FILE__, __LINE__, failures)

    ! x_points
    ! ----------

    call assert_equal(size(x_points), 101, __FILE__, __LINE__, failures)

    call assert_approx(x_points(1), 0._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(x_points(2), 0.01_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(x_points(101), 1._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    ! t_points
    ! ----------

    call assert_equal(size(t_points), 201, __FILE__, __LINE__, failures)

    call assert_approx(t_points(1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(t_points(2), 0.005_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(t_points(200), 0.995_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(t_points(201), 1._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    ! Solution size
    ! --------

    call assert_equal(size(solution, 1), 101, __FILE__, __LINE__, failures)
    call assert_equal(size(solution, 2), 201, __FILE__, __LINE__, failures)

    ! Initial condition
    ! ----------

    call assert_approx(solution(1, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(1, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(2, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(26, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(27, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(28, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(76, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(77, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(101, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)


    ! Ensure there are no NaN values
    if (any(ieee_is_nan(solution))) then
        call assert_true(.true., __FILE__, __LINE__, failures)
    end if
end

subroutine solve_eqn_lax_test(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: options
    real(dp), allocatable :: solution(:,:)
    real(dp), allocatable :: x_points(:), t_points(:)

    options%method = 'lax'
    options%x_start = 0
    options%x_end = 1
    options%nx = 101
    options%t_start = 0
    options%t_end = 1
    options%velocity = 1.0_dp

    call solve_equation(options, solution, x_points, t_points)

    call assert_true(.true., __FILE__, __LINE__, failures)

    ! x_points
    ! ----------

    call assert_equal(size(x_points), 101, __FILE__, __LINE__, failures)

    call assert_approx(x_points(1), 0._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(x_points(2), 0.01_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(x_points(101), 1._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    ! t_points
    ! ----------

    call assert_equal(size(t_points), 201, __FILE__, __LINE__, failures)

    call assert_approx(t_points(1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(t_points(2), 0.005_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(t_points(200), 0.995_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(t_points(201), 1._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    ! Solution size
    ! --------

    call assert_equal(size(solution, 1), 101, __FILE__, __LINE__, failures)
    call assert_equal(size(solution, 2), 201, __FILE__, __LINE__, failures)

    ! Initial condition
    ! ----------

    call assert_approx(solution(1, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(1, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(2, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(26, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(27, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(28, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(76, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(77, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(101, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)


    ! Ensure there are no NaN values
    if (any(ieee_is_nan(solution))) then
        call assert_true(.true., __FILE__, __LINE__, failures)
    end if
end

subroutine print_output_test(failures)
    integer, intent(inout) :: failures
    real(dp) :: solution(2, 3)
    real(dp) :: solution_read(2, 3)
    real(dp) :: x_points(2), t_points(3)
    real(dp) :: x_points_read(2), t_points_read(3)
    integer, parameter :: unit=20
    integer :: nx, nt

    solution = reshape((/ 1, 2, 3, 4, 5, 6 /), shape(solution))
    x_points = [1.1_dp, 1.2_dp]
    t_points = [0.1_dp, 0.2_dp, 0.3_dp]

    call print_output(filename="test_output.dat", solution=solution, &
                      x_points=x_points, t_points=t_points)

    call assert_true(file_exists("test_output.dat"), __FILE__, __LINE__, failures)

    open(unit=unit, file="test_output.dat", form='unformatted', &
        status='old', action='read' )

    read (unit) nx
    call assert_equal(nx, 2, __FILE__, __LINE__, failures)

    read (unit) nt
    call assert_equal(nt, 3, __FILE__, __LINE__, failures)

    read (unit) x_points_read
    call assert_approx(x_points_read(1), 1.1_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(x_points_read(2), 1.2_dp, 1e-5_dp, __FILE__, __LINE__, failures)

    read (unit) t_points_read
    call assert_approx(t_points_read(1), 0.1_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(t_points_read(2), 0.2_dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(t_points_read(3), 0.3_dp, 1e-5_dp, __FILE__, __LINE__, failures)

    read (unit) solution_read
    call assert_approx(solution_read(1,1), 1._dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(solution_read(2,1), 2._dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(solution_read(1,2), 3._dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(solution_read(2,2), 4._dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(solution_read(1,3), 5._dp, 1e-5_dp, __FILE__, __LINE__, failures)
    call assert_approx(solution_read(2,3), 6._dp, 1e-5_dp, __FILE__, __LINE__, failures)

    close(unit=unit)

    call delete_file("test_output.dat")
end

subroutine solve_and_create_output_test(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: options
    integer, parameter :: unit=15
    integer :: nx, nt
    real(dp) :: x_points(101), t_points(201), solution(101, 201)

    options%output_path = "test_output.dat"

    options%method = 'ftcs'
    options%x_start = 0
    options%x_end = 1
    options%nx = 101
    options%t_start = 0
    options%t_end = 1
    options%velocity = 1.0_dp

    call solve_and_create_output(options)

    call assert_true(file_exists("test_output.dat"), __FILE__, __LINE__, failures)

    ! Check output file
    ! ----------

    open(unit=unit, file="test_output.dat", form='unformatted', &
        status='old', action='read' )

    read (unit) nx
    call assert_equal(nx, 101, __FILE__, __LINE__, failures)

    read (unit) nt
    call assert_equal(nt, 201, __FILE__, __LINE__, failures)


    ! x_points
    ! ----------

    read (unit) x_points

    call assert_approx(x_points(1), 0._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(x_points(2), 0.01_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(x_points(101), 1._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    ! t_points
    ! ----------

    read (unit) t_points

    call assert_approx(t_points(1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(t_points(2), 0.005_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(t_points(200), 0.995_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(t_points(201), 1._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    ! Initial condition
    ! ----------

    read (unit) solution

    call assert_approx(solution(1, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(1, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(2, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(26, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(27, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(28, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(76, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(77, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(101, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    close(unit=unit)

    call delete_file("test_output.dat")
end


! read_settings_find_roots_and_print_output_test
! ---------

subroutine read_settings_solve_and_create_output_test(failures)
    integer, intent(inout) :: failures

    call read_settings_solve_and_create_output(silent=.true.)

    call assert_true(.true., __FILE__, __LINE__, failures)
end


subroutine advection_equation_test_all(failures)
    integer, intent(inout) :: failures

    call solve_eqn_ftcs_test(failures)
    call solve_eqn_lax_test(failures)
    call print_output_test(failures)
    call solve_and_create_output_test(failures)
    call read_settings_solve_and_create_output_test(failures)
end

end module AdvectionEquationTest
