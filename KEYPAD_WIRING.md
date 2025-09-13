# E155 Lab 3: Keypad Wiring Guide

## 🔌 **Keypad Pinout**

Your 4x4 keypad has **9 pins total**:
- **4 Row pins** (R0, R1, R2, R3)
- **4 Column pins** (C0, C1, C2, C3)
- **1 Ground pin** (GND)

## 📋 **Keypad Layout**

```
    C0    C1    C2    C3
R0   0     4     8     C
R1   1     5     9     D  
R2   2     6     A     E
R3   3     7     B     F
```

## 🔗 **FPGA Connections**

### **Your SystemVerilog Interface:**
```systemverilog
module Lab3_ES (
    input  logic [3:0]  keypad_rows,   // 4 row inputs
    output logic [3:0]  keypad_cols,   // 4 column outputs
    // ... other signals
);
```

### **Pin Assignments:**

| Keypad Pin | FPGA Pin | Signal Name | Direction |
|------------|----------|-------------|-----------|
| R0 (Row 0) | FPGA Pin | keypad_rows[0] | Input |
| R1 (Row 1) | FPGA Pin | keypad_rows[1] | Input |
| R2 (Row 2) | FPGA Pin | keypad_rows[2] | Input |
| R3 (Row 3) | FPGA Pin | keypad_rows[3] | Input |
| C0 (Col 0) | FPGA Pin | keypad_cols[0] | Output |
| C1 (Col 1) | FPGA Pin | keypad_cols[1] | Output |
| C2 (Col 2) | FPGA Pin | keypad_cols[2] | Output |
| C3 (Col 3) | FPGA Pin | keypad_cols[3] | Output |
| GND | GND | Ground | Ground |

## ⚡ **How It Works**

### **Column Scanning:**
Your FPGA outputs a "1" on one column at a time:
```
Clock Cycle 1: keypad_cols = 4'b0001 (Column 0 active)
Clock Cycle 2: keypad_cols = 4'b0010 (Column 1 active)  
Clock Cycle 3: keypad_cols = 4'b0100 (Column 2 active)
Clock Cycle 4: keypad_cols = 4'b1000 (Column 3 active)
```

### **Row Detection:**
When you press a key, it connects a row to the active column:
```
Press Key '5': Connects Row 1 to Column 1
- keypad_cols[1] = 1 (Column 1 active)
- keypad_rows[1] = 1 (Row 1 connected)
- Result: key_detected = 1, detected_key = 0x5
```

## 🔧 **Physical Wiring**

### **Step 1: Identify Keypad Pins**
Most keypads have pins labeled or numbered. Common layouts:
- **9-pin header**: Usually R0, R1, R2, R3, C0, C1, C2, C3, GND
- **Check with multimeter**: Press a key and measure continuity
- **GND pin**: Usually connected to all row/column switches

### **Step 2: Connect to FPGA**
```
Keypad R0 → FPGA Pin (keypad_rows[0])
Keypad R1 → FPGA Pin (keypad_rows[1])
Keypad R2 → FPGA Pin (keypad_rows[2])
Keypad R3 → FPGA Pin (keypad_rows[3])
Keypad C0 → FPGA Pin (keypad_cols[0])
Keypad C1 → FPGA Pin (keypad_cols[1])
Keypad C2 → FPGA Pin (keypad_cols[2])
Keypad C3 → FPGA Pin (keypad_cols[3])
Keypad GND → GND (Ground)
```

### **Step 3: External Pull-up Resistors (Required)**
Add **10kΩ pull-up resistors** on the row inputs:
```
VCC (3.3V) → 10kΩ → keypad_rows[0] → Keypad R0
VCC (3.3V) → 10kΩ → keypad_rows[1] → Keypad R1
VCC (3.3V) → 10kΩ → keypad_rows[2] → Keypad R2
VCC (3.3V) → 10kΩ → keypad_rows[3] → Keypad R3
```

**Breadboard Layout:**
```
VCC (3.3V) ──┬── 10kΩ ── keypad_rows[0] ── Keypad R0
             ├── 10kΩ ── keypad_rows[1] ── Keypad R1
             ├── 10kΩ ── keypad_rows[2] ── Keypad R2
             └── 10kΩ ── keypad_rows[3] ── Keypad R3
```

## 🧪 **Testing Your Connections**

### **Method 1: Multimeter Test**
1. Set multimeter to continuity mode
2. Press key '0' (Row 0, Col 0)
3. Should see continuity between R0 and C0
4. Test all 16 keys

### **Method 2: FPGA Test**
1. Program your FPGA
2. Press keys and check display
3. Should see: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, A, B, C, D, E, F

## ⚠️ **Common Issues**

### **Problem: No Response**
- **Check**: 10kΩ pull-up resistors on row inputs
- **Check**: Correct pin assignments
- **Check**: Keypad pinout (use multimeter)

### **Problem: Wrong Keys**
- **Check**: Row/column connections swapped
- **Check**: Keypad pinout matches your wiring

### **Problem: Multiple Keys**
- **Check**: 10kΩ pull-up resistors properly connected
- **Check**: Clean connections
- **Check**: Keypad not damaged

## 📋 **Lattice Radiant Setup**

### **Step 1: Create New Project**
1. Open Lattice Radiant
2. Create new project
3. Select your Lattice FPGA device
4. Add your SystemVerilog files

### **Step 2: Pin Assignment**
1. Go to **Tools → Spreadsheet View**
2. Assign pins for your keypad:
```
keypad_rows[0] → Pin A1
keypad_rows[1] → Pin A2  
keypad_rows[2] → Pin A3
keypad_rows[3] → Pin A4
keypad_cols[0] → Pin B1
keypad_cols[1] → Pin B2
keypad_cols[2] → Pin B3
keypad_cols[3] → Pin B4
```

### **Step 3: Add External Pull-up Resistors**
1. Connect 10kΩ resistors from VCC (3.3V) to each row input
2. This ensures row inputs are HIGH when no key is pressed
3. When a key is pressed, it pulls the row input LOW

### **Step 4: Synthesis and Programming**
1. Run **Synthesis** (F5)
2. Run **Place & Route** (F6)
3. Program your FPGA

## 🎯 **Summary**

1. **9 pins total**: 4 rows (inputs) + 4 columns (outputs) + 1 ground
2. **Pull-up resistors**: 10kΩ external resistors on all row inputs
3. **Ground connection**: Connect keypad GND to FPGA GND
4. **Column scanning**: FPGA drives one column at a time
5. **Row detection**: FPGA reads which row is connected
6. **Test with multimeter**: Verify keypad pinout first

Your keypad will work perfectly once you get the pinout right and add the 10kΩ pull-up resistors! 🚀
