module OutputTest
use AssertsTest, only: assert_true
use Output, only: print_output
use Types, only: dp
use FileUtils, only: file_exists, delete_file
use AssertsTest, only: assert_true, assert_approx, assert_equal
implicit none
private
public output_test_all

contains

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


subroutine output_test_all(failures)
    integer, intent(inout) :: failures

    call print_output_test(failures)
end

end module OutputTest
