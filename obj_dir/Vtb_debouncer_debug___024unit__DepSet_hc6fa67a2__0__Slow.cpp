// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_debouncer_debug.h for the primary calling header

#include "Vtb_debouncer_debug__pch.h"
#include "Vtb_debouncer_debug___024unit.h"

VL_ATTR_COLD void Vtb_debouncer_debug___024unit___ctor_var_reset(Vtb_debouncer_debug___024unit* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+  Vtb_debouncer_debug___024unit___ctor_var_reset\n"); );
    Vtb_debouncer_debug__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    for (int __Vi = 0; __Vi < 4; ++__Vi) {
        vlSelf->__Venumtab_enum_name3[__Vi] = std::string{};
    }
    vlSelf->__Venumtab_enum_name3[0] = std::string{"IDLE"};
    vlSelf->__Venumtab_enum_name3[1] = std::string{"DEBOUNCE"};
    vlSelf->__Venumtab_enum_name3[2] = std::string{"HOLD"};
    vlSelf->__Venumtab_enum_name3[3] = std::string{"RELEASE"};
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->name());
    vlSelf->__VmonitorNum = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 9173067072191078724ull);
    vlSelf->__VmonitorOff = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 9011783253012809090ull);
}
