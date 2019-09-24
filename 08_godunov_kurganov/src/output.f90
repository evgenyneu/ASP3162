!
! Write solution to a file
!
module Output
use Types, only: dp
implicit none
private
public :: write_output

contains

!
! Prints solution to a binary data file. See README.md for description
! of the file format.
!
! Inputs:
! --------
!
! filename : Name of the data file to print output to
!
! solution : array containing the solution
!
! x_points : A 1D array containing the values of x
!
! t_points : A 1D array containing the values of t
!
subroutine write_output(filename, solution, x_points, t_points)
    character(len=*), intent(in) :: filename
    real(dp), intent(in) :: solution(:, :, :)
    real(dp), intent(in) :: x_points(:), t_points(:)
    integer :: out_unit

    open(newunit=out_unit, file=filename, form="unformatted", action="write", &
        status="replace")

    write(out_unit) size(x_points)
    write(out_unit) size(t_points)
    write(out_unit) size(solution, 1)
    write(out_unit) x_points
    write(out_unit) t_points
    write(out_unit) solution

    close(unit=out_unit)
end subroutine

end module Output