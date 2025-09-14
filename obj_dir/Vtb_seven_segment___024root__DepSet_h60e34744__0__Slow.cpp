// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_seven_segment.h for the primary calling header

#include "Vtb_seven_segment__pch.h"
#include "Vtb_seven_segment___024root.h"

VL_ATTR_COLD void Vtb_seven_segment___024root___eval_static(Vtb_seven_segment___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seven_segment___024root___eval_static\n"); );
    Vtb_seven_segment__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vtb_seven_segment___024root___eval_initial__TOP(Vtb_seven_segment___024root* vlSelf);

VL_ATTR_COLD void Vtb_seven_segment___024root___eval_initial(Vtb_seven_segment___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seven_segment___024root___eval_initial\n"); );
    Vtb_seven_segment__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vtb_seven_segment___024root___eval_initial__TOP(vlSelf);
}

VL_ATTR_COLD void Vtb_seven_segment___024root___eval_initial__TOP(Vtb_seven_segment___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seven_segment___024root___eval_initial__TOP\n"); );
    Vtb_seven_segment__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    VL_WRITEF_NX("=== Seven Segment Decoder Testbench ===\nInput: 0, Segments: %b\nInput: 1, Segments: %b\nInput: 2, Segments: %b\nInput: 3, Segments: %b\nInput: 4, Segments: %b\nInput: 5, Segments: %b\nInput: 6, Segments: %b\nInput: 7, Segments: %b\nInput: 8, Segments: %b\nInput: 9, Segments: %b\nInput: a, Segments: %b\nInput: b, Segments: %b\nInput: c, Segments: %b\nInput: d, Segments: %b\nInput: e, Segments: %b\n",0,
                 7,vlSelfRef.tb_seven_segment__DOT__seg,
                 7,(IData)(vlSelfRef.tb_seven_segment__DOT__seg),
                 7,vlSelfRef.tb_seven_segment__DOT__seg,
                 7,(IData)(vlSelfRef.tb_seven_segment__DOT__seg),
                 7,vlSelfRef.tb_seven_segment__DOT__seg,
                 7,(IData)(vlSelfRef.tb_seven_segment__DOT__seg),
                 7,vlSelfRef.tb_seven_segment__DOT__seg,
                 7,(IData)(vlSelfRef.tb_seven_segment__DOT__seg),
                 7,vlSelfRef.tb_seven_segment__DOT__seg,
                 7,(IData)(vlSelfRef.tb_seven_segment__DOT__seg),
                 7,vlSelfRef.tb_seven_segment__DOT__seg,
                 7,(IData)(vlSelfRef.tb_seven_segment__DOT__seg),
                 7,vlSelfRef.tb_seven_segment__DOT__seg,
                 7,(IData)(vlSelfRef.tb_seven_segment__DOT__seg),
                 7,vlSelfRef.tb_seven_segment__DOT__seg);
    vlSelfRef.tb_seven_segment__DOT__num = 0xfU;
    VL_WRITEF_NX("Input: f, Segments: %b\n\n=== Test Complete ===\n",0,
                 7,vlSelfRef.tb_seven_segment__DOT__seg);
    VL_FINISH_MT("tb_seven_segment.sv", 71, "");
}

VL_ATTR_COLD void Vtb_seven_segment___024root___eval_final(Vtb_seven_segment___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seven_segment___024root___eval_final\n"); );
    Vtb_seven_segment__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_seven_segment___024root___dump_triggers__stl(Vtb_seven_segment___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vtb_seven_segment___024root___eval_phase__stl(Vtb_seven_segment___024root* vlSelf);

VL_ATTR_COLD void Vtb_seven_segment___024root___eval_settle(Vtb_seven_segment___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seven_segment___024root___eval_settle\n"); );
    Vtb_seven_segment__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
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
            Vtb_seven_segment___024root___dump_triggers__stl(vlSelf);
#endif
            VL_FATAL_MT("tb_seven_segment.sv", 5, "", "Settle region did not converge.");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        __VstlContinue = 0U;
        if (Vtb_seven_segment___024root___eval_phase__stl(vlSelf)) {
            __VstlContinue = 1U;
        }
        vlSelfRef.__VstlFirstIteration = 0U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_seven_segment___024root___dump_triggers__stl(Vtb_seven_segment___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seven_segment___024root___dump_triggers__stl\n"); );
    Vtb_seven_segment__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
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

VL_ATTR_COLD void Vtb_seven_segment___024root___stl_sequent__TOP__0(Vtb_seven_segment___024root* vlSelf);

VL_ATTR_COLD void Vtb_seven_segment___024root___eval_stl(Vtb_seven_segment___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seven_segment___024root___eval_stl\n"); );
    Vtb_seven_segment__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VstlTriggered.word(0U))) {
        Vtb_seven_segment___024root___stl_sequent__TOP__0(vlSelf);
    }
}

extern const VlUnpacked<CData/*6:0*/, 16> Vtb_seven_segment__ConstPool__TABLE_h3fc54aa7_0;

VL_ATTR_COLD void Vtb_seven_segment___024root___stl_sequent__TOP__0(Vtb_seven_segment___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seven_segment___024root___stl_sequent__TOP__0\n"); );
    Vtb_seven_segment__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*3:0*/ __Vtableidx1;
    __Vtableidx1 = 0;
    // Body
    __Vtableidx1 = vlSelfRef.tb_seven_segment__DOT__num;
    vlSelfRef.tb_seven_segment__DOT__seg = Vtb_seven_segment__ConstPool__TABLE_h3fc54aa7_0
        [__Vtableidx1];
}

VL_ATTR_COLD void Vtb_seven_segment___024root___eval_triggers__stl(Vtb_seven_segment___024root* vlSelf);

VL_ATTR_COLD bool Vtb_seven_segment___024root___eval_phase__stl(Vtb_seven_segment___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seven_segment___024root___eval_phase__stl\n"); );
    Vtb_seven_segment__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VstlExecute;
    // Body
    Vtb_seven_segment___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = vlSelfRef.__VstlTriggered.any();
    if (__VstlExecute) {
        Vtb_seven_segment___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_seven_segment___024root___dump_triggers__act(Vtb_seven_segment___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seven_segment___024root___dump_triggers__act\n"); );
    Vtb_seven_segment__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VactTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_seven_segment___024root___dump_triggers__nba(Vtb_seven_segment___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seven_segment___024root___dump_triggers__nba\n"); );
    Vtb_seven_segment__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtb_seven_segment___024root___ctor_var_reset(Vtb_seven_segment___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seven_segment___024root___ctor_var_reset\n"); );
    Vtb_seven_segment__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->name());
    vlSelf->tb_seven_segment__DOT__num = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 8849017455770636399ull);
    vlSelf->tb_seven_segment__DOT__seg = VL_SCOPED_RAND_RESET_I(7, __VscopeHash, 13396610443362658530ull);
}
