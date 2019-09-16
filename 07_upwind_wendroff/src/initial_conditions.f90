! Set initial conditions
module InitialConditions
use Types, only: dp
use Constants, only: pi
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
! type : type of initial conditions ("square", "since")
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
subroutine set_initial(type, x_points, solution)
    character(len=*), intent(in) :: type
    real(dp), intent(in) :: x_points(:)
    real(dp), intent(inout) :: solution(:, :)

    select case (type)
    case ("square")
        where (x_points > 0.25 .and. x_points <= 0.75)
            solution(2: size(solution, 1) - 1, 1) = 1
        elsewhere
            solution(2: size(solution, 1) - 1, 1) = 0
        end where
    case ("sine")
        solution(2: size(solution, 1) - 1, 1) = sin(2 * pi * x_points)
    case default
       print "(a, a)", "ERROR: unknown initial conditions type ", trim(type)
       call exit(41)
    end select
end subroutine

end module InitialConditions