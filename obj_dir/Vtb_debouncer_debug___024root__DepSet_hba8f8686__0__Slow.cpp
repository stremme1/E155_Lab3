// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_debouncer_debug.h for the primary calling header

#include "Vtb_debouncer_debug__pch.h"
#include "Vtb_debouncer_debug___024root.h"

VL_ATTR_COLD void Vtb_debouncer_debug___024root___eval_static(Vtb_debouncer_debug___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_debug___024root___eval_static\n"); );
    Vtb_debouncer_debug__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__col_idx__0 
        = vlSelfRef.tb_debouncer_debug__DOT__col_idx;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__dut__DOT__cand_col__0 
        = vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__cand_col;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__dut__DOT__cand_row__0 
        = vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__cand_row;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__dut__DOT__debounce_cnt__0 
        = vlSelfRef.tb_debouncer_debug__DOT__dut__DOT__debounce_cnt;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__key_col__0 
        = vlSelfRef.tb_debouncer_debug__DOT__key_col;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__key_pressed__0 
        = vlSelfRef.tb_debouncer_debug__DOT__key_pressed;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__key_row__0 
        = vlSelfRef.tb_debouncer_debug__DOT__key_row;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__key_valid__0 
        = vlSelfRef.tb_debouncer_debug__DOT__key_valid;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__row_idx__0 
        = vlSelfRef.tb_debouncer_debug__DOT__row_idx;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__clk__0 
        = vlSelfRef.tb_debouncer_debug__DOT__clk;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__rst_n__0 
        = vlSelfRef.tb_debouncer_debug__DOT__rst_n;
}

VL_ATTR_COLD void Vtb_debouncer_debug___024root___eval_final(Vtb_debouncer_debug___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_debug___024root___eval_final\n"); );
    Vtb_debouncer_debug__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_debouncer_debug___024root___dump_triggers__stl(Vtb_debouncer_debug___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vtb_debouncer_debug___024root___eval_phase__stl(Vtb_debouncer_debug___024root* vlSelf);

VL_ATTR_COLD void Vtb_debouncer_debug___024root___eval_settle(Vtb_debouncer_debug___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_debug___024root___eval_settle\n"); );
    Vtb_debouncer_debug__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __VstlIterCount;
    CData/*0:0*/ __VstlContinue;
    // Body
    __VstlIterCount = 0U;
    vlSelfRef.__VstlFirstIteration = 1U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        if (VL_UNLIKELY(((0x64U < __VstlIterCount)))) {
#ifdef VL_DEBUG
            Vtb_debouncer_debug___024root___dump_triggers__stl(vlSelf);
#endif
            VL_FATAL_MT("tb_debouncer_debug.sv", 2, "", "Settle region did not converge.");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        __VstlContinue = 0U;
        if (Vtb_debouncer_debug___024root___eval_phase__stl(vlSelf)) {
            __VstlContinue = 1U;
        }
        vlSelfRef.__VstlFirstIteration = 0U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_debouncer_debug___024root___dump_triggers__stl(Vtb_debouncer_debug___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_debug___024root___dump_triggers__stl\n"); );
    Vtb_debouncer_debug__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VstlTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

void Vtb_debouncer_debug___024root___act_sequent__TOP__0(Vtb_debouncer_debug___024root* vlSelf);

VL_ATTR_COLD void Vtb_debouncer_debug___024root___eval_stl(Vtb_debouncer_debug___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_debug___024root___eval_stl\n"); );
    Vtb_debouncer_debug__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VstlTriggered.word(0U))) {
        Vtb_debouncer_debug___024root___act_sequent__TOP__0(vlSelf);
    }
}

VL_ATTR_COLD void Vtb_debouncer_debug___024root___eval_triggers__stl(Vtb_debouncer_debug___024root* vlSelf);

VL_ATTR_COLD bool Vtb_debouncer_debug___024root___eval_phase__stl(Vtb_debouncer_debug___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_debug___024root___eval_phase__stl\n"); );
    Vtb_debouncer_debug__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VstlExecute;
    // Body
    Vtb_debouncer_debug___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = vlSelfRef.__VstlTriggered.any();
    if (__VstlExecute) {
        Vtb_debouncer_debug___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_debouncer_debug___024root___dump_triggers__act(Vtb_debouncer_debug___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_debug___024root___dump_triggers__act\n"); );
    Vtb_debouncer_debug__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VactTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @( tb_debouncer_debug.col_idx)\n");
    }
    if ((2ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 1 is active: @( tb_debouncer_debug.dut.cand_col)\n");
    }
    if ((4ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 2 is active: @( tb_debouncer_debug.dut.cand_row)\n");
    }
    if ((8ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 3 is active: @( tb_debouncer_debug.dut.debounce_cnt)\n");
    }
    if ((0x10ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 4 is active: @( tb_debouncer_debug.key_col)\n");
    }
    if ((0x20ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 5 is active: @( tb_debouncer_debug.key_pressed)\n");
    }
    if ((0x40ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 6 is active: @( tb_debouncer_debug.key_row)\n");
    }
    if ((0x80ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 7 is active: @( tb_debouncer_debug.key_valid)\n");
    }
    if ((0x100ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 8 is active: @( tb_debouncer_debug.row_idx)\n");
    }
    if ((0x200ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 9 is active: @(posedge tb_debouncer_debug.clk)\n");
    }
    if ((0x400ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 10 is active: @(negedge tb_debouncer_debug.rst_n)\n");
    }
    if ((0x800ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 11 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_debouncer_debug___024root___dump_triggers__nba(Vtb_debouncer_debug___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_debug___024root___dump_triggers__nba\n"); );
    Vtb_debouncer_debug__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @( tb_debouncer_debug.col_idx)\n");
    }
    if ((2ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 1 is active: @( tb_debouncer_debug.dut.cand_col)\n");
    }
    if ((4ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 2 is active: @( tb_debouncer_debug.dut.cand_row)\n");
    }
    if ((8ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 3 is active: @( tb_debouncer_debug.dut.debounce_cnt)\n");
    }
    if ((0x10ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 4 is active: @( tb_debouncer_debug.key_col)\n");
    }
    if ((0x20ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 5 is active: @( tb_debouncer_debug.key_pressed)\n");
    }
    if ((0x40ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 6 is active: @( tb_debouncer_debug.key_row)\n");
    }
    if ((0x80ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 7 is active: @( tb_debouncer_debug.key_valid)\n");
    }
    if ((0x100ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 8 is active: @( tb_debouncer_debug.row_idx)\n");
    }
    if ((0x200ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 9 is active: @(posedge tb_debouncer_debug.clk)\n");
    }
    if ((0x400ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 10 is active: @(negedge tb_debouncer_debug.rst_n)\n");
    }
    if ((0x800ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 11 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtb_debouncer_debug___024root___ctor_var_reset(Vtb_debouncer_debug___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_debug___024root___ctor_var_reset\n"); );
    Vtb_debouncer_debug__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->name());
    vlSelf->tb_debouncer_debug__DOT__clk = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 17915555423876558835ull);
    vlSelf->tb_debouncer_debug__DOT__rst_n = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 2590842680270626178ull);
    vlSelf->tb_debouncer_debug__DOT__key_pressed = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 13722862823796215008ull);
    vlSelf->tb_debouncer_debug__DOT__row_idx = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 15976948972242232913ull);
    vlSelf->tb_debouncer_debug__DOT__col_idx = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 6163632546821829349ull);
    vlSelf->tb_debouncer_debug__DOT__key_valid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 17105428519059061341ull);
    vlSelf->tb_debouncer_debug__DOT__key_row = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 8443783046477980358ull);
    vlSelf->tb_debouncer_debug__DOT__key_col = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 1699636167374421212ull);
    vlSelf->tb_debouncer_debug__DOT__dut__DOT__state = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 8276763297791507629ull);
    vlSelf->tb_debouncer_debug__DOT__dut__DOT__next_state = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 8417188006188966981ull);
    vlSelf->tb_debouncer_debug__DOT__dut__DOT__debounce_cnt = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 6919398059504890383ull);
    vlSelf->tb_debouncer_debug__DOT__dut__DOT__cand_row = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 15003435556026584211ull);
    vlSelf->tb_debouncer_debug__DOT__dut__DOT__cand_col = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 17851000301009318937ull);
    vlSelf->__Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__col_idx__0 = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 4310249232820882660ull);
    vlSelf->__Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__dut__DOT__cand_col__0 = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 5609058648051157583ull);
    vlSelf->__Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__dut__DOT__cand_row__0 = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 16135126969182943901ull);
    vlSelf->__Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__dut__DOT__debounce_cnt__0 = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 16283940007495392710ull);
    vlSelf->__Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__key_col__0 = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 14037634327037386195ull);
    vlSelf->__Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__key_pressed__0 = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 4662306597346879573ull);
    vlSelf->__Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__key_row__0 = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 9162689611193760914ull);
    vlSelf->__Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__key_valid__0 = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 12709303207504603594ull);
    vlSelf->__Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__row_idx__0 = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 9944067920020781798ull);
    vlSelf->__Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__clk__0 = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 6188814633529904887ull);
    vlSelf->__Vtrigprevexpr___TOP__tb_debouncer_debug__DOT__rst_n__0 = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16590951190673102873ull);
    vlSelf->__VactDidInit = 0;
}
