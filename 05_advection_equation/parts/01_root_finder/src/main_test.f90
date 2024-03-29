program MainTest
    use CommandLineArgsTest, only: command_line_args_test_all
    use StringTest, only: string_test_all
    use SettingsTest, only: settings_test_all
    use FloatUtilsTest, only: float_utils_test_all
    use FileUtilsTest, only: file_utils_test_all
    use RootFinderTest, only: root_finder_test_all
    use NewtonRaphsonTest, only: newton_raphson_test_all
    implicit none

    integer :: failures = 0

    call command_line_args_test_all(failures)
    call string_test_all(failures)
    call settings_test_all(failures)

    call float_utils_test_all(failures)
    call file_utils_test_all(failures)
    call newton_raphson_test_all(failures)
    call root_finder_test_all(failures)

    if (failures == 0) then
        print *, NEW_LINE('h')//'Tests finished successfully'
    else
        print *, NEW_LINE('h')//'TEST FAILED'
        call exit(42)
    end if
end program MainTest