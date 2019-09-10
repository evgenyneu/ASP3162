!
! Helper functions to deal with file system
!
module Grid
implicit none
private
public :: set_grid

contains

!
! Delete a file.
!
! Inputs:
! -------
!
! filename : Path to a file.
!
subroutine set_grid(filename)
    character(len=*), intent(in) :: filename
    integer :: stat

    open(unit=1234, iostat=stat, file=filename, status='old')
    if (stat == 0) close(1234, status='delete')
end subroutine

end module Grid