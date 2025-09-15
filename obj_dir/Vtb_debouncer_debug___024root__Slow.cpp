// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_debouncer_debug.h for the primary calling header

#include "Vtb_debouncer_debug__pch.h"
#include "Vtb_debouncer_debug__Syms.h"
#include "Vtb_debouncer_debug___024root.h"

void Vtb_debouncer_debug___024root___ctor_var_reset(Vtb_debouncer_debug___024root* vlSelf);

Vtb_debouncer_debug___024root::Vtb_debouncer_debug___024root(Vtb_debouncer_debug__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , __VdlySched{*symsp->_vm_contextp__}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vtb_debouncer_debug___024root___ctor_var_reset(this);
}

void Vtb_debouncer_debug___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vtb_debouncer_debug___024root::~Vtb_debouncer_debug___024root() {
}
