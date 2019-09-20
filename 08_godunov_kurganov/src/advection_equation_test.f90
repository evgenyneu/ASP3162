module AdvectionEquationTest
use Types, only: dp
use AssertsTest, only: assert_true, assert_approx, assert_equal
use Constants, only: pi
use, intrinsic :: ieee_arithmetic, only: ieee_is_nan

use AdvectionEquation, only: solve_equation, &
    solve_and_create_output, read_settings_solve_and_create_output, &
    remove_ghost_cells

use Settings, only: program_settings
use FileUtils, only: file_exists, delete_file
implicit none
private
public advection_equation_test_all

contains


subroutine remove_ghost_cells_test(failures)
    integer, intent(inout) :: failures
    real(dp), allocatable :: solution(:, :)

    allocate(solution(4, 3))

    solution = reshape((/ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 /), &
                       shape(solution))

    call remove_ghost_cells(solution)


    ! Solution size
    ! --------

    call assert_equal(size(solution, 1), 2, __FILE__, __LINE__, failures)
    call assert_equal(size(solution, 2), 3, __FILE__, __LINE__, failures)

    call assert_approx(solution(1,1), 2._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(2,1), 3._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(1,2), 6._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(2,2), 7._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(1,3), 10._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(2,3), 11._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)
end


subroutine solve_eqn_ftcs_test(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: options
    real(dp), allocatable :: solution(:,:)
    real(dp), allocatable :: x_points(:), t_points(:)

    options%method = 'ftcs'
    options%initial_conditions = 'square'
    options%x_start = 0
    options%x_end = 1
    options%nx = 100
    options%t_start = 0
    options%t_end = 1
    options%velocity = 1.0_dp
    options%courant_factor = 0.5_dp

    call solve_equation(options, solution, x_points, t_points)

    ! x_points
    ! ----------

    call assert_equal(size(x_points), 100, __FILE__, __LINE__, failures)

    call assert_approx(x_points(1), 0.005_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(x_points(2), 0.015_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(x_points(100), 0.995_dp, 1e-5_dp, __FILE__, &
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

    call assert_equal(size(solution, 1), 100, __FILE__, __LINE__, failures)
    call assert_equal(size(solution, 2), 201, __FILE__, __LINE__, failures)

    ! Initial condition
    ! ----------

    call assert_approx(solution(1, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(2, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(25, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(26, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(27, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(75, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(76, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(100, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)


    ! Ensure there are no NaN values
    call assert_true(all(.not. ieee_is_nan(solution)), &
        __FILE__, __LINE__, failures)


    ! Solution
    ! ----------

    call assert_approx(solution(30, 20), -1.057714_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(50, 20), 1._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(70, 20), 0.72453224_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)
end

subroutine solve_eqn_lax_test(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: options
    real(dp), allocatable :: solution(:,:)
    real(dp), allocatable :: x_points(:), t_points(:)

    options%method = 'lax'
    options%initial_conditions = 'square'
    options%x_start = 0
    options%x_end = 1
    options%nx = 100
    options%t_start = 0
    options%t_end = 1
    options%velocity = 1.0_dp
    options%courant_factor = 0.5_dp

    call solve_equation(options, solution, x_points, t_points)

    ! x_points
    ! ----------

    call assert_equal(size(x_points), 100, __FILE__, __LINE__, failures)

    call assert_approx(x_points(1), 0.005_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(x_points(2), 0.015_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(x_points(100), 0.995_dp, 1e-5_dp, __FILE__, &
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

    call assert_equal(size(solution, 1), 100, __FILE__, __LINE__, failures)
    call assert_equal(size(solution, 2), 201, __FILE__, __LINE__, failures)

    ! Initial condition
    ! ----------

    call assert_approx(solution(1, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(2, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(25, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(26, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(27, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(75, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(76, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(100, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)


    ! Ensure there are no NaN values
    call assert_true(all(.not. ieee_is_nan(solution)), &
        __FILE__, __LINE__, failures)


    ! Solution
    ! ----------

    call assert_approx(solution(1, 100), 0.995249_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(50, 100), 0.3447980e-2_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(100, 100), 0.99655201_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)
end


subroutine solve_eqn_upwind_test(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: options
    real(dp), allocatable :: solution(:,:)
    real(dp), allocatable :: x_points(:), t_points(:)

    options%method = 'upwind'
    options%initial_conditions = 'square'
    options%x_start = 0
    options%x_end = 1
    options%nx = 100
    options%t_start = 0
    options%t_end = 1
    options%velocity = 1.0_dp
    options%courant_factor = 0.5_dp

    call solve_equation(options, solution, x_points, t_points)

    ! x_points
    ! ----------

    call assert_equal(size(x_points), 100, __FILE__, __LINE__, failures)

    call assert_approx(x_points(1), 0.005_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(x_points(2), 0.015_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(x_points(100), 0.995_dp, 1e-5_dp, __FILE__, &
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

    call assert_equal(size(solution, 1), 100, __FILE__, __LINE__, failures)
    call assert_equal(size(solution, 2), 201, __FILE__, __LINE__, failures)

    ! Initial condition
    ! ----------

    call assert_approx(solution(1, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(2, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(25, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(26, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(27, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(75, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(76, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(100, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)


    ! Ensure there are no NaN values
    call assert_true(all(.not. ieee_is_nan(solution)), &
        __FILE__, __LINE__, failures)


    ! Solution
    ! ----------

    call assert_approx(solution(1, 100), 0.999999532028_dp, 1e-10_dp, &
        __FILE__, __LINE__, failures)

    call assert_approx(solution(50, 100), 0.27665724745e-6_dp, 1e-10_dp, &
        __FILE__, __LINE__, failures)

    call assert_approx(solution(100, 100), 0.999999723342_dp, 1e-10_dp, &
        __FILE__, __LINE__, failures)
end


subroutine solve_eqn_lax_wendroff_test(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: options
    real(dp), allocatable :: solution(:,:)
    real(dp), allocatable :: x_points(:), t_points(:)

    options%method = 'lax-wendroff'
    options%initial_conditions = 'square'
    options%x_start = 0
    options%x_end = 1
    options%nx = 100
    options%t_start = 0
    options%t_end = 1
    options%velocity = 1.0_dp
    options%courant_factor = 0.5_dp

    call solve_equation(options, solution, x_points, t_points)

    ! x_points
    ! ----------

    call assert_equal(size(x_points), 100, __FILE__, __LINE__, failures)

    call assert_approx(x_points(1), 0.005_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(x_points(2), 0.015_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(x_points(100), 0.995_dp, 1e-5_dp, __FILE__, &
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

    call assert_equal(size(solution, 1), 100, __FILE__, __LINE__, failures)
    call assert_equal(size(solution, 2), 201, __FILE__, __LINE__, failures)

    ! Initial condition
    ! ----------

    call assert_approx(solution(1, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(2, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(25, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(26, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(27, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(75, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(76, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(100, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)


    ! Ensure there are no NaN values
    call assert_true(all(.not. ieee_is_nan(solution)), &
        __FILE__, __LINE__, failures)


    ! Solution
    ! ----------

    call assert_approx(solution(1, 100), 0.99700430617_dp, 1e-10_dp, &
        __FILE__, __LINE__, failures)

    call assert_approx(solution(50, 100), 0.184237044915e-2_dp, 1e-10_dp, &
        __FILE__, __LINE__, failures)

    call assert_approx(solution(100, 100), 0.99815762955_dp, 1e-10_dp, &
        __FILE__, __LINE__, failures)
end


subroutine solve_and_create_output_test(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: options
    integer, parameter :: unit=15
    integer :: nx, nt
    real(dp) :: x_points(100), t_points(201), solution(100, 201)

    options%output_path = "test_output.dat"

    options%method = 'ftcs'
    options%initial_conditions = 'square'
    options%x_start = 0
    options%x_end = 1
    options%nx = 100
    options%t_start = 0
    options%t_end = 1
    options%velocity = 1.0_dp
    options%courant_factor = 0.5_dp

    call solve_and_create_output(options)

    call assert_true(file_exists("test_output.dat"), __FILE__, __LINE__, failures)

    ! Check output file
    ! ----------

    open(unit=unit, file="test_output.dat", form='unformatted', &
        status='old', action='read' )

    read (unit) nx
    call assert_equal(nx, 100, __FILE__, __LINE__, failures)

    read (unit) nt
    call assert_equal(nt, 201, __FILE__, __LINE__, failures)


    ! x_points
    ! ----------

    read (unit) x_points

    call assert_approx(x_points(1), 0.005_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(x_points(2), 0.015_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(x_points(100), 0.995_dp, 1e-5_dp, __FILE__, &
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

    call assert_approx(solution(2, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(25, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(26, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(27, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(75, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(76, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(100, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)


    ! Solution
    ! ----------

    call assert_approx(solution(30, 20), -1.057714_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(50, 20), 1._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(70, 20), 0.72453224_dp, 1e-5_dp, __FILE__, &
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

    call remove_ghost_cells_test(failures)
    call solve_eqn_ftcs_test(failures)
    call solve_eqn_lax_test(failures)
    call solve_eqn_upwind_test(failures)
    call solve_eqn_lax_wendroff_test(failures)
    call solve_and_create_output_test(failures)
    call read_settings_solve_and_create_output_test(failures)
end

end module AdvectionEquationTest
