module GridTest
use Grid, only: set_grid
implicit none
private
public grid_test_all

contains

subroutine set_grid_test(failures)
    integer, intent(inout) :: failures
    ! logical :: result

    ! result = file_exists("unknown_file")
    ! call assert_true(.not. result, __FILE__, __LINE__, failures)

    ! result = file_exists("src/file_utils.f90")
    ! call assert_true(result, __FILE__, __LINE__, failures)
end


subroutine grid_test_all(failures)
    integer, intent(inout) :: failures

    call set_grid_test(failures)
end

end module GridTest
