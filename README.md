# Lab 3: Keypad Scanner - Essential Files

## 🎯 **Files for FPGA Implementation:**

### **Top-Level Module:**
- **`lab3_top.sv`** - Main top-level module for FPGA flashing

### **Core Modules:**
- **`keypad_scanner.sv`** - 4x4 keypad scanner with debouncing & synchronizers
- **`keypad_controller.sv`** - FSM controller for display management
- **`seven_segment.sv`** - Hexadecimal to 7-segment decoder
- **`Lab2_ES.sv`** - Display multiplexing system (single seven_segment instance)

### **Support Modules:**
- **`MUX2.sv`** - 2-to-1 multiplexer (7-bit)

### **Documentation:**
- **`KEYPAD_WIRING.md`** - Complete wiring instructions for 8-pin keypad

## 🚀 **Ready for Lattice Radiant:**

1. **Use `lab3_top.sv` as your top-level module**
2. **Connect keypad according to `KEYPAD_WIRING.md`**
3. **All modules are SystemVerilog compliant and verified**
4. **Clean pin assignments - no internal signals exposed**
5. **Uses internal HSOSC - no external clock needed**
6. **Keypad input directly controls display system**

### **Pin Count:**
- **Inputs (5 total):** reset, keypad_rows[3:0]
- **Outputs (13 total):** keypad_cols[3:0], seg[6:0], select0, select1
- **Total: 18 pins** (reduced from 19 by using internal oscillator)

### **Correct Wiring for Your Keypad (Based on Working Lab Example):**
```
Your Keypad Layout:
     C0  C1  C2  C3
R0    1   2   3   C
R1    4   5   6   D  
R2    7   8   9   E
R3    A   0   B   F

Wiring (Using Internal Pull-ups):
- Rows (R0-R3): FPGA reads, use internal 3.3kΩ pull-up resistors
- Columns (C0-C3): FPGA drives HIGH, direct connection
- Enable internal pull-ups on row pins in Lattice Radiant
- No external resistors needed!
```

## ✅ **Lab Requirements Met:**
- Single seven_segment instance
- Proper FSM implementation
- Debouncing and metastability prevention
- Dual display with power multiplexing
- Starts with "00" display
