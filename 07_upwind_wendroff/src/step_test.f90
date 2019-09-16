module StepTest
use Types, only: dp
use AssertsTest, only: assert_true, assert_approx, assert_equal
use Step, only: step_ftcs, step_lax, step_upwind, step_lax_wendroff
implicit none
private
public step_test_all

contains

subroutine step_ftcs_test(failures)
    integer, intent(inout) :: failures
    real(dp) :: solution(5, 3)

    solution = -42
    solution(:, 1) = [1.1_dp, 2._dp, 3.9_dp, 4._dp, 5._dp]
    call step_ftcs(5, 2, 0.01_dp, 0.05_dp, 1._dp, solution)


    ! First time index
    ! --------

    call assert_approx(solution(1, 1), 1.1_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(2, 1), 2._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(3, 1), 3.9_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(4, 1), 4._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(5, 1), 5._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Secon time index
    ! --------

    ! Ghost is untouched
    call assert_approx(solution(1, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(2, 2), -5._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(3, 2), -1.1_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(4, 2), 1.25_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Ghost is untouched
    call assert_approx(solution(5, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Third time index is untouched
    call assert_true(all((solution(:, 3) + 42._dp) < 1.e-10_dp), &
                     __FILE__, __LINE__, failures)
end

subroutine step_lax_test(failures)
    integer, intent(inout) :: failures
    real(dp) :: solution(5, 3)

    solution = -42
    solution(:, 1) = [1.1_dp, 2._dp, 3.9_dp, 4._dp, 5._dp]
    call step_lax(5, 2, 0.01_dp, 0.05_dp, 1._dp, solution)


    ! First time index
    ! --------

    call assert_approx(solution(1, 1), 1.1_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(2, 1), 2._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(3, 1), 3.9_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(4, 1), 4._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(5, 1), 5._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Secon time index
    ! --------

    ! Ghost is untouched
    call assert_approx(solution(1, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(2, 2), -4.5_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(3, 2), -2._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(4, 2), 1.7_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Ghost is untouched
    call assert_approx(solution(5, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Third time index is untouched
    call assert_true(all((solution(:, 3) + 42._dp) < 1.e-10_dp), &
                     __FILE__, __LINE__, failures)
end

subroutine step_upwind_test(failures)
    integer, intent(inout) :: failures
    real(dp) :: solution(5, 3)

    solution = -42
    solution(:, 1) = [1.1_dp, 2._dp, 3.9_dp, 4._dp, 5._dp]
    call step_upwind(5, 2, 0.01_dp, 0.05_dp, 1._dp, solution)


    ! First time index
    ! --------

    call assert_approx(solution(1, 1), 1.1_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(2, 1), 2._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(3, 1), 3.9_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(4, 1), 4._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(5, 1), 5._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Secon time index
    ! --------

    ! Ghost is untouched
    call assert_approx(solution(1, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(2, 2), -2.5_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(3, 2), -5.6_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(4, 2), 3.5_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Ghost is untouched
    call assert_approx(solution(5, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Third time index is untouched
    call assert_true(all((solution(:, 3) + 42._dp) < 1.e-10_dp), &
                     __FILE__, __LINE__, failures)
end

subroutine step_lax_wendroff_test(failures)
    integer, intent(inout) :: failures
    real(dp) :: solution(5, 3)

    solution = -42
    solution(:, 1) = [1.1_dp, 2._dp, 3.9_dp, 4._dp, 5._dp]
    call step_lax_wendroff(5, 2, 0.01_dp, 0.05_dp, 1._dp, solution)


    ! First time index
    ! --------

    call assert_approx(solution(1, 1), 1.1_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(2, 1), 2._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(3, 1), 3.9_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(4, 1), 4._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(5, 1), 5._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Secon time index
    ! --------

    ! Ghost is untouched
    call assert_approx(solution(1, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(2, 2), 7.5_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(3, 2), -23.6_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(4, 2), 12.5_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Ghost is untouched
    call assert_approx(solution(5, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Third time index is untouched
    call assert_true(all((solution(:, 3) + 42._dp) < 1.e-10_dp), &
                     __FILE__, __LINE__, failures)
end

subroutine step_test_all(failures)
    integer, intent(inout) :: failures

    call step_ftcs_test(failures)
    call step_lax_test(failures)
    call step_upwind_test(failures)
    call step_lax_wendroff_test(failures)
end

end module StepTest
