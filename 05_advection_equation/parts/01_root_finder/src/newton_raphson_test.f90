module NewtonRaphsonTest
use Types, only: dp
use AssertsTest, only: assert_approx, assert_true
! use RootFinder, only: my_function, my_function_derivative
use NewtonRaphson, only: approximate_root

implicit none
private
public newton_raphson_test_all

contains

! subroutine find_root_test(failures)
!     integer, intent(inout) :: failures
!     real(dp) :: result
!     logical :: success

!     result = approximate_root(x_start=0.5_dp, &
!                               func=my_function, &
!                               derivative=my_function_derivative, &
!                               tolerance=1e-5_dp, &
!                               max_iterations = 20, &
!                               success=success)

!     call assert_true(success, __FILE__, __LINE__, failures)
!     call assert_approx(result, 0.739085_dp, 1e-5_dp, __FILE__, __LINE__, failures)
! end

! subroutine find_root_test_did_not_converge(failures)
!     integer, intent(inout) :: failures
!     real(dp) :: result
!     logical :: success

!     result = approximate_root(x_start=10000._dp, &
!                               func=my_function, &
!                               derivative=my_function_derivative, &
!                               tolerance=1e-5_dp, &
!                               max_iterations = 20, &
!                               success=success)

!     call assert_true(.not. success, __FILE__, __LINE__, failures)
! end

subroutine newton_raphson_test_all(failures)
    integer, intent(inout) :: failures

    ! call find_root_test(failures)
    ! call find_root_test_did_not_converge(failures)
end

end module NewtonRaphsonTest
