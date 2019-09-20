!
! Helper functions to deal with file system
!
module FileUtils
implicit none
private
public :: file_exists, delete_file

contains

!
! Returns .true. if file at a given path exists
!
! Inputs:
! -------
!
! filename : Path to a file.
!
!
! Outputs:
! -------
!
! Returns : .true. if file exists.
!
function file_exists(filename) result(res)
  character(len=*),intent(in) :: filename
  logical :: res

  inquire(file=trim(filename), exist=res)
end function


!
! Delete a file.
!
! Inputs:
! -------
!
! filename : Path to a file.
!
subroutine delete_file(filename)
    character(len=*), intent(in) :: filename
    integer :: stat

    open(unit=1234, iostat=stat, file=filename, status='old')
    if (stat == 0) close(1234, status='delete')
end subroutine

end module FileUtils