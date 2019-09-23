module StepTest
use Types, only: dp
use AssertsTest, only: assert_true, assert_approx, assert_equal
use Step, only: step_finite_volume
use Settings, only: program_settings
implicit none
private
public step_test_all

contains


subroutine step_finite_volume_test(failures)
    integer, intent(inout) :: failures
    real(dp) :: solution(1, 5, 3)
    real(dp) :: fluxes(1, 5), eigenvalues(5)
    type(program_settings) :: options

    options%method = 'godunov'

    solution = -42
    solution(1, :, 1) = [1.1_dp, 2._dp, 3.9_dp, 4._dp, 5._dp]
    fluxes(1, :) = [0.99_dp, 1.2_dp, 9.1_dp, 12.1_dp, -0.2_dp]
    eigenvalues = [0.1_dp, -0.1_dp, 7.1_dp, 2.1_dp, -1.2_dp]

    call step_finite_volume(options=options,&
                            nx=5, nt=2, dx=0.01_dp, dt=0.05_dp, &
                            fluxes=fluxes, eigenvalues=eigenvalues, &
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

    call assert_approx(solution(1, 2, 2), 0.95_dp, &
                       1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(solution(1, 3, 2), -35.6_dp, &
                       1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(solution(1, 4, 2), -11._dp, &
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

    call step_finite_volume_test(failures)
end

end module StepTest