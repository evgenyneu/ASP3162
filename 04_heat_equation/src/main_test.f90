program MainTest
    use CommandLineArgsTest, only: command_line_args_test_all
    use StringTest, only: string_test_all
    use SettingsTest, only: settings_test_all
    use FloatUtilsTest, only: float_utils_test_all
    use HeatEquationTest, only: heat_equation_test_all
    implicit none

    integer :: failures = 0

    call command_line_args_test_all(failures)
    call string_test_all(failures)
    call settings_test_all(failures)

    call float_utils_test_all(failures)
    call heat_equation_test_all(failures)

    if (failures == 0) then
        print *, NEW_LINE('h')//'Tests finished successfully'
    else
        print *, NEW_LINE('h')//'TEST FAILED'
        call exit(42)
    end if
end program MainTest