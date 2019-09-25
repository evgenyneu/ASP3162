module InterfaceFluxTest
use Types, only: dp
use AssertsTest, only: assert_approx

use InterfaceFlux, only: godunov_flux, single_interface_flux, &
                         calculate_interface_fluxes

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

subroutine single_interface_flux_test__godunov(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: options
    real(dp) :: flux(1)

    options%method = 'godunov'

    call single_interface_flux(options=options, &
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

subroutine single_interface_flux_test__kurganov(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: options
    real(dp) :: flux(1)

    options%method = 'kurganov'

    call single_interface_flux(options=options, &
        state_vector_left=[-31.1_dp], &
        state_vector_right=[-10.2_dp], &
        flux_left=[-1.1_dp], &
        flux_right=[-1.2_dp], &
        eigenvalue_left=3.1_dp, &
        eigenvalue_right=0.1_dp, &
        flux=flux)

    call assert_approx(flux(1), -33.545_dp, 1e-13_dp, &
        __FILE__, __LINE__, failures)
end

subroutine calculate_interface_fluxes_test(failures)
    integer, intent(inout) :: failures
    type(program_settings) :: options
    real(dp) :: eigenvalues(5)
    real(dp) :: state_vectors(1, 5), fluxes(1, 5)
    real(dp) :: interface_fluxes(1, 4)

    options%method = 'kurganov'
    state_vectors(1, :) = [1, 2, 3, 4, 5]
    eigenvalues = [9, 10, 11, 12, 13]
    fluxes(1, :) = [1.1_dp, 2.2_dp, 3.3_dp, 4.4_dp, 5.5_dp]


    call calculate_interface_fluxes(options=options, &
        nx=5, fluxes=fluxes, &
        eigenvalues=eigenvalues, &
        state_vectors=state_vectors, &
        interface_fluxes=interface_fluxes)

    call assert_approx(interface_fluxes(1, 1), -3.35_dp, 1e-13_dp, &
                       __FILE__, __LINE__, failures)

    call assert_approx(interface_fluxes(1, 2), -2.75_dp, 1e-13_dp, &
                       __FILE__, __LINE__, failures)

    call assert_approx(interface_fluxes(1, 3), -2.15_dp, 1e-13_dp, &
                       __FILE__, __LINE__, failures)

    call assert_approx(interface_fluxes(1, 4), -1.55_dp, 1e-13_dp, &
                      __FILE__, __LINE__, failures)
end


subroutine interface_flux_test_all(failures)
    integer, intent(inout) :: failures

    call godunov_flux_test__uleft_greater_uright__speed_positive(failures)
    call godunov_flux_test__uleft_greater_uright__speed_negative(failures)
    call godunov_flux_test__uleft_smaller_uright__uleft_positive(failures)
    call godunov_flux_test__uleft_smaller_uright__uright_negative(failures)
    call godunov_flux_test__uleft_smaller_uright__zero(failures)

    call single_interface_flux_test__godunov(failures)
    call single_interface_flux_test__kurganov(failures)

    call calculate_interface_fluxes_test(failures)
end

end module InterfaceFluxTest
