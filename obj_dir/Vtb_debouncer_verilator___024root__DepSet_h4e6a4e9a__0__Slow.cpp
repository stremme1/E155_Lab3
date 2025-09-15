// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_debouncer_verilator.h for the primary calling header

#include "Vtb_debouncer_verilator__pch.h"
#include "Vtb_debouncer_verilator___024root.h"

VL_ATTR_COLD void Vtb_debouncer_verilator___024root___eval_static(Vtb_debouncer_verilator___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_verilator___024root___eval_static\n"); );
    Vtb_debouncer_verilator__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
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
}

VL_ATTR_COLD void Vtb_debouncer_verilator___024root___eval_final(Vtb_debouncer_verilator___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_verilator___024root___eval_final\n"); );
    Vtb_debouncer_verilator__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_debouncer_verilator___024root___dump_triggers__stl(Vtb_debouncer_verilator___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vtb_debouncer_verilator___024root___eval_phase__stl(Vtb_debouncer_verilator___024root* vlSelf);

VL_ATTR_COLD void Vtb_debouncer_verilator___024root___eval_settle(Vtb_debouncer_verilator___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_verilator___024root___eval_settle\n"); );
    Vtb_debouncer_verilator__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
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
            Vtb_debouncer_verilator___024root___dump_triggers__stl(vlSelf);
#endif
            VL_FATAL_MT("tb_debouncer_verilator.sv", 2, "", "Settle region did not converge.");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        __VstlContinue = 0U;
        if (Vtb_debouncer_verilator___024root___eval_phase__stl(vlSelf)) {
            __VstlContinue = 1U;
        }
        vlSelfRef.__VstlFirstIteration = 0U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_debouncer_verilator___024root___dump_triggers__stl(Vtb_debouncer_verilator___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_verilator___024root___dump_triggers__stl\n"); );
    Vtb_debouncer_verilator__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
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

void Vtb_debouncer_verilator___024root___act_sequent__TOP__0(Vtb_debouncer_verilator___024root* vlSelf);

VL_ATTR_COLD void Vtb_debouncer_verilator___024root___eval_stl(Vtb_debouncer_verilator___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_verilator___024root___eval_stl\n"); );
    Vtb_debouncer_verilator__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VstlTriggered.word(0U))) {
        Vtb_debouncer_verilator___024root___act_sequent__TOP__0(vlSelf);
    }
}

VL_ATTR_COLD void Vtb_debouncer_verilator___024root___eval_triggers__stl(Vtb_debouncer_verilator___024root* vlSelf);

VL_ATTR_COLD bool Vtb_debouncer_verilator___024root___eval_phase__stl(Vtb_debouncer_verilator___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_verilator___024root___eval_phase__stl\n"); );
    Vtb_debouncer_verilator__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VstlExecute;
    // Body
    Vtb_debouncer_verilator___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = vlSelfRef.__VstlTriggered.any();
    if (__VstlExecute) {
        Vtb_debouncer_verilator___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_debouncer_verilator___024root___dump_triggers__act(Vtb_debouncer_verilator___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_verilator___024root___dump_triggers__act\n"); );
    Vtb_debouncer_verilator__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VactTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @( tb_debouncer_verilator.col_idx)\n");
    }
    if ((2ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 1 is active: @( tb_debouncer_verilator.dut.cand_col)\n");
    }
    if ((4ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 2 is active: @( tb_debouncer_verilator.dut.cand_row)\n");
    }
    if ((8ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 3 is active: @( tb_debouncer_verilator.dut.debounce_cnt)\n");
    }
    if ((0x10ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 4 is active: @( tb_debouncer_verilator.key_col)\n");
    }
    if ((0x20ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 5 is active: @( tb_debouncer_verilator.key_pressed)\n");
    }
    if ((0x40ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 6 is active: @( tb_debouncer_verilator.key_row)\n");
    }
    if ((0x80ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 7 is active: @( tb_debouncer_verilator.key_valid)\n");
    }
    if ((0x100ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 8 is active: @( tb_debouncer_verilator.row_idx)\n");
    }
    if ((0x200ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 9 is active: @(posedge tb_debouncer_verilator.clk)\n");
    }
    if ((0x400ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 10 is active: @(negedge tb_debouncer_verilator.rst_n)\n");
    }
    if ((0x800ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 11 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_debouncer_verilator___024root___dump_triggers__nba(Vtb_debouncer_verilator___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_verilator___024root___dump_triggers__nba\n"); );
    Vtb_debouncer_verilator__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @( tb_debouncer_verilator.col_idx)\n");
    }
    if ((2ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 1 is active: @( tb_debouncer_verilator.dut.cand_col)\n");
    }
    if ((4ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 2 is active: @( tb_debouncer_verilator.dut.cand_row)\n");
    }
    if ((8ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 3 is active: @( tb_debouncer_verilator.dut.debounce_cnt)\n");
    }
    if ((0x10ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 4 is active: @( tb_debouncer_verilator.key_col)\n");
    }
    if ((0x20ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 5 is active: @( tb_debouncer_verilator.key_pressed)\n");
    }
    if ((0x40ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 6 is active: @( tb_debouncer_verilator.key_row)\n");
    }
    if ((0x80ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 7 is active: @( tb_debouncer_verilator.key_valid)\n");
    }
    if ((0x100ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 8 is active: @( tb_debouncer_verilator.row_idx)\n");
    }
    if ((0x200ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 9 is active: @(posedge tb_debouncer_verilator.clk)\n");
    }
    if ((0x400ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 10 is active: @(negedge tb_debouncer_verilator.rst_n)\n");
    }
    if ((0x800ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 11 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtb_debouncer_verilator___024root___ctor_var_reset(Vtb_debouncer_verilator___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_debouncer_verilator___024root___ctor_var_reset\n"); );
    Vtb_debouncer_verilator__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->name());
    vlSelf->tb_debouncer_verilator__DOT__clk = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 12334992521838296247ull);
    vlSelf->tb_debouncer_verilator__DOT__rst_n = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 6930761815012542312ull);
    vlSelf->tb_debouncer_verilator__DOT__key_pressed = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 11313874285240393249ull);
    vlSelf->tb_debouncer_verilator__DOT__row_idx = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 13533162453696028651ull);
    vlSelf->tb_debouncer_verilator__DOT__col_idx = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 16260003069683315027ull);
    vlSelf->tb_debouncer_verilator__DOT__key_valid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 13489292100525133214ull);
    vlSelf->tb_debouncer_verilator__DOT__key_row = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 679607862481997158ull);
    vlSelf->tb_debouncer_verilator__DOT__key_col = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 3966127075091932092ull);
    vlSelf->tb_debouncer_verilator__DOT__dut__DOT__state = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 6990650552742392493ull);
    vlSelf->tb_debouncer_verilator__DOT__dut__DOT__next_state = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 12054494755126378911ull);
    vlSelf->tb_debouncer_verilator__DOT__dut__DOT__debounce_cnt = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 18179855333805626238ull);
    vlSelf->tb_debouncer_verilator__DOT__dut__DOT__cand_row = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 17408862817503532873ull);
    vlSelf->tb_debouncer_verilator__DOT__dut__DOT__cand_col = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 15841180859049017230ull);
    vlSelf->__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__col_idx__0 = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 13672297171240402068ull);
    vlSelf->__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__dut__DOT__cand_col__0 = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 14101028781589929862ull);
    vlSelf->__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__dut__DOT__cand_row__0 = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 17494171447280337165ull);
    vlSelf->__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__dut__DOT__debounce_cnt__0 = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 15320514763792433564ull);
    vlSelf->__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__key_col__0 = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 2935859974698185392ull);
    vlSelf->__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__key_pressed__0 = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 7024061785146147139ull);
    vlSelf->__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__key_row__0 = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 997819296643779593ull);
    vlSelf->__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__key_valid__0 = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 18248167212723301649ull);
    vlSelf->__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__row_idx__0 = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 984055293142525464ull);
    vlSelf->__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__clk__0 = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 1997250599469507104ull);
    vlSelf->__Vtrigprevexpr___TOP__tb_debouncer_verilator__DOT__rst_n__0 = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 2443861514727897810ull);
    vlSelf->__VactDidInit = 0;
}
