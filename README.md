# 🧠 True Dual-Port RAM (TDPRAM) in Verilog

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

---

## 📌 Project Overview

This project implements a **parameterized True Dual-Port RAM (TDPRAM)** using Verilog HDL along with a **self-checking verification environment**.

Unlike conventional single-port RAM, this design allows:

* **Simultaneous read and write operations**
* **Two independent access ports**
* **Improved memory bandwidth and performance**

Each port (Port A and Port B) operates independently with its own address, data, and control signals, making this design suitable for high-performance digital systems.

---

## 🚀 Key Features

* 🔁 Dual independent ports (Port A & Port B)
* ⚡ Concurrent read/write operations
* 🧩 Parameterized memory (scalable design)
* ⏱️ Fully synchronous (posedge clock)
* ⚖️ Deterministic collision handling (Port A priority)
* 🧪 Self-checking testbench
* 📂 File-based stimulus generation
* 🔍 Automated verification with error tracking

---

## 🏗️ Architecture

### 🔹 Memory Design

* Shared memory array: `mem[DEPTH-1:0]`
* Each location stores 8-bit data
* Two independent access paths

### 🔹 Port Interface

| Signal          | Description       |
| --------------- | ----------------- |
| clk             | System clock      |
| rst             | Synchronous reset |
| we_a / we_b     | Write enable      |
| add_a / add_b   | Address inputs    |
| data_a / data_b | Input data        |
| read_a / read_b | Output data       |

---

## 🔄 Operation Logic

| Port A | Port B                    | Behavior           |
| ------ | ------------------------- | ------------------ |
| Write  | Read                      | Parallel operation |
| Read   | Write                     | Parallel operation |
| Read   | Read                      | No conflict        |
| Write  | Write (different address) | Both succeed       |
| Write  | Write (same address)      | ⚠️ Port A priority |

---

## ⚙️ Parameters

| Parameter  | Default | Description                  |
| ---------- | ------- | ---------------------------- |
| ADDR_WIDTH | 5       | Address width (32 locations) |
| DEPTH      | 32      | Memory size                  |
| DATA_WIDTH | 8       | Data width                   |

---

## 📂 Repository Structure

Dual_Port.v          → RTL design (True Dual-Port RAM)  
tb_Dual_Port.v       → Self-checking testbench  
port_a_stim.txt      → Stimulus file for Port A  
port_b_stim.txt      → Stimulus file for Port B  
PROJECT_REPORT.pdf   → Detailed IEEE project report  
README.md            → Project documentation  
 

## 🧾 RTL Code Overview (tdpram.v)

### 🔹 Memory Declaration

```verilog
reg [7:0] mem [DEPTH-1:0];
```

### 🔹 Functional Blocks

* **Reset Logic** → Clears all memory locations synchronously
* **Port A Logic** → Handles read/write with priority
* **Port B Logic** → Handles read/write with collision detection

---

## 🧪 Testbench Overview (tb_tdpram.v)

### 🔹 Features

* Self-checking verification
* Error counter
* Expected memory model

### 🔹 Key Tasks

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

### ✔️ Test Cases Covered

* Basic read/write operations
* Port A and Port B independent operations
* Cross-port data integrity
* Write collision handling
* Simultaneous read/write (different addresses)
* Reset behavior verification

### ✔️ Methodology

* File-based stimulus
* Expected memory comparison
* Automatic mismatch detection

---

## 📈 Simulation Results

All test cases passed successfully.

Errors = 0
Status = PASS

✔ Verified:

* Dual-port functionality
* Collision handling
* Cross-port access
* Reset behavior

---

## ▶️ How to Run

### 🔧 Compile

iverilog -o sim tdpram.v tb_tdpram.v

### ▶️ Run Simulation

vvp sim

### 📉 View Waveform (optional)

gtkwave dump.vcd

---

## 🔍 Key Design Insights

* Dual-port RAM significantly improves throughput
* Collision handling is essential for shared memory
* Parameterized design improves scalability
* Self-checking testbench ensures reliability

---

## ⚠️ Limitations

* Single clock domain only
* No byte-enable support
* Dual always blocks may cause race conditions
* Read-during-write behavior depends on synthesis tool

---

## 🔮 Future Improvements

* Dual clock (clock domain crossing support)
* Byte-enable memory
* Single always block architecture
* SystemVerilog assertions for formal verification

---

## 🧠 Learning Outcomes

* Verilog RTL design
* Memory architecture design
* Functional verification
* Testbench automation
* Handling edge cases in digital systems

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

* Use
* Modify
* Distribute
* Use commercially

Provided that proper credit is given to the original author.

See the LICENSE file for more details.
