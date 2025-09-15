// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VTB_DEBOUNCER_DEBUG__SYMS_H_
#define VERILATED_VTB_DEBOUNCER_DEBUG__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vtb_debouncer_debug.h"

// INCLUDE MODULE CLASSES
#include "Vtb_debouncer_debug___024root.h"
#include "Vtb_debouncer_debug___024unit.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES)Vtb_debouncer_debug__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vtb_debouncer_debug* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vtb_debouncer_debug___024root  TOP;
    Vtb_debouncer_debug___024unit  TOP____024unit;

    // CONSTRUCTORS
    Vtb_debouncer_debug__Syms(VerilatedContext* contextp, const char* namep, Vtb_debouncer_debug* modelp);
    ~Vtb_debouncer_debug__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
};

#endif  // guard
