! Set initial conditions
module InitialConditions
use Types, only: dp
use Constants, only: pi
use Settings, only: program_settings
use Physics, only: many_primitive_vectors_to_state_vectors
implicit none
private
public :: set_initial, calculate_initial

contains


!
! Calculate initial condition
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
! solution : array containing the initial conditions
!
subroutine calculate_initial(type, x_points, solution)
    character(len=*), intent(in) :: type
    real(dp), intent(in) :: x_points(:)
    real(dp), intent(inout) :: solution(:, :)
    real(dp) :: primitive_vectors(size(solution, 1), size(solution, 2) - 2)

    select case (type)
    case ("square")
        where (x_points > 0.25 .and. x_points <= 0.75)
            primitive_vectors(1, :) = 1
        elsewhere
            primitive_vectors(1, :) = 0
        end where
    case ("sine")
        primitive_vectors(1, :) = sin(2 * pi * x_points)
    case default
       print "(a, a)", "ERROR: unknown initial conditions type ", trim(type)
       call exit(41)
    end select

    call many_primitive_vectors_to_state_vectors( &
            primitive_vectors=primitive_vectors, &
            state_vectors=solution(:, 2: size(solution, 2) - 1))
end subroutine


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
! solution : array containing the solution
!
subroutine set_initial(type, x_points, solution)
    character(len=*), intent(in) :: type
    real(dp), intent(in) :: x_points(:)
    real(dp), intent(inout) :: solution(:, :, :)

    call calculate_initial(type=type, x_points=x_points, &
                           solution=solution(:, :, 1))
end subroutine

end module InitialConditions