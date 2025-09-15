// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vtb_debouncer_debug__pch.h"
#include "Vtb_debouncer_debug.h"
#include "Vtb_debouncer_debug___024root.h"
#include "Vtb_debouncer_debug___024unit.h"

// FUNCTIONS
Vtb_debouncer_debug__Syms::~Vtb_debouncer_debug__Syms()
{
}

Vtb_debouncer_debug__Syms::Vtb_debouncer_debug__Syms(VerilatedContext* contextp, const char* namep, Vtb_debouncer_debug* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    // Setup module instances
    , TOP{this, namep}
    , TOP____024unit{this, Verilated::catName(namep, "$unit")}
{
        // Check resources
        Verilated::stackCheck(36);
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-9);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    TOP.__PVT____024unit = &TOP____024unit;
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(true);
    TOP____024unit.__Vconfigure(true);
}
