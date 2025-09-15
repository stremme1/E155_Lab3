// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VTB_DEBOUNCER_VERILATOR__SYMS_H_
#define VERILATED_VTB_DEBOUNCER_VERILATOR__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vtb_debouncer_verilator.h"

// INCLUDE MODULE CLASSES
#include "Vtb_debouncer_verilator___024root.h"
#include "Vtb_debouncer_verilator___024unit.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES)Vtb_debouncer_verilator__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vtb_debouncer_verilator* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vtb_debouncer_verilator___024root TOP;
    Vtb_debouncer_verilator___024unit TOP____024unit;

    // CONSTRUCTORS
    Vtb_debouncer_verilator__Syms(VerilatedContext* contextp, const char* namep, Vtb_debouncer_verilator* modelp);
    ~Vtb_debouncer_verilator__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
};

#endif  // guard
