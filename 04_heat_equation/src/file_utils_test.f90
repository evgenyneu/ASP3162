module FileUtilsTest
use AssertsTest, only: assert_true
use FileUtils, only: file_exists
implicit none
private
public file_utils_test_all

contains

subroutine file_exsts(failures)
    integer, intent(inout) :: failures
    logical :: result

    result = file_exists("unknown_file")
    call assert_true(.not. result, __FILE__, __LINE__, failures)

    result = file_exists("src/file_utils.f90")
    call assert_true(result, __FILE__, __LINE__, failures)
end


subroutine file_utils_test_all(failures)
    integer, intent(inout) :: failures

    call file_exsts(failures)
end

end module FileUtilsTest
