// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtb_seven_segment.h for the primary calling header

#ifndef VERILATED_VTB_SEVEN_SEGMENT___024ROOT_H_
#define VERILATED_VTB_SEVEN_SEGMENT___024ROOT_H_  // guard

#include "verilated.h"


class Vtb_seven_segment__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtb_seven_segment___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    CData/*3:0*/ tb_seven_segment__DOT__num;
    CData/*6:0*/ tb_seven_segment__DOT__seg;
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __VactContinue;
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<0> __VactTriggered;
    VlTriggerVec<0> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vtb_seven_segment__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vtb_seven_segment___024root(Vtb_seven_segment__Syms* symsp, const char* v__name);
    ~Vtb_seven_segment___024root();
    VL_UNCOPYABLE(Vtb_seven_segment___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
