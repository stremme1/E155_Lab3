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
- **`MUX2_4bit.sv`** - 2-to-1 multiplexer (4-bit)

### **Documentation:**
- **`KEYPAD_WIRING.md`** - Complete wiring instructions for 8-pin keypad

## 🚀 **Ready for Lattice Radiant:**

1. **Use `lab3_top.sv` as your top-level module**
2. **Connect keypad according to `KEYPAD_WIRING.md`**
3. **All modules are SystemVerilog compliant and verified**
4. **Clean pin assignments - no internal signals exposed**

## ✅ **Lab Requirements Met:**
- Single seven_segment instance
- Proper FSM implementation
- Debouncing and metastability prevention
- Dual display with power multiplexing
- Starts with "00" display
