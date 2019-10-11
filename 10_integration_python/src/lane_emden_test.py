from pytest import approx
from lane_emden import lane_emden_derivatives, solve_lane_emden
from integrators import runge_kutta_integrator


def test_lane_emden_derivatives():
    result = lane_emden_derivatives(
        x=0.1,
        dependent_variables=(0.3, 0.1),
        data={"polytropic_index": 3})

    assert result.tolist() == [0.1, -2.027]


def test_lane_emden_derivatives__x_zero():
    result = lane_emden_derivatives(
        x=0,
        dependent_variables=(0.3, 0.1),
        data={"polytropic_index": 3})

    assert result.tolist() == [0, 0]


def test_solve_lane_emden():
    result = solve_lane_emden(step_size=0.1,
                              polytropic_index=3,
                              integrator=runge_kutta_integrator)

    assert len(result) == 2
    all_x = result[0]
    all_dependen_variables = result[1]
    assert len(all_x) == 69
    assert len(all_dependen_variables) == 69

    assert(all_x[0]) == approx(0, rel=1e-15)
    assert(all_x[1]) == approx(0.1, rel=1e-15)
    assert(all_x[68]) == approx(6.799999999999992, rel=1e-15)

    assert len(all_dependen_variables[0]) == 2

    assert all_dependen_variables[0][0] == approx(1, rel=1e-15)
    assert all_dependen_variables[0][1] == approx(0, rel=1e-15)

    assert all_dependen_variables[1][0] == \
        approx(1, rel=1e-15)

    assert all_dependen_variables[1][1] == \
        approx(-0.049751247916666665, rel=1e-15)

    assert all_dependen_variables[68][0] == \
        approx(0.004176220461746652, rel=1e-15)

    assert all_dependen_variables[68][1] == \
        approx(-0.043633684355236305, rel=1e-15)
