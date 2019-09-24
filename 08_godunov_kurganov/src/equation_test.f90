module EquationTest
use Types, only: dp
use AssertsTest, only: assert_true, assert_approx, assert_equal
use Constants, only: pi
use, intrinsic :: ieee_arithmetic, only: ieee_is_nan

use Equation, only: solve_equation, &
    solve_and_create_output, read_settings_solve_and_create_output, &
    remove_ghost_cells, resize_arrays

use Settings, only: program_settings
use FileUtils, only: file_exists, delete_file
implicit none
private
public equation_test_all

contains


subroutine remove_ghost_cells_test(failures)
    integer, intent(inout) :: failures
    real(dp), allocatable :: state_vectors(:, :, :)

    allocate(state_vectors(1, 4, 3))

    state_vectors = reshape([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], &
                            shape(state_vectors))



    call remove_ghost_cells(state_vectors)


    ! State vectors size
    ! --------

    call assert_equal(size(state_vectors, 1), 1, __FILE__, __LINE__, failures)
    call assert_equal(size(state_vectors, 2), 2, __FILE__, __LINE__, failures)
    call assert_equal(size(state_vectors, 3), 3, __FILE__, __LINE__, failures)

    call assert_approx(state_vectors(1, 1, 1), 2._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(state_vectors(1, 2, 1), 3._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(state_vectors(1, 1, 2), 6._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(state_vectors(1, 2, 2), 7._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(state_vectors(1, 1, 3), 10._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(state_vectors(1, 2, 3), 11._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)
end


subroutine resize_arrays_test(failures)
    integer, intent(inout) :: failures
    real(dp), allocatable :: state_vectors(:, :, :)
    real(dp), allocatable :: t_points(:)

    allocate(state_vectors(1, 2, 3))

    state_vectors = reshape([1, 2, 3, 4, 5, 6], &
                            shape(state_vectors))

    allocate(t_points(3))
    t_points = [1.1_dp, 1.2_dp, 1.3_dp]

    call resize_arrays(new_size=5, keep_elements=3, &
                       state_vectors=state_vectors, t_points=t_points)


    ! State vectors size
    ! --------

    call assert_equal(size(state_vectors, 1), 1, __FILE__, __LINE__, failures)
    call assert_equal(size(state_vectors, 2), 2, __FILE__, __LINE__, failures)
    call assert_equal(size(state_vectors, 3), 5, __FILE__, __LINE__, failures)

    call assert_approx(state_vectors(1, 1, 1), 1._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(state_vectors(1, 2, 1), 2._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(state_vectors(1, 1, 2), 3._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(state_vectors(1, 2, 2), 4._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(state_vectors(1, 1, 3), 5._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(state_vectors(1, 2, 3), 6._dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)


    ! Ensure the added elements are zero
    ! ----------

    call assert_true(all(abs(state_vectors(:, :, 4)) < 1.e-10_dp), __FILE__, &
        __LINE__, failures)

    call assert_true(all(abs(state_vectors(:, :, 5)) < 1.e-10_dp), __FILE__, &
        __LINE__, failures)

end


subroutine solve_eqn_godunovs_test__square(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: options
    real(dp), allocatable :: primitive_vectors(:, :, :)
    real(dp), allocatable :: x_points(:), t_points(:)

    options%method = 'godunov'
    options%initial_conditions = 'square'
    options%x_start = 0
    options%x_end = 1
    options%nx = 100
    options%t_start = 0
    options%t_end = 1
    options%courant_factor = 0.5_dp

    call solve_equation(options=options, primitive_vectors=primitive_vectors, &
                        x_points=x_points, t_points=t_points)

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

    call assert_equal(size(t_points), 200, __FILE__, __LINE__, failures)

    call assert_approx(t_points(1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(t_points(2), 0.005_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(t_points(199), 0.9994054169217213_dp, 1e-10_dp, &
        __FILE__, __LINE__, failures)

    call assert_approx(t_points(200), 1.0047891945143_dp, 1e-10_dp, &
        __FILE__, __LINE__, failures)


    ! Primitive vectors size
    ! --------

    call assert_equal(size(primitive_vectors, 1), 1, &
                      __FILE__, __LINE__, failures)

    call assert_equal(size(primitive_vectors, 2), 100, &
                      __FILE__, __LINE__, failures)

    call assert_equal(size(primitive_vectors, 3), 200, &
                      __FILE__, __LINE__, failures)

    ! Initial condition
    ! ----------

    call assert_approx(primitive_vectors(1, 1, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(primitive_vectors(1, 2, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(primitive_vectors(1, 25, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(primitive_vectors(1, 26, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(primitive_vectors(1, 27, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(primitive_vectors(1, 75, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(primitive_vectors(1, 76, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(primitive_vectors(1, 100, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)


    ! Ensure there are no NaN values
    call assert_true(all(.not. ieee_is_nan(primitive_vectors)), &
        __FILE__, __LINE__, failures)


    ! Primitive vectors
    ! ----------

    call assert_approx(primitive_vectors(1, 1, 100), 0.122216125834515_dp, &
        1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(primitive_vectors(1, 50, 100), 0.509752081141659_dp, &
        1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(primitive_vectors(1, 100, 100), 0.673395555247192_dp, &
        1e-10_dp, __FILE__, __LINE__, failures)
end


subroutine solve_eqn_godunovs_test__sine(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: options
    real(dp), allocatable :: primitive_vectors(:, :, :)
    real(dp), allocatable :: x_points(:), t_points(:)

    options%method = 'godunov'
    options%initial_conditions = 'sine'
    options%x_start = 0
    options%x_end = 1
    options%nx = 100
    options%t_start = 0
    options%t_end = 1
    options%courant_factor = 0.5_dp

    call solve_equation(options=options,&
                        primitive_vectors=primitive_vectors, &
                        x_points=x_points, &
                        t_points=t_points)

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

    call assert_equal(size(t_points), 150, __FILE__, __LINE__, failures)

    call assert_approx(t_points(1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(t_points(2), 0.500246841618572e-2_dp, 1e-10_dp, &
        __FILE__, __LINE__, failures)

    call assert_approx(t_points(149), 0.99691854507207378_dp, 1e-10_dp, &
        __FILE__, __LINE__, failures)

    call assert_approx(t_points(150), 1.0085650816438056_dp, 1e-10_dp, &
        __FILE__, __LINE__, failures)


    ! Primitive vectors size
    ! --------

    call assert_equal(size(primitive_vectors, 1), 1, &
                      __FILE__, __LINE__, failures)

    call assert_equal(size(primitive_vectors, 2), 100, &
                      __FILE__, __LINE__, failures)

    call assert_equal(size(primitive_vectors, 3), 150, &
                      __FILE__, __LINE__, failures)

    ! Initial condition
    ! ----------

    call assert_approx(primitive_vectors(1, 1, 1), 0.31410759078128292e-1_dp, &
        1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(primitive_vectors(1, 2, 1), 0.94108313318514311e-1_dp, &
        1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(primitive_vectors(1, 25, 1), 0.99950656036573160_dp, &
        1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(primitive_vectors(1, 26, 1), 0.99950656036573160_dp, &
        1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(primitive_vectors(1, 27, 1), 0.99556196460308000_dp, &
        1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(primitive_vectors(1, 75, 1), -0.99950656036573160_dp, &
        1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(primitive_vectors(1, 76, 1), -0.99950656036573160_dp, &
        1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(primitive_vectors(1, 100, 1), -0.31410759078127473e-1_dp, &
        1e-10_dp, __FILE__, __LINE__, failures)


    ! Ensure there are no NaN values
    call assert_true(all(.not. ieee_is_nan(primitive_vectors)), &
        __FILE__, __LINE__, failures)


    ! Primitive vectors
    ! ----------

    call assert_approx(primitive_vectors(1, 1, 100), &
        0.16882533672516742e-1_dp, 1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(primitive_vectors(1, 50, 100), &
        0.68687187909049474_dp, 1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(primitive_vectors(1, 100, 100), &
        -0.16882533672516513e-1_dp, 1e-10_dp, __FILE__, __LINE__, failures)
end


subroutine solve_eqn_kurganov_test__square(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: options
    real(dp), allocatable :: primitive_vectors(:, :, :)
    real(dp), allocatable :: x_points(:), t_points(:)

    options%method = 'kurganov'
    options%initial_conditions = 'square'
    options%x_start = 0
    options%x_end = 1
    options%nx = 100
    options%t_start = 0
    options%t_end = 1
    options%courant_factor = 0.5_dp

    call solve_equation(options=options, &
                        primitive_vectors=primitive_vectors, &
                        x_points=x_points, &
                        t_points=t_points)

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

    call assert_equal(size(t_points), 199, __FILE__, __LINE__, failures)

    call assert_approx(t_points(1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(t_points(2), 0.005_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(t_points(198), 0.9958435737879909_dp, 1e-10_dp, &
        __FILE__, __LINE__, failures)

    call assert_approx(t_points(199), 1.0012649185992473_dp, 1e-10_dp, &
        __FILE__, __LINE__, failures)


    ! Primitive vectors size
    ! --------

    call assert_equal(size(primitive_vectors, 1), 1, &
                      __FILE__, __LINE__, failures)

    call assert_equal(size(primitive_vectors, 2), 100, &
                      __FILE__, __LINE__, failures)

    call assert_equal(size(primitive_vectors, 3), 199, &
                      __FILE__, __LINE__, failures)

    ! Initial condition
    ! ----------

    call assert_approx(primitive_vectors(1, 1, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(primitive_vectors(1, 2, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(primitive_vectors(1, 25, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(primitive_vectors(1, 26, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(primitive_vectors(1, 27, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(primitive_vectors(1, 75, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(primitive_vectors(1, 76, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(primitive_vectors(1, 100, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)


    ! Ensure there are no NaN values
    call assert_true(all(.not. ieee_is_nan(primitive_vectors)), &
        __FILE__, __LINE__, failures)


    ! Primitive vectors
    ! ----------

    call assert_approx(primitive_vectors(1, 1, 100), 0.22193347102695274_dp, &
        1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(primitive_vectors(1, 50, 100), 0.50626805029687283_dp, &
        1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(primitive_vectors(1, 100, 100), 0.64565582723970583_dp, &
        1e-10_dp, __FILE__, __LINE__, failures)
end


subroutine solve_and_create_output_test(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: options
    integer :: unit
    integer :: nx, nt, state_vector_dimension
    real(dp) :: x_points(100), t_points(200), primitive_vectors(1, 100, 200)

    options%output_path = "test_output.dat"

    options%method = 'godunov'
    options%initial_conditions = 'square'
    options%x_start = 0
    options%x_end = 1
    options%nx = 100
    options%t_start = 0
    options%t_end = 1
    options%courant_factor = 0.5_dp

    call solve_and_create_output(options)

    call assert_true(file_exists("test_output.dat"), __FILE__, __LINE__, failures)

    ! Check output file
    ! ----------

    open(newunit=unit, file="test_output.dat", form='unformatted', &
        status='old', action='read' )

    read (unit) nx
    call assert_equal(nx, 100, __FILE__, __LINE__, failures)

    read (unit) nt
    call assert_equal(nt, 200, __FILE__, __LINE__, failures)

    read (unit) state_vector_dimension
    call assert_equal(state_vector_dimension, 1, __FILE__, __LINE__, failures)


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

    call assert_approx(t_points(199), 0.9994054169217213_dp, &
        1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(t_points(200), 1.0047891945143437_dp, &
        1e-10_dp, __FILE__, __LINE__, failures)


    ! Primitive condition
    ! ----------

    read (unit) primitive_vectors

    call assert_approx(primitive_vectors(1, 1, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(primitive_vectors(1, 2, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(primitive_vectors(1, 25, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(primitive_vectors(1, 26, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(primitive_vectors(1, 27, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(primitive_vectors(1, 75, 1), 1.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(primitive_vectors(1, 76, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(primitive_vectors(1, 100, 1), 0.0_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)


    ! Primitive vectors
    ! ----------

    call assert_approx(primitive_vectors(1, 1, 100), 0.122216125834515_dp, &
        1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(primitive_vectors(1, 50, 100), 0.509752081141659_dp, &
        1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(primitive_vectors(1, 100, 100), 0.673395555247192_dp, &
        1e-10_dp, __FILE__, __LINE__, failures)

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


subroutine equation_test_all(failures)
    integer, intent(inout) :: failures

    call remove_ghost_cells_test(failures)
    call resize_arrays_test(failures)

    call solve_eqn_godunovs_test__square(failures)
    call solve_eqn_godunovs_test__sine(failures)

    call solve_eqn_kurganov_test__square(failures)

    call solve_and_create_output_test(failures)

    call read_settings_solve_and_create_output_test(failures)
end

end module EquationTest
