// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_seven_segment.h for the primary calling header

#include "Vtb_seven_segment__pch.h"
#include "Vtb_seven_segment__Syms.h"
#include "Vtb_seven_segment___024root.h"

void Vtb_seven_segment___024root___ctor_var_reset(Vtb_seven_segment___024root* vlSelf);

Vtb_seven_segment___024root::Vtb_seven_segment___024root(Vtb_seven_segment__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vtb_seven_segment___024root___ctor_var_reset(this);
}

void Vtb_seven_segment___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vtb_seven_segment___024root::~Vtb_seven_segment___024root() {
}
