// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vtb_debouncer_verilator__pch.h"

//============================================================
// Constructors

Vtb_debouncer_verilator::Vtb_debouncer_verilator(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vtb_debouncer_verilator__Syms(contextp(), _vcname__, this)}
    , __PVT____024unit{vlSymsp->TOP.__PVT____024unit}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vtb_debouncer_verilator::Vtb_debouncer_verilator(const char* _vcname__)
    : Vtb_debouncer_verilator(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vtb_debouncer_verilator::~Vtb_debouncer_verilator() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vtb_debouncer_verilator___024root___eval_debug_assertions(Vtb_debouncer_verilator___024root* vlSelf);
#endif  // VL_DEBUG
void Vtb_debouncer_verilator___024root___eval_static(Vtb_debouncer_verilator___024root* vlSelf);
void Vtb_debouncer_verilator___024root___eval_initial(Vtb_debouncer_verilator___024root* vlSelf);
void Vtb_debouncer_verilator___024root___eval_settle(Vtb_debouncer_verilator___024root* vlSelf);
void Vtb_debouncer_verilator___024root___eval(Vtb_debouncer_verilator___024root* vlSelf);

void Vtb_debouncer_verilator::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vtb_debouncer_verilator::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vtb_debouncer_verilator___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vtb_debouncer_verilator___024root___eval_static(&(vlSymsp->TOP));
        Vtb_debouncer_verilator___024root___eval_initial(&(vlSymsp->TOP));
        Vtb_debouncer_verilator___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vtb_debouncer_verilator___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vtb_debouncer_verilator::eventsPending() { return !vlSymsp->TOP.__VdlySched.empty(); }

uint64_t Vtb_debouncer_verilator::nextTimeSlot() { return vlSymsp->TOP.__VdlySched.nextTimeSlot(); }

//============================================================
// Utilities

const char* Vtb_debouncer_verilator::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vtb_debouncer_verilator___024root___eval_final(Vtb_debouncer_verilator___024root* vlSelf);

VL_ATTR_COLD void Vtb_debouncer_verilator::final() {
    Vtb_debouncer_verilator___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vtb_debouncer_verilator::hierName() const { return vlSymsp->name(); }
const char* Vtb_debouncer_verilator::modelName() const { return "Vtb_debouncer_verilator"; }
unsigned Vtb_debouncer_verilator::threads() const { return 1; }
void Vtb_debouncer_verilator::prepareClone() const { contextp()->prepareClone(); }
void Vtb_debouncer_verilator::atClone() const {
    contextp()->threadPoolpOnClone();
}
