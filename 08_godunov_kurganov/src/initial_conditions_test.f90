module InitialConditionsTest
use Types, only: dp
use AssertsTest, only: assert_true, assert_approx, assert_equal
use InitialConditions, only: set_initial
implicit none
private
public init_test_all

contains

subroutine set_initial_test__square(failures)
    integer, intent(inout) :: failures
    real(dp) :: x_points(9)
    real(dp) :: solution(1, 11, 3)

    solution = -42._dp

    x_points = [0._dp, 0.1_dp, 0.24_dp, 0.25_dp, 0.26_dp, 0.74_dp, &
                0.75_dp, 0.76_dp, 1._dp]

    call set_initial(type="square", x_points=x_points, solution=solution)

    ! ghost
    call assert_approx(solution(1, 1, 1), -42._dp, 1e-10_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(1, 2, 1), 0._dp, 1e-10_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(1, 3, 1), 0._dp, 1e-10_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(1, 4, 1), 0._dp, 1e-10_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(1, 5, 1), 0._dp, 1e-10_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(1, 6, 1), 1._dp, 1e-10_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(1, 7, 1), 1._dp, 1e-10_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(1, 8, 1), 1._dp, 1e-10_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(1, 9, 1), 0._dp, 1e-10_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(1, 10, 1), 0._dp, 1e-10_dp, __FILE__, &
        __LINE__, failures)

    ! ghost
    call assert_approx(solution(1, 11, 1), -42._dp, 1e-10_dp, __FILE__, &
        __LINE__, failures)
end


subroutine set_initial_test__sine(failures)
    integer, intent(inout) :: failures
    real(dp) :: x_points(9)
    real(dp) :: solution(1, 11, 3)

    solution = -42._dp

    x_points = [0._dp, 0.1_dp, 0.24_dp, 0.25_dp, 0.26_dp, 0.74_dp, &
                0.75_dp, 0.76_dp, 1._dp]

    call set_initial(type="sine", x_points=x_points, solution=solution)

    ! ghost
    call assert_approx(solution(1, 1, 1), -42._dp, 1e-10_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(1, 2, 1), 0._dp, 1e-10_dp, __FILE__, &
        __LINE__, failures)

    call assert_approx(solution(1, 3, 1), 0.587785252292_dp, 1e-10_dp, &
                       __FILE__, __LINE__, failures)

    call assert_approx(solution(1, 4, 1), 0.998026728428_dp, 1e-10_dp, &
                       __FILE__, __LINE__, failures)

    call assert_approx(solution(1, 5, 1), 1._dp, 1e-10_dp, &
                      __FILE__, __LINE__, failures)

    call assert_approx(solution(1, 6, 1), 0.99802672842_dp, 1e-10_dp, &
                      __FILE__, __LINE__, failures)

    call assert_approx(solution(1, 7, 1), -0.99802672842_dp, 1e-10_dp, &
                      __FILE__, __LINE__, failures)

    call assert_approx(solution(1, 8, 1), -1._dp, 1e-10_dp, &
                      __FILE__, __LINE__, failures)

    call assert_approx(solution(1, 9, 1), -0.99802672842_dp, 1e-10_dp, &
                      __FILE__, __LINE__, failures)

    call assert_approx(solution(1, 10, 1), -0.24492935982947064E-015_dp, &
                      1e-7_dp, __FILE__, __LINE__, failures)

    ! ghost
    call assert_approx(solution(1, 11, 1), -42._dp, 1e-10_dp, __FILE__, &
        __LINE__, failures)
end


subroutine init_test_all(failures)
    integer, intent(inout) :: failures

    call set_initial_test__square(failures)
    call set_initial_test__sine(failures)
end

end module InitialConditionsTest
