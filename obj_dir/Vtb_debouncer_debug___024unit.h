// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtb_debouncer_debug.h for the primary calling header

#ifndef VERILATED_VTB_DEBOUNCER_DEBUG___024UNIT_H_
#define VERILATED_VTB_DEBOUNCER_DEBUG___024UNIT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Vtb_debouncer_debug__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtb_debouncer_debug___024unit final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ __VmonitorOff;
    QData/*63:0*/ __VmonitorNum;
    static VlUnpacked<std::string, 4> __Venumtab_enum_name3;

    // INTERNAL VARIABLES
    Vtb_debouncer_debug__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vtb_debouncer_debug___024unit(Vtb_debouncer_debug__Syms* symsp, const char* v__name);
    ~Vtb_debouncer_debug___024unit();
    VL_UNCOPYABLE(Vtb_debouncer_debug___024unit);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
