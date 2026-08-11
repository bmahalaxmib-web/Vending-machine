# Vending Machine FSM in Verilog

A synthesizable **Vending Machine Controller** designed using Verilog HDL and a **Finite State Machine (FSM)**.

The vending machine accepts **₹5 and ₹10 coins** and dispenses an item costing **₹15**. If the user inserts ₹20, the machine dispenses the item and provides **₹5 change**.

The project includes Verilog RTL, a simulation testbench, expected output, and GTKWave waveform support.

---

## Features

* Verilog HDL implementation
* Finite State Machine (FSM)
* Accepts ₹5 and ₹10 coins
* Product price = ₹15
* Automatic product dispensing
* ₹5 change generation
* Synchronous active-high reset
* Synthesizable RTL
* Verilog testbench
* Icarus Verilog simulation
* GTKWave waveform analysis
* Suitable for FPGA implementation

---

## Vending Machine Specifications

| Parameter                  | Value |
| -------------------------- | ----- |
| Product price              | ₹15   |
| Accepted coin              | ₹5    |
| Accepted coin              | ₹10   |
| Maximum normal transaction | ₹20   |
| Change available           | ₹5    |
| FSM states                 | 3     |

---

## Inputs and Outputs

### Inputs

| Signal    | Width | Description                 |
| --------- | ----: | --------------------------- |
| `clk`     | 1 bit | System clock                |
| `rst`     | 1 bit | Active-high reset           |
| `coin_5`  | 1 bit | Indicates ₹5 coin inserted  |
| `coin_10` | 1 bit | Indicates ₹10 coin inserted |

### Outputs

| Signal     | Width | Description           |
| ---------- | ----: | --------------------- |
| `dispense` | 1 bit | Dispenses the product |
| `change_5` | 1 bit | Returns ₹5 change     |

Only one coin input should be asserted during a transaction.

---

## FSM States

The machine uses three states representing the amount currently inserted.

| State | Amount |
| ----- | -----: |
| `S0`  |     ₹0 |
| `S5`  |     ₹5 |
| `S10` |    ₹10 |

### State Encoding

```text id="f2y8k1"
S0  = 00
S5  = 01
S10 = 10
```

---

## State Diagram

```text id="p8p24a"
                         ₹5
                    ┌──────────┐
                    │          ▼
                 ┌──────┐   ┌──────┐
                 │  S0  │   │  S5  │
                 │ ₹0   │   │ ₹5   │
                 └──┬───┘   └──┬───┘
                    │           │
                  ₹10         ₹10
                    │           │
                    ▼           ▼
                 ┌──────┐      S0
                 │ S10  │
                 │ ₹10  │
                 └──┬───┘
                    │
                   ₹5
                    │
                    ▼
              DISPENSE ITEM
                 ₹15

              S10 + ₹10
                 = ₹20
                    │
                    ▼
              DISPENSE ITEM
                    +
              RETURN ₹5
```

---

## How It Works

The vending machine tracks the total amount inserted using its FSM state.

### Starting State

The machine starts at:

```text id="5qfj2k"
S0 = ₹0
```

### Insert ₹5

```text id="3w3y2h"
S0 + ₹5 → S5
```

No product is dispensed yet.

### Insert ₹10 from S5

```text id="j5v0yw"
S5 + ₹10 → ₹15
```

The machine:

```text id="4j4vmu"
dispense = 1
change_5 = 0
```

and returns to `S0`.

### Insert ₹10 from S0

```text id="8wqglh"
S0 + ₹10 → S10
```

The machine waits for another coin.

### Insert ₹5 from S10

```text id="d1j4gv"
S10 + ₹5 = ₹15
```

Result:

```text id="n4ufqn"
dispense = 1
change_5 = 0
```

### Insert ₹10 from S10

```text id="2ewy8v"
S10 + ₹10 = ₹20
```

Since:

```text id="j0d1hd"
₹20 - ₹15 = ₹5
```

the machine produces:

```text id="a7yj8n"
dispense = 1
change_5 = 1
```

---

## Transaction Examples

### Transaction 1: ₹5 + ₹10

```text id="z5qqo4"
₹0
 ↓ ₹5
₹5
 ↓ ₹10
₹15
 ↓
DISPENSE
```

Output:

```text id="3qkv3v"
dispense = 1
change_5 = 0
```

---

### Transaction 2: ₹10 + ₹5

```text id="j46wpk"
₹0
 ↓ ₹10
₹10
 ↓ ₹5
₹15
 ↓
DISPENSE
```

Output:

```text id="p7em4m"
dispense = 1
change_5 = 0
```

---

### Transaction 3: ₹10 + ₹10

```text id="4v7txe"
₹0
 ↓ ₹10
₹10
 ↓ ₹10
₹20
 ↓
DISPENSE + ₹5 CHANGE
```

Output:

```text id="2h6i3f"
dispense = 1
change_5 = 1
```

---

### Transaction 4: ₹5 + ₹5 + ₹5

```text id="r6c8n8"
₹0
 ↓ ₹5
₹5
 ↓ ₹5
₹10
 ↓ ₹5
₹15
 ↓
DISPENSE
```

Output:

```text id="wqj1zv"
dispense = 1
change_5 = 0
```

---

## Project Structure

```text id="qk5t3j"
vending-machine-verilog/
│
├── rtl/
│   └── vending_machine.v
│
├── tb/
│   └── vending_machine_tb.v
│
├── simulation/
│   └── vending_machine.vcd
│
└── README.md
```

---

## Simulation

### Required Tools

* Icarus Verilog
* GTKWave

### Compile

From the project root:

```bash id="p3j4n6"
iverilog -o vending_sim rtl/vending_machine.v tb/vending_machine_tb.v
```

### Run

```bash id="5v1z1g"
vvp vending_sim
```

### View Waveform

```bash id="9h8pvs"
gtkwave vending_machine.vcd
```

---

## Expected Simulation Output

```text id="3t8m7s"
---------------------------------------------
          VENDING MACHINE TEST
        ITEM PRICE = ₹15
---------------------------------------------

TEST 1: INSERT ₹5 + ₹10
TIME=36 ns  | COIN=₹5  | DISPENSE=0 | CHANGE_₹5=0
TIME=56 ns  | COIN=₹10 | DISPENSE=1 | CHANGE_₹5=0

TEST 2: INSERT ₹10 + ₹5
TIME=76 ns  | COIN=₹10 | DISPENSE=0 | CHANGE_₹5=0
TIME=96 ns  | COIN=₹5  | DISPENSE=1 | CHANGE_₹5=0

TEST 3: INSERT ₹10 + ₹10
TIME=116 ns | COIN=₹10 | DISPENSE=0 | CHANGE_₹5=0
TIME=136 ns | COIN=₹10 | DISPENSE=1 | CHANGE_₹5=1

TEST 4: INSERT ₹5 + ₹5 + ₹5
TIME=156 ns | COIN=₹5  | DISPENSE=0 | CHANGE_₹5=0
TIME=176 ns | COIN=₹5  | DISPENSE=0 | CHANGE_₹5=0
TIME=196 ns | COIN=₹5  | DISPENSE=1 | CHANGE_₹5=0

---------------------------------------------
          SIMULATION COMPLETE
---------------------------------------------
```

---

## Waveform Verification

The following signals can be viewed in GTKWave:

```text id="j7by4q"
clk
rst
coin_5
coin_10
dispense
change_5
dut.state
```

When the inserted amount reaches ₹15 or more, the output should assert.

For ₹15:

```text id="0uf7zv"
dispense = 1
change_5 = 0
```

For ₹20:

```text id="n8p9kr"
dispense = 1
change_5 = 1
```

---

## Timing

The vending machine operates synchronously with the rising edge of `clk`.

```text id="d0c0ij"
       ┌───┐   ┌───┐   ┌───┐
clk ───┘   └───┘   └───┘   └───

       ↑       ↑       ↑
     Coin    Coin    State
    Input   Input   Update
```

Coin inputs should be presented around a clock cycle.

---

## Applications

FSM-based vending machine controllers are useful for learning:

* Digital logic design
* Finite State Machines
* Sequential circuits
* Control systems
* FPGA design
* Embedded systems
* Transaction controllers
* Automated systems

The same FSM principles can be applied to:

* Ticket machines
* ATM controllers
* Washing machines
* Traffic-light controllers
* Elevator controllers
* Parking systems
* Access-control systems

---

## Learning Outcomes

This project demonstrates:

* Verilog HDL
* Finite State Machine design
* State encoding
* Sequential logic
* Combinational logic
* State transitions
* Output generation
* Control-system design
* Testbench development
* Simulation
* GTKWave waveform analysis
* FPGA-oriented RTL design

---

## Design Approach

The controller uses a **Moore-style state representation with coin-dependent output logic** to keep track of the inserted amount.

The main states are:

```text id="e4w7w9"
S0
S5
S10
```

The state machine returns to `S0` after dispensing an item.

This ensures that a new transaction can begin immediately after the previous transaction.

---

## Future Improvements

Possible extensions include:

1. Support ₹1 and ₹2 coins
2. Add ₹20 and ₹50 notes
3. Multiple products
4. Product selection input
5. Product inventory tracking
6. Cancel/refund button
7. Multiple change denominations
8. 7-segment display for inserted amount
9. LCD display interface
10. Keypad-based product selection
11. FPGA board implementation
12. Password/security mode
13. Error handling for invalid coin inputs

---

## FPGA Implementation

The design can be implemented on an FPGA development board.

Example:

```text id="3n6b1f"
       Push Buttons
           │
           │
     ┌─────▼─────┐
     │   FPGA    │
     │            │
     │ Vending    │
     │ Machine    │
     │ Controller │
     └─────┬──────┘
           │
      ┌────┴────┐
      ▼         ▼
   DISPENSE   CHANGE
      │         │
      ▼         ▼
   Product    Coin
```

Push buttons can be used to simulate coin insertion, while LEDs can indicate:

```text id="9cgynf"
LED 1 → DISPENSE
LED 2 → ₹5 CHANGE
```

---

## Tools Used

| Tool           | Purpose           |
| -------------- | ----------------- |
| Verilog HDL    | RTL Design        |
| Icarus Verilog | Simulation        |
| GTKWave        | Waveform Analysis |
| Git            | Version Control   |
| GitHub         | Project Hosting   |

---
