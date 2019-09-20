module GridTest
use Grid, only: set_grid
use Types, only: dp
use Settings, only: program_settings
use AssertsTest, only: assert_true, assert_approx, assert_equal
implicit none
private
public grid_test_all

contains

subroutine set_grid_test(failures)
    integer, intent(inout) :: failures
    real(dp), allocatable :: solution(:, :, :)
    real(dp), allocatable :: x_points(:), t_points(:)
    type(program_settings) :: options
    integer :: nt_allocated

    options%x_start = 10
    options%x_end = 20
    options%nx = 10
    options%state_vector_dimension = 1

    call set_grid(options=options, solution=solution, &
                  x_points=x_points, t_points=t_points, &
                  nt_allocated=nt_allocated)


    ! x_points
    ! ----------

    call assert_equal(size(x_points), 10, __FILE__, __LINE__, failures)

    call assert_approx(x_points(1), 10.5_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(x_points(2), 11.5_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(x_points(10), 19.5_dp, 1e-5_dp, __FILE__, &
        __LINE__, failures)


    ! t_points
    ! ----------

    call assert_equal(size(t_points), 13, __FILE__, __LINE__, failures)

    call assert_true(all(abs(t_points) < 1.e-10_dp), __FILE__, &
        __LINE__, failures)


    ! Solution
    ! --------

    call assert_equal(size(solution, 1), 1, __FILE__, __LINE__, failures)
    call assert_equal(size(solution, 2), 12, __FILE__, __LINE__, failures)
    call assert_equal(size(solution, 3), 13, __FILE__, __LINE__, failures)

    call assert_true(all(abs(solution) < 1.e-10_dp), __FILE__, &
        __LINE__, failures)
end


subroutine grid_test_all(failures)
    integer, intent(inout) :: failures

    call set_grid_test(failures)
end

end module GridTest
