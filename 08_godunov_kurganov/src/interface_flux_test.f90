module InterfaceFluxTest
use Types, only: dp
use AssertsTest, only: assert_approx
use InterfaceFlux, only: godunov_flux, interface_flux
use Settings, only: program_settings
implicit none
private
public interface_flux_test_all

contains

! Godunov flux
! Case 1: state vector on the left is greater than the right one
! -----------------

subroutine godunov_flux_test__uleft_greater_uright__speed_positive(failures)
    integer, intent(inout) :: failures
    real(dp) :: flux(1)

    call godunov_flux( &
        state_vector_left=[10.1_dp], &
        state_vector_right=[1.2_dp], &
        flux_left=[-1.1_dp], &
        flux_right=[-1.2_dp], &
        flux=flux)

    call assert_approx(flux(1), -1.1_dp, 1e-13_dp, &
        __FILE__, __LINE__, failures)
end

subroutine godunov_flux_test__uleft_greater_uright__speed_negative(failures)
    integer, intent(inout) :: failures
    real(dp) :: flux(1)

    call godunov_flux( &
        state_vector_left=[-1.1_dp], &
        state_vector_right=[-10.2_dp], &
        flux_left=[-1.1_dp], &
        flux_right=[-1.2_dp], &
        flux=flux)

    call assert_approx(flux(1), -1.2_dp, 1e-13_dp, &
        __FILE__, __LINE__, failures)
end


! Godunov flux
! Case 2: state vector on the left is smaller than the right one
! -----------------

subroutine godunov_flux_test__uleft_smaller_uright__uleft_positive(failures)
    integer, intent(inout) :: failures
    real(dp) :: flux(1)

    call godunov_flux( &
        state_vector_left=[10.1_dp], &
        state_vector_right=[20.2_dp], &
        flux_left=[-1.1_dp], &
        flux_right=[-1.2_dp], &
        flux=flux)

    call assert_approx(flux(1), -1.1_dp, 1e-13_dp, &
        __FILE__, __LINE__, failures)
end

subroutine godunov_flux_test__uleft_smaller_uright__uright_negative(failures)
    integer, intent(inout) :: failures
    real(dp) :: flux(1)

    call godunov_flux( &
        state_vector_left=[-310.1_dp], &
        state_vector_right=[-10.2_dp], &
        flux_left=[-1.1_dp], &
        flux_right=[-1.2_dp], &
        flux=flux)

    call assert_approx(flux(1), -1.2_dp, 1e-13_dp, &
        __FILE__, __LINE__, failures)
end

subroutine godunov_flux_test__uleft_smaller_uright__zero(failures)
    integer, intent(inout) :: failures
    real(dp) :: flux(1)

    call godunov_flux( &
        state_vector_left=[-310.1_dp], &
        state_vector_right=[10.2_dp], &
        flux_left=[-1.1_dp], &
        flux_right=[-1.2_dp], &
        flux=flux)

    call assert_approx(flux(1), 0._dp, 1e-13_dp, &
        __FILE__, __LINE__, failures)
end

subroutine interface_flux_test__godunov(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: options
    real(dp) :: flux(1)

    options%method = 'godunov'

    call interface_flux(options=options, &
        state_vector_left=[-310.1_dp], &
        state_vector_right=[-10.2_dp], &
        flux_left=[-1.1_dp], &
        flux_right=[-1.2_dp], &
        eigenvalue_left=3.1_dp, &
        eigenvalue_right=0.1_dp, &
        flux=flux)

    call assert_approx(flux(1), -1.2_dp, 1e-13_dp, &
        __FILE__, __LINE__, failures)
end

subroutine interface_flux_test__kurganov(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: options
    real(dp) :: flux(1)

    options%method = 'kurganov'

    call interface_flux(options=options, &
        state_vector_left=[-310.1_dp], &
        state_vector_right=[-10.2_dp], &
        flux_left=[-1.1_dp], &
        flux_right=[-1.2_dp], &
        eigenvalue_left=3.1_dp, &
        eigenvalue_right=0.1_dp, &
        flux=flux)

    call assert_approx(flux(1), -465.995_dp, 1e-13_dp, &
        __FILE__, __LINE__, failures)
end



subroutine interface_flux_test_all(failures)
    integer, intent(inout) :: failures

    call godunov_flux_test__uleft_greater_uright__speed_positive(failures)
    call godunov_flux_test__uleft_greater_uright__speed_negative(failures)
    call godunov_flux_test__uleft_smaller_uright__uleft_positive(failures)
    call godunov_flux_test__uleft_smaller_uright__uright_negative(failures)
    call godunov_flux_test__uleft_smaller_uright__zero(failures)

    call interface_flux_test__godunov(failures)
    call interface_flux_test__kurganov(failures)
end

end module InterfaceFluxTest
