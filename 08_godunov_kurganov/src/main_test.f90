program MainTest
    use CommandLineArgsTest, only: command_line_args_test_all
    use StringTest, only: string_test_all
    use SettingsTest, only: settings_test_all
    use FloatUtilsTest, only: float_utils_test_all
    use FileUtilsTest, only: file_utils_test_all
    use EquationTest, only: equation_test_all
    use OutputTest, only: output_test_all
    use GridTest, only: grid_test_all
    use InitialConditionsTest, only: init_test_all
    use StepTest, only: step_test_all
    implicit none

    integer :: failures = 0
    character(len=1024) :: test_word = "TESTS"

    call command_line_args_test_all(failures)
    call string_test_all(failures)
    call settings_test_all(failures)

    call float_utils_test_all(failures)
    call file_utils_test_all(failures)
    call equation_test_all(failures)
    call output_test_all(failures)
    call grid_test_all(failures)
    call init_test_all(failures)
    call step_test_all(failures)

    if (failures == 0) then
        print *, NEW_LINE('h')//'Tests finished successfully'
    else
        if (failures == 1) then
            test_word = "TEST"
        end if

        print '(a, i4, x, a, x, a)', NEW_LINE('h'), failures, &
              trim(test_word), 'FAILED'

        call exit(42)
    end if
end program MainTest