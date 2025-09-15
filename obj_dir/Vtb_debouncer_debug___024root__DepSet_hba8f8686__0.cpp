// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_debouncer_debug.h for the primary calling header

#include "Vtb_debouncer_debug__pch.h"
#include "Vtb_debouncer_debug___024root.h"

VlCoroutine Vtb_debouncer_debug___024root___eval_initial__TOP__Vtiming__0(Vtb_debouncer_debug___024root* vlSelf);
VlCoroutine Vtb_debouncer_debug___024root___eval_initial__TOP__Vtiming__1(Vtb_debouncer_debug___024root* vlSelf);

void Vtb_debouncer_debug___024root___eval_initial(Vtb_debouncer_debug___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_debug___024root___eval_initial\n"); );
    Vtb_debouncer_debug__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vtb_debouncer_debug___024root___eval_initial__TOP__Vtiming__0(vlSelf);
    Vtb_debouncer_debug___024root___eval_initial__TOP__Vtiming__1(vlSelf);
}

VL_INLINE_OPT VlCoroutine Vtb_debouncer_debug___024root___eval_initial__TOP__Vtiming__0(Vtb_debouncer_debug___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_debug___024root___eval_initial__TOP__Vtiming__0\n"); );
    Vtb_debouncer_debug__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.tb_debouncer_debug__DOT__clk = 0U;
    while (1U) {
        co_await vlSelfRef.__VdlySched.delay(0x28870ULL, 
                                             nullptr, 
                                             "tb_debouncer_debug.sv", 
                                             29);
        vlSelfRef.tb_debouncer_debug__DOT__clk = (1U 
                                                  & (~ (IData)(vlSelfRef.tb_debouncer_debug__DOT__clk)));
    }
}

void Vtb_debouncer_debug___024root___act_sequent__TOP__0(Vtb_debouncer_debug___024root* vlSelf);

void Vtb_debouncer_debug___024root___eval_act(Vtb_debouncer_debug___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_debug___024root___eval_act\n"); );
    Vtb_debouncer_debug__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((0x800ULL & vlSelfRef.__VactTriggered.word(0U))) {
        Vtb_debouncer_debug___024root___act_sequent__TOP__0(vlSelf);
    }
}

VL_INLINE_OPT void Vtb_debouncer_debug___024root___act_sequent__TOP__0(Vtb_debouncer_debug___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_debug___024root___act_sequent__TOP__0\n"); );
    Vtb_debouncer_debug__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__next_state 
        = vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__state;
    if ((2U & (IData)(vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__state))) {
        if ((1U & (IData)(vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__state))) {
            if ((1U & (~ (IData)(vlSelfRef.tb_debouncer_debug__DOT__key_pressed)))) {
                vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__next_state = 0U;
            }
        } else if ((1U & (~ (IData)(vlSelfRef.tb_debouncer_debug__DOT__key_pressed)))) {
            vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__next_state = 3U;
        }
    } else if ((1U & (IData)(vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__state))) {
        if ((1U & (((~ (IData)(vlSelfRef.tb_debouncer_debug__DOT__key_pressed)) 
                    | ((IData)(vlSelfRef.tb_debouncer_debug__DOT__row_idx) 
                       != (IData)(vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__cand_row))) 
                   | ((IData)(vlSelfRef.tb_debouncer_debug__DOT__col_idx) 
                      != (IData)(vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__cand_col))))) {
            vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__next_state = 0U;
        } else if ((0xea60U <= vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__debounce_cnt)) {
            vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__next_state = 2U;
        }
    } else if (vlSelfRef.tb_debouncer_debug__DOT__key_pressed) {
        vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__next_state = 1U;
    }
}

void Vtb_debouncer_debug___024root___nba_sequent__TOP__1(Vtb_debouncer_debug___024root* vlSelf);
void Vtb_debouncer_debug___024root___nba_sequent__TOP__2(Vtb_debouncer_debug___024root* vlSelf);

void Vtb_debouncer_debug___024root___eval_nba(Vtb_debouncer_debug___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_debug___024root___eval_nba\n"); );
    Vtb_debouncer_debug__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((0x1ffULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vtb_debouncer_debug___024root___nba_sequent__TOP__1(vlSelf);
    }
    if ((0x600ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vtb_debouncer_debug___024root___nba_sequent__TOP__2(vlSelf);
    }
    if ((0xe00ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vtb_debouncer_debug___024root___act_sequent__TOP__0(vlSelf);
    }
}

VL_INLINE_OPT void Vtb_debouncer_debug___024root___nba_sequent__TOP__2(Vtb_debouncer_debug___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_debug___024root___nba_sequent__TOP__2\n"); );
    Vtb_debouncer_debug__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (vlSelfRef.tb_debouncer_debug__DOT__rst_n) {
        if (((((1U == (IData)(vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__state)) 
               & (IData)(vlSelfRef.tb_debouncer_debug__DOT__key_pressed)) 
              & ((IData)(vlSelfRef.tb_debouncer_debug__DOT__row_idx) 
                 == (IData)(vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__cand_row))) 
             & ((IData)(vlSelfRef.tb_debouncer_debug__DOT__col_idx) 
                == (IData)(vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__cand_col)))) {
            if ((0xea60U > vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__debounce_cnt)) {
                vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__debounce_cnt 
                    = ((IData)(1U) + vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__debounce_cnt);
            }
        } else {
            vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__debounce_cnt = 0U;
        }
        if ((2U == (IData)(vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__state))) {
            vlSelfRef.tb_debouncer_debug__DOT__key_valid = 1U;
            vlSelfRef.tb_debouncer_debug__DOT__key_row 
                = vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__cand_row;
            vlSelfRef.tb_debouncer_debug__DOT__key_col 
                = vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__cand_col;
        } else {
            vlSelfRef.tb_debouncer_debug__DOT__key_valid = 0U;
        }
        if ((((((0U == (IData)(vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__state)) 
                & (1U == (IData)(vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__next_state))) 
               & (IData)(vlSelfRef.tb_debouncer_debug__DOT__key_pressed)) 
              & (0U != (IData)(vlSelfRef.tb_debouncer_debug__DOT__row_idx))) 
             & (0U != (IData)(vlSelfRef.tb_debouncer_debug__DOT__col_idx)))) {
            vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__cand_row 
                = vlSelfRef.tb_debouncer_debug__DOT__row_idx;
            vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__cand_col 
                = vlSelfRef.tb_debouncer_debug__DOT__col_idx;
        }
        vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__state 
            = vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__next_state;
    } else {
        vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__debounce_cnt = 0U;
        vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__cand_row = 0U;
        vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__cand_col = 0U;
        vlSelfRef.tb_debouncer_debug__DOT__key_valid = 0U;
        vlSelfRef.tb_debouncer_debug__DOT__key_row = 0U;
        vlSelfRef.tb_debouncer_debug__DOT__key_col = 0U;
        vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__state = 0U;
    }
}

void Vtb_debouncer_debug___024root___timing_resume(Vtb_debouncer_debug___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_debug___024root___timing_resume\n"); );
    Vtb_debouncer_debug__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((0x800ULL & vlSelfRef.__VactTriggered.word(0U))) {
        vlSelfRef.__VdlySched.resume();
    }
}

void Vtb_debouncer_debug___024root___eval_triggers__act(Vtb_debouncer_debug___024root* vlSelf);

bool Vtb_debouncer_debug___024root___eval_phase__act(Vtb_debouncer_debug___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_debug___024root___eval_phase__act\n"); );
    Vtb_debouncer_debug__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    VlTriggerVec<12> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vtb_debouncer_debug___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelfRef.__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelfRef.__VactTriggered, vlSelfRef.__VnbaTriggered);
        vlSelfRef.__VnbaTriggered.thisOr(vlSelfRef.__VactTriggered);
        Vtb_debouncer_debug___024root___timing_resume(vlSelf);
        Vtb_debouncer_debug___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vtb_debouncer_debug___024root___eval_phase__nba(Vtb_debouncer_debug___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_debug___024root___eval_phase__nba\n"); );
    Vtb_debouncer_debug__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelfRef.__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vtb_debouncer_debug___024root___eval_nba(vlSelf);
        vlSelfRef.__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_debouncer_debug___024root___dump_triggers__nba(Vtb_debouncer_debug___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_debouncer_debug___024root___dump_triggers__act(Vtb_debouncer_debug___024root* vlSelf);
#endif  // VL_DEBUG

void Vtb_debouncer_debug___024root___eval(Vtb_debouncer_debug___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_debug___024root___eval\n"); );
    Vtb_debouncer_debug__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY(((0x64U < __VnbaIterCount)))) {
#ifdef VL_DEBUG
            Vtb_debouncer_debug___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("tb_debouncer_debug.sv", 2, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelfRef.__VactIterCount = 0U;
        vlSelfRef.__VactContinue = 1U;
        while (vlSelfRef.__VactContinue) {
            if (VL_UNLIKELY(((0x64U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                Vtb_debouncer_debug___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("tb_debouncer_debug.sv", 2, "", "Active region did not converge.");
            }
            vlSelfRef.__VactIterCount = ((IData)(1U) 
                                         + vlSelfRef.__VactIterCount);
            vlSelfRef.__VactContinue = 0U;
            if (Vtb_debouncer_debug___024root___eval_phase__act(vlSelf)) {
                vlSelfRef.__VactContinue = 1U;
            }
        }
        if (Vtb_debouncer_debug___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vtb_debouncer_debug___024root___eval_debug_assertions(Vtb_debouncer_debug___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_debug___024root___eval_debug_assertions\n"); );
    Vtb_debouncer_debug__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}
#endif  // VL_DEBUG
