# 🧠 True Dual-Port RAM (TDPRAM) in Verilog

---

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

## 📌 Project Overview

This project implements a **parameterized True Dual-Port RAM (TDPRAM)** using Verilog HDL along with a **self-checking verification environment**.

Unlike single-port memory, TDPRAM allows:

* **Simultaneous read/write operations**
* **Two independent access ports**
* **Higher bandwidth and performance**

This design is widely used in:

* FPGA-based systems
* Digital Signal Processing (DSP)
* Communication buffers
* Multi-core architectures

---

## 🚀 Key Features

* 🔁 Dual independent ports (Port A & Port B)
* ⚡ Concurrent read/write support
* 🧩 Parameterized design (scalable memory)
* ⏱️ Fully synchronous (posedge clock)
* ⚖️ Deterministic collision handling (Port A priority)
* 🧪 Self-checking testbench
* 📂 File-based stimulus generation
* 🔍 Automated verification with error tracking

---

## 🏗️ System Architecture

### 🔹 Memory Structure

* Shared memory array: `mem[DEPTH-1:0]`
* Each location: 8-bit data
* Two independent access paths

### 🔹 Port Interface

| Signal          | Description       |
| --------------- | ----------------- |
| clk             | System clock      |
| rst             | Synchronous reset |
| we_a / we_b     | Write enable      |
| add_a / add_b   | Address inputs    |
| data_a / data_b | Write data        |
| read_a / read_b | Output data       |

---

## 🔄 Operation Logic

### ✅ Read/Write Behavior

| Port A | Port B                    | Result         |
| ------ | ------------------------- | -------------- |
| Write  | Read                      | Parallel       |
| Read   | Write                     | Parallel       |
| Read   | Read                      | No conflict    |
| Write  | Write (different address) | Both succeed   |
| Write  | Write (same address)      | ⚠️ Port A wins |

---

## ⚙️ Parameters

| Parameter  | Default | Description                  |
| ---------- | ------- | ---------------------------- |
| ADDR_WIDTH | 5       | Address width (32 locations) |
| DEPTH      | 32      | Memory size                  |
| DATA_WIDTH | 8       | Data width                   |

---

## 📂 Repository Structure

true-dual-port-ram-verilog/
│
├── rtl/
│   └── tdpram.v              # RTL design (main module)
│
├── tb/
│   └── tb_tdpram.v           # Testbench (self-checking)
│
├── stimulus/
│   ├── port_a_stim.txt       # Input vectors for Port A
│   └── port_b_stim.txt       # Input vectors for Port B
│
├── results/
│   ├── waveform.png          # GTKWave output
│   └── simulation_log.txt    # Console results
│
├── docs/
│   └── TDPRAM_Report.pdf     # IEEE report
│
├── README.md
└── .gitignore

---

## 🧾 RTL Code Structure (tdpram.v)

### 🔹 Memory Declaration

```verilog
reg [7:0] mem [DEPTH-1:0];
```

### 🔹 Reset Logic

* Synchronous reset clears all memory locations to `0`

### 🔹 Port A Logic

* Writes data when `we_a = 1`
* Reads data when `we_a = 0`
* Has **priority in collision**

### 🔹 Port B Logic

* Handles collision detection
* Writes only if no conflict or different address

---

## 🧪 Testbench Structure (tb_tdpram.v)

### 🔹 Features

* Self-checking mechanism
* Error counter
* Expected memory model

### 🔹 Tasks Included

* `apply_reset`
* `write_stimulus_files`
* `apply_port_a_from_file`
* `apply_port_b_from_file`
* `cross_port_verify`
* `collision_test`
* `sim_rw_diff_addr`
* `post_reset_check`

---

## 📊 Verification Strategy

### ✔️ Test Scenarios

* Basic read/write
* Port A operations
* Port B operations
* Cross-port verification
* Write collision
* Simultaneous access
* Reset verification

### ✔️ Method

* File-based stimulus
* Expected memory comparison
* Automatic mismatch detection

---

## 📈 Simulation Results

All test cases passed successfully:

Errors = 0
Status = PASS

✔ Verified:

* Data integrity
* Collision handling
* Parallel operation
* Reset behavior

---

## ▶️ How to Run

### 🔧 Compile

```
iverilog -o sim rtl/tdpram.v tb/tb_tdpram.v
```

### ▶️ Run

```
vvp sim
```

### 📉 Waveform

```
gtkwave dump.vcd
```

---

## 🔍 Key Design Insights

* Dual-port memory improves throughput
* Collision handling is critical in shared memory
* Parameterization increases reusability
* Self-checking testbench ensures reliability

---

## ⚠️ Limitations

* Single clock domain only
* No byte-enable support
* Dual always blocks → possible race condition
* Read-during-write is tool dependent

---

## 🔮 Future Improvements

* Dual clock (CDC support)
* Byte-enable memory
* Single always block architecture
* SystemVerilog assertions

---

## 🧠 Learning Outcomes

* RTL design using Verilog
* Memory architecture design
* Functional verification techniques
* Testbench automation
* Handling hardware corner cases

---

## 👨‍💻 Author

**Mitanshu Dhameliya**
Electronics & Communication Engineering
Nirma University

---

## 📚 References

* IEEE 1364 Verilog Standard
* Samir Palnitkar – Verilog HDL
* Xilinx / Intel FPGA Documentation

---

## ⭐ Acknowledgment

This project was completed as part of the **Testing and Verification of Digital Circuits** course.

---

## 📌 License
This project is licensed under the MIT License.

You are free to:
- Use
- Modify
- Distribute
- Use commercially

Provided that proper credit is given to the original author.

See the LICENSE file for more details.
