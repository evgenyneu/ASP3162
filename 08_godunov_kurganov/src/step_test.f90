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

subroutine step_ftcs_test(failures)
    integer, intent(inout) :: failures
    real(dp) :: solution(1, 5, 3)

    solution = -42
    solution(1, :, 1) = [1.1_dp, 2._dp, 3.9_dp, 4._dp, 5._dp]

    call step_ftcs(nx=5, nt=2, dx=0.01_dp, dt=0.05_dp, v=1._dp, &
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
    call assert_approx(solution(1, 1, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 2, 2), -5._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 3, 2), -1.1_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 4, 2), 1.25_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Ghost is untouched
    call assert_approx(solution(1, 5, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Third time index is untouched
    call assert_true(all((solution(:, :, 3) + 42._dp) < 1.e-10_dp), &
                     __FILE__, __LINE__, failures)
end

subroutine step_lax_test(failures)
    integer, intent(inout) :: failures
    real(dp) :: solution(1, 5, 3)

    solution = -42
    solution(1, :, 1) = [1.1_dp, 2._dp, 3.9_dp, 4._dp, 5._dp]

    call step_lax(nx=5, nt=2, dx=0.01_dp, dt=0.05_dp, v=1._dp, &
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
    call assert_approx(solution(1, 1, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 2, 2), -4.5_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 3, 2), -2._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 4, 2), 1.7_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Ghost is untouched
    call assert_approx(solution(1, 5, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Third time index is untouched
    call assert_true(all((solution(:, :, 3) + 42._dp) < 1.e-10_dp), &
                     __FILE__, __LINE__, failures)
end

subroutine step_upwind_test(failures)
    integer, intent(inout) :: failures
    real(dp) :: solution(1, 5, 3)

    solution = -42
    solution(1, :, 1) = [1.1_dp, 2._dp, 3.9_dp, 4._dp, 5._dp]
    call step_upwind(nx=5, nt=2, dx=0.01_dp, dt=0.05_dp, v=1._dp, &
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
    call assert_approx(solution(1, 1, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 2, 2), -2.5_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 3, 2), -5.6_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 4, 2), 3.5_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Ghost is untouched
    call assert_approx(solution(1, 5, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Third time index is untouched
    call assert_true(all((solution(:, :, 3) + 42._dp) < 1.e-10_dp), &
                     __FILE__, __LINE__, failures)
end

subroutine step_lax_wendroff_test(failures)
    integer, intent(inout) :: failures
    real(dp) :: solution(1, 5, 3)

    solution = -42
    solution(1, :, 1) = [1.1_dp, 2._dp, 3.9_dp, 4._dp, 5._dp]

    call step_lax_wendroff(nx=5, nt=2, dx=0.01_dp, dt=0.05_dp, v=1._dp, &
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
    call assert_approx(solution(1, 1, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 2, 2), 7.5_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 3, 2), -23.6_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 4, 2), 12.5_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Ghost is untouched
    call assert_approx(solution(1, 5, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Third time index is untouched
    call assert_true(all((solution(:, :, 3) + 42._dp) < 1.e-10_dp), &
                     __FILE__, __LINE__, failures)
end

subroutine step_exact_test__square(failures)
    integer, intent(inout) :: failures
    real(dp) :: x_points(6)
    real(dp) :: solution(1, 8, 3)
    type(program_settings) :: options

    options%initial_conditions = 'square'
    options%x_start = 0
    options%x_end = 1
    options%velocity = 1
    x_points = [0._dp, 0.2_dp, 0.4_dp, 0.6_dp, 0.8_dp, 1._dp]
    solution = -42

    solution(1, :, 1) = [0.1_dp, 1.1_dp, 2._dp, 3.9_dp, &
                      4._dp, 5._dp, 6.99_dp, 9.1_dp]

    call step_exact(options=options, t=0.5_dp, nt=2, x_points=x_points, &
                    solution=solution)


    ! First time index
    ! --------

    call assert_approx(solution(1, 1, 1), 0.1_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 2, 1), 1.1_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 3, 1), 2._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 4, 1), 3.9_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 5, 1), 4._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 6, 1), 5._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 7, 1), 6.99_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 8, 1), 9.1_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Secon time index
    ! --------

    ! Ghost is untouched
    call assert_approx(solution(1, 1, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 2, 2), 1._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 3, 2), 1._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 4, 2), 0._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 5, 2), 0._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 6, 2), 1._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 7, 2), 1._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Ghost is untouched
    call assert_approx(solution(1, 8, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Third time index is untouched
    call assert_true(all((solution(:, :, 3) + 42._dp) < 1.e-10_dp), &
                     __FILE__, __LINE__, failures)
end

subroutine step_exact_test__sine(failures)
    integer, intent(inout) :: failures
    real(dp) :: x_points(6)
    real(dp) :: solution(1, 8, 3)
    type(program_settings) :: options

    options%initial_conditions = 'sine'
    options%x_start = 0
    options%x_end = 1
    options%velocity = 1
    x_points = [0._dp, 0.2_dp, 0.4_dp, 0.6_dp, 0.8_dp, 1._dp]
    solution = -42

    solution(1, :, 1) = [0.1_dp, 1.1_dp, 2._dp, 3.9_dp, &
                      4._dp, 5._dp, 6.99_dp, 9.1_dp]

    call step_exact(options=options, t=0.5_dp, nt=2, x_points=x_points, &
                    solution=solution)


    ! First time index
    ! --------

    call assert_approx(solution(1, 1, 1), 0.1_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 2, 1), 1.1_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 3, 1), 2._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 4, 1), 3.9_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 5, 1), 4._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 6, 1), 5._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 7, 1), 6.99_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 8, 1), 9.1_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Secon time index
    ! --------

    ! Ghost is untouched
    call assert_approx(solution(1, 1, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 2, 2), 0._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 3, 2), -0.9510565162_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 4, 2), -0.58778525229_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 5, 2), 0.58778525229_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 6, 2), 0.95105651629_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 7, 2), 0._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Ghost is untouched
    call assert_approx(solution(1, 8, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Third time index is untouched
    call assert_true(all((solution(:, :, 3) + 42._dp) < 1.e-10_dp), &
                     __FILE__, __LINE__, failures)
end


subroutine step_exact_test__sine__custom_xmin_xmax(failures)
    integer, intent(inout) :: failures
    real(dp) :: x_points(6)
    real(dp) :: solution(1, 8, 3)
    type(program_settings) :: options

    ! Test case when x_start and x_end are not 0 and 1
    options%initial_conditions = 'sine'
    options%x_start = 0.2
    options%x_end = 0.9
    options%velocity = 1
    x_points = [0.2_dp, 0.4_dp, 0.6_dp, 0.7_dp, 0.8_dp, 0.9_dp]
    solution = -42

    solution(1, :, 1) = [0.1_dp, 1.1_dp, 2._dp, 3.9_dp, &
                      4._dp, 5._dp, 6.99_dp, 9.1_dp]

    call step_exact(options=options, t=0.5_dp, nt=2, x_points=x_points, &
                    solution=solution)


    ! First time index
    ! --------

    call assert_approx(solution(1, 1, 1), 0.1_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 2, 1), 1.1_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 3, 1), 2._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 4, 1), 3.9_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 5, 1), 4._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 6, 1), 5._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 7, 1), 6.99_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 8, 1), 9.1_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Secon time index
    ! --------

    ! Ghost is untouched
    call assert_approx(solution(1, 1, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 2, 2), 0.587785388634_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 3, 2), -0.58778511595_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 4, 2), -0.95105656837_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 5, 2), -0.5877853886346_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 6, 2), 0.9510565162951_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 7, 2), 0.587785252292_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Ghost is untouched
    call assert_approx(solution(1, 8, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Third time index is untouched
    call assert_true(all((solution(:, :, 3) + 42._dp) < 1.e-10_dp), &
                     __FILE__, __LINE__, failures)
end

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
    call assert_approx(solution(1, 1, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 2, 2), -2.5_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 3, 2), -5.6_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    call assert_approx(solution(1, 4, 2), 3.5_dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Ghost is untouched
    call assert_approx(solution(1, 5, 2), -42._dp, 1e-10_dp, __FILE__, &
                       __LINE__, failures)

    ! Third time index is untouched
    call assert_true(all((solution(:, :, 3) + 42._dp) < 1.e-10_dp), &
                     __FILE__, __LINE__, failures)
end


subroutine step_test_all(failures)
    integer, intent(inout) :: failures

    call step_ftcs_test(failures)
    call step_lax_test(failures)
    call step_upwind_test(failures)
    call step_lax_wendroff_test(failures)
    call step_exact_test__square(failures)
    call step_exact_test__sine(failures)
    call step_exact_test__sine__custom_xmin_xmax(failures)

    ! call step_godunov_test(failures)
end

end module StepTest