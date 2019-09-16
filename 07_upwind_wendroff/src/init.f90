! Set initil condition
module Init
use Types, only: dp
use Settings, only: program_settings
implicit none
private
public :: set_initial

contains


!
! Set initial condition in the `solution` array.
!
! Inputs:
! -------
!
! x_points : A 1D array containing the values of the x coordinate
!
!
! Outputs:
! -------
!
! solution : 2D array containing the solution for the advection equation
!        first coordinate is x, second is time.
!
subroutine set_initial(x_points, solution)
    real(dp), intent(in) :: x_points(:)
    real(dp), intent(inout) :: solution(:, :)

    where (x_points > 0.25 .and. x_points <= 0.75)
        solution(2: size(solution, 1) - 1, 1) = 1
    elsewhere
        solution(2: size(solution, 1) - 1, 1) = 0
    end where
end subroutine

end module Init