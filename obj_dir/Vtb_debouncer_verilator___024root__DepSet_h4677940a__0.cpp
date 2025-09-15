// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_debouncer_verilator.h for the primary calling header

#include "Vtb_debouncer_verilator__pch.h"
#include "Vtb_debouncer_verilator__Syms.h"
#include "Vtb_debouncer_verilator___024root.h"

VL_INLINE_OPT VlCoroutine Vtb_debouncer_verilator___024root___eval_initial__TOP__Vtiming__1(Vtb_debouncer_verilator___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_verilator___024root___eval_initial__TOP__Vtiming__1\n"); );
    Vtb_debouncer_verilator__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    VL_WRITEF_NX("=== Debouncer Verilator Debug Test ===\n",0);
    vlSelfRef.tb_debouncer_verilator__DOT__rst_n = 0U;
    vlSelfRef.tb_debouncer_verilator__DOT__key_pressed = 0U;
    vlSelfRef.tb_debouncer_verilator__DOT__row_idx = 0U;
    vlSelfRef.tb_debouncer_verilator__DOT__col_idx = 0U;
    co_await vlSelfRef.__VdlySched.delay(0xf4240ULL, 
                                         nullptr, "tb_debouncer_verilator.sv", 
                                         41);
    vlSelfRef.tb_debouncer_verilator__DOT__rst_n = 1U;
    VL_WRITEF_NX("Time %0t: System initialized\n",0,
                 64,VL_TIME_UNITED_Q(1000),-9);
    vlSymsp->TOP____024unit.__VmonitorNum = 1U;
    VL_WRITEF_NX("Test: Pressing key '1' for 100ms\n",0);
    vlSelfRef.tb_debouncer_verilator__DOT__key_pressed = 1U;
    vlSelfRef.tb_debouncer_verilator__DOT__row_idx = 1U;
    vlSelfRef.tb_debouncer_verilator__DOT__col_idx = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x174876e800ULL, 
                                         nullptr, "tb_debouncer_verilator.sv", 
                                         54);
    vlSelfRef.tb_debouncer_verilator__DOT__key_pressed = 0U;
    vlSelfRef.tb_debouncer_verilator__DOT__row_idx = 0U;
    vlSelfRef.tb_debouncer_verilator__DOT__col_idx = 0U;
    co_await vlSelfRef.__VdlySched.delay(0x2540be400ULL, 
                                         nullptr, "tb_debouncer_verilator.sv", 
                                         58);
    VL_WRITEF_NX("=== Test Complete ===\n",0);
    VL_FINISH_MT("tb_debouncer_verilator.sv", 61, "");
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_debouncer_verilator___024root___dump_triggers__act(Vtb_debouncer_verilator___024root* vlSelf);
#endif  // VL_DEBUG

void Vtb_debouncer_verilator___024root___eval_triggers__act(Vtb_debouncer_verilator___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_verilator___024root___eval_triggers__act\n"); );
    Vtb_debouncer_verilator__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VactTriggered.setBit(0U, ((IData)(vlSelfRef.tb_debouncer_verilator__DOT__col_idx) 
                                          != (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__col_idx__0)));
    vlSelfRef.__VactTriggered.setBit(1U, ((IData)(vlSelfRef.tb_debouncer_verilator__DOT__dut__DOT__cand_col) 
                                          != (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__dut__DOT__cand_col__0)));
    vlSelfRef.__VactTriggered.setBit(2U, ((IData)(vlSelfRef.tb_debouncer_verilator__DOT__dut__DOT__cand_row) 
                                          != (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__dut__DOT__cand_row__0)));
    vlSelfRef.__VactTriggered.setBit(3U, (vlSelfRef.tb_debouncer_verilator__DOT__dut__DOT__debounce_cnt 
                                          != vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__dut__DOT__debounce_cnt__0));
    vlSelfRef.__VactTriggered.setBit(4U, ((IData)(vlSelfRef.tb_debouncer_verilator__DOT__key_col) 
                                          != (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__key_col__0)));
    vlSelfRef.__VactTriggered.setBit(5U, ((IData)(vlSelfRef.tb_debouncer_verilator__DOT__key_pressed) 
                                          != (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__key_pressed__0)));
    vlSelfRef.__VactTriggered.setBit(6U, ((IData)(vlSelfRef.tb_debouncer_verilator__DOT__key_row) 
                                          != (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__key_row__0)));
    vlSelfRef.__VactTriggered.setBit(7U, ((IData)(vlSelfRef.tb_debouncer_verilator__DOT__key_valid) 
                                          != (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__key_valid__0)));
    vlSelfRef.__VactTriggered.setBit(8U, ((IData)(vlSelfRef.tb_debouncer_verilator__DOT__row_idx) 
                                          != (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__row_idx__0)));
    vlSelfRef.__VactTriggered.setBit(9U, ((IData)(vlSelfRef.tb_debouncer_verilator__DOT__clk) 
                                          & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__clk__0))));
    vlSelfRef.__VactTriggered.setBit(0xaU, ((~ (IData)(vlSelfRef.tb_debouncer_verilator__DOT__rst_n)) 
                                            & (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__rst_n__0)));
    vlSelfRef.__VactTriggered.setBit(0xbU, vlSelfRef.__VdlySched.awaitingCurrentTime());
    vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__col_idx__0 
        = vlSelfRef.tb_debouncer_verilator__DOT__col_idx;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__dut__DOT__cand_col__0 
        = vlSelfRef.tb_debouncer_verilator__DOT__dut__DOT__cand_col;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__dut__DOT__cand_row__0 
        = vlSelfRef.tb_debouncer_verilator__DOT__dut__DOT__cand_row;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__dut__DOT__debounce_cnt__0 
        = vlSelfRef.tb_debouncer_verilator__DOT__dut__DOT__debounce_cnt;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__key_col__0 
        = vlSelfRef.tb_debouncer_verilator__DOT__key_col;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__key_pressed__0 
        = vlSelfRef.tb_debouncer_verilator__DOT__key_pressed;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__key_row__0 
        = vlSelfRef.tb_debouncer_verilator__DOT__key_row;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__key_valid__0 
        = vlSelfRef.tb_debouncer_verilator__DOT__key_valid;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__row_idx__0 
        = vlSelfRef.tb_debouncer_verilator__DOT__row_idx;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__clk__0 
        = vlSelfRef.tb_debouncer_verilator__DOT__clk;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__rst_n__0 
        = vlSelfRef.tb_debouncer_verilator__DOT__rst_n;
    if (VL_UNLIKELY(((1U & (~ (IData)(vlSelfRef.__VactDidInit)))))) {
        vlSelfRef.__VactDidInit = 1U;
        vlSelfRef.__VactTriggered.setBit(0U, 1U);
        vlSelfRef.__VactTriggered.setBit(1U, 1U);
        vlSelfRef.__VactTriggered.setBit(2U, 1U);
        vlSelfRef.__VactTriggered.setBit(3U, 1U);
        vlSelfRef.__VactTriggered.setBit(4U, 1U);
        vlSelfRef.__VactTriggered.setBit(5U, 1U);
        vlSelfRef.__VactTriggered.setBit(6U, 1U);
        vlSelfRef.__VactTriggered.setBit(7U, 1U);
        vlSelfRef.__VactTriggered.setBit(8U, 1U);
    }
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtb_debouncer_verilator___024root___dump_triggers__act(vlSelf);
    }
#endif
}

VL_INLINE_OPT void Vtb_debouncer_verilator___024root___nba_sequent__TOP__1(Vtb_debouncer_verilator___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_verilator___024root___nba_sequent__TOP__1\n"); );
    Vtb_debouncer_verilator__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    std::string __Vtemp_1;
    // Body
    if (VL_UNLIKELY((((~ (IData)(vlSymsp->TOP____024unit.__VmonitorOff)) 
                      & (1U == vlSymsp->TOP____024unit.__VmonitorNum))))) {
        __Vtemp_1 = Vtb_debouncer_verilator___024unit::__Venumtab_enum_name3
            [vlSelfRef.tb_debouncer_verilator__DOT__dut__DOT__state];
        VL_WRITEF_NX("Time %0t: State=%@, KeyPressed=%b, RowIdx=%b, ColIdx=%b, KeyValid=%b, KeyRow=%b, KeyCol=%b, CandRow=%b, CandCol=%b, DebounceCnt=%0#\n",0,
                     64,VL_TIME_UNITED_Q(1000),-9,-1,
                     &(__Vtemp_1),1,(IData)(vlSelfRef.tb_debouncer_verilator__DOT__key_pressed),
                     4,vlSelfRef.tb_debouncer_verilator__DOT__row_idx,
                     4,(IData)(vlSelfRef.tb_debouncer_verilator__DOT__col_idx),
                     1,vlSelfRef.tb_debouncer_verilator__DOT__key_valid,
                     4,(IData)(vlSelfRef.tb_debouncer_verilator__DOT__key_row),
                     4,vlSelfRef.tb_debouncer_verilator__DOT__key_col,
                     4,(IData)(vlSelfRef.tb_debouncer_verilator__DOT__dut__DOT__cand_row),
                     4,vlSelfRef.tb_debouncer_verilator__DOT__dut__DOT__cand_col,
                     32,vlSelfRef.tb_debouncer_verilator__DOT__dut__DOT__debounce_cnt);
    }
}
