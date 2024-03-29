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
    real(dp) :: state_vectors(1, 5, 3)
    real(dp) :: interface_fluxes(1, 4)
    real(dp) :: eigenvalues(5)

    state_vectors = -42
    state_vectors(1, :, 1) = [1.1_dp, 2._dp, 3.9_dp, 4._dp, 5._dp]
    interface_fluxes(1, :) = [99.1_dp, -12.2_dp, 0.001_dp, 0.7_dp]
    eigenvalues = [0.1_dp, -0.1_dp, 7.1_dp, 2.1_dp, -1.2_dp]

    call step_finite_volume(nt=2, dx=0.01_dp, dt=0.05_dp, &
                            interface_fluxes=interface_fluxes,&
                            state_vectors=state_vectors)


    ! First time index
    ! --------

    call assert_approx(state_vectors(1, 1, 1), 1.1_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(state_vectors(1, 2, 1), 2._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(state_vectors(1, 3, 1), 3.9_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(state_vectors(1, 4, 1), 4._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(state_vectors(1, 5, 1), 5._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)


    ! Second time index
    ! --------

    ! Ghost is untouched
    call assert_approx(state_vectors(1, 1, 2), -42._dp, &
                       1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(state_vectors(1, 2, 2), 558.50_dp, &
                       1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(state_vectors(1, 3, 2), -57.105_dp, &
                       1e-10_dp, __FILE__, __LINE__, failures)

    call assert_approx(state_vectors(1, 4, 2), 0.505_dp, &
                       1e-10_dp, __FILE__, __LINE__, failures)

    ! Ghost is untouched
    call assert_approx(state_vectors(1, 5, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Third time index is untouched
    call assert_true(all((state_vectors(:, :, 3) + 42._dp) < 1.e-10_dp), &
                     __FILE__, __LINE__, failures)
end


subroutine step_test_all(failures)
    integer, intent(inout) :: failures

    call step_finite_volume_test(failures)
end

end module StepTest
