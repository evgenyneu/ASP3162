from adaptive_integrator import Adaptive
from network_implicit_integrator import NetworkImplicitIntegrator


class AdaptiveNetworkImplicit(Adaptive, NetworkImplicitIntegrator):
    """Adaptive Implicit solver"""
