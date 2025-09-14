// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vtb_seven_segment__pch.h"

//============================================================
// Constructors

Vtb_seven_segment::Vtb_seven_segment(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vtb_seven_segment__Syms(contextp(), _vcname__, this)}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vtb_seven_segment::Vtb_seven_segment(const char* _vcname__)
    : Vtb_seven_segment(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vtb_seven_segment::~Vtb_seven_segment() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vtb_seven_segment___024root___eval_debug_assertions(Vtb_seven_segment___024root* vlSelf);
#endif  // VL_DEBUG
void Vtb_seven_segment___024root___eval_static(Vtb_seven_segment___024root* vlSelf);
void Vtb_seven_segment___024root___eval_initial(Vtb_seven_segment___024root* vlSelf);
void Vtb_seven_segment___024root___eval_settle(Vtb_seven_segment___024root* vlSelf);
void Vtb_seven_segment___024root___eval(Vtb_seven_segment___024root* vlSelf);

void Vtb_seven_segment::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vtb_seven_segment::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vtb_seven_segment___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vtb_seven_segment___024root___eval_static(&(vlSymsp->TOP));
        Vtb_seven_segment___024root___eval_initial(&(vlSymsp->TOP));
        Vtb_seven_segment___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vtb_seven_segment___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vtb_seven_segment::eventsPending() { return false; }

uint64_t Vtb_seven_segment::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vtb_seven_segment::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vtb_seven_segment___024root___eval_final(Vtb_seven_segment___024root* vlSelf);

VL_ATTR_COLD void Vtb_seven_segment::final() {
    Vtb_seven_segment___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vtb_seven_segment::hierName() const { return vlSymsp->name(); }
const char* Vtb_seven_segment::modelName() const { return "Vtb_seven_segment"; }
unsigned Vtb_seven_segment::threads() const { return 1; }
void Vtb_seven_segment::prepareClone() const { contextp()->prepareClone(); }
void Vtb_seven_segment::atClone() const {
    contextp()->threadPoolpOnClone();
}
