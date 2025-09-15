// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtb_debouncer_debug.h for the primary calling header

#ifndef VERILATED_VTB_DEBOUNCER_DEBUG___024ROOT_H_
#define VERILATED_VTB_DEBOUNCER_DEBUG___024ROOT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"
class Vtb_debouncer_debug___024unit;


class Vtb_debouncer_debug__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtb_debouncer_debug___024root final : public VerilatedModule {
  public:
    // CELLS
    Vtb_debouncer_debug___024unit* __PVT____024unit;

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ tb_debouncer_debug__DOT__clk;
    CData/*0:0*/ tb_debouncer_debug__DOT__rst_n;
    CData/*0:0*/ tb_debouncer_debug__DOT__key_pressed;
    CData/*0:0*/ tb_debouncer_debug__DOT__key_valid;
    CData/*3:0*/ tb_debouncer_debug__DOT__row_idx;
    CData/*3:0*/ tb_debouncer_debug__DOT__col_idx;
    CData/*3:0*/ tb_debouncer_debug__DOT__key_row;
    CData/*3:0*/ tb_debouncer_debug__DOT__key_col;
    CData/*1:0*/ tb_debouncer_debug__DOT__dut__DOT__state;
    CData/*1:0*/ tb_debouncer_debug__DOT__dut__DOT__next_state;
    CData/*3:0*/ tb_debouncer_debug__DOT__dut__DOT__cand_row;
    CData/*3:0*/ tb_debouncer_debug__DOT__dut__DOT__cand_col;
    CData/*0:0*/ __VstlFirstIteration;
    CData/*3:0*/ __Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__col_idx__0;
    CData/*3:0*/ __Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__dut__DOT__cand_col__0;
    CData/*3:0*/ __Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__dut__DOT__cand_row__0;
    CData/*3:0*/ __Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__key_col__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__key_pressed__0;
    CData/*3:0*/ __Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__key_row__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__key_valid__0;
    CData/*3:0*/ __Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__row_idx__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__clk__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__rst_n__0;
    CData/*0:0*/ __VactDidInit;
    CData/*0:0*/ __VactContinue;
    IData/*31:0*/ tb_debouncer_debug__DOT__dut__DOT__debounce_cnt;
    IData/*31:0*/ __Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__dut__DOT__debounce_cnt__0;
    IData/*31:0*/ __VactIterCount;
    VlDelayScheduler __VdlySched;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<12> __VactTriggered;
    VlTriggerVec<12> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vtb_debouncer_debug__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vtb_debouncer_debug___024root(Vtb_debouncer_debug__Syms* symsp, const char* v__name);
    ~Vtb_debouncer_debug___024root();
    VL_UNCOPYABLE(Vtb_debouncer_debug___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
