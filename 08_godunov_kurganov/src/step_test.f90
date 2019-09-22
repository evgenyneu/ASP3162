module StepTest
use Types, only: dp
use AssertsTest, only: assert_true, assert_approx, assert_equal

use Step, only: step_ftcs, step_lax, step_upwind, step_lax_wendroff, &
                step_exact, step_godunov

use Settings, only: program_settings
implicit none
private
public step_test_all

contains


subroutine step_godunov_test(failures)
    integer, intent(inout) :: failures
    real(dp) :: solution(1, 5, 3)
    type(program_settings) :: options

    options%method = 'godunov'

    solution = -42
    solution(1, :, 1) = [1.1_dp, 2._dp, 3.9_dp, 4._dp, 5._dp]

    call step_godunov(options=options,&
                      nx=5, nt=2, dx=0.01_dp, dt=0.05_dp, v=1._dp, &
                      solution=solution)


    ! First time index
    ! --------

    call assert_approx(solution(1, 1, 1), 1.1_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 2, 1), 2._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 3, 1), 3.9_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 4, 1), 4._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 5, 1), 5._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)


    ! Second time index
    ! --------

    ! Ghost is untouched
    call assert_approx(solution(1, 1, 2), -42._dp, &
                       1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(solution(1, 2, 2), -4.9749999999999996_dp, &
                       1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(solution(1, 3, 2), -24.125_dp, &
                       1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(solution(1, 4, 2), 2.025_dp, &
                       1e-10_dp, __FILE__, __LINE__, failures)

    ! Ghost is untouched
    call assert_approx(solution(1, 5, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Third time index is untouched
    call assert_true(all((solution(:, :, 3) + 42._dp) < 1.e-10_dp), &
                     __FILE__, __LINE__, failures)
end


subroutine step_test_all(failures)
    integer, intent(inout) :: failures

    call step_godunov_test(failures)
end

end module StepTest