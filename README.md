# Scrambling and De-Scrambling Implementation Using LFSR on FPGA/ASIC

![Verilog](https://img.shields.io/badge/HDL-Verilog-blue)
![FPGA](https://img.shields.io/badge/Platform-FPGA%20%2F%20ASIC-green)
![Vivado](https://img.shields.io/badge/Tool-Vivado-red)

---

## Project Overview

This project implements a **self-synchronizing Scrambler and Descrambler** using an **8-bit Galois Linear Feedback Shift Register (LFSR)** in Verilog HDL.

The design is intended for both **FPGA prototyping** and **ASIC implementation**, providing a lightweight serial data scrambling system suitable for digital communication applications.

### Features

- 8-bit Galois LFSR implementation
- Self-synchronizing scrambler/descrambler architecture
- Serial (1-bit) data interface
- Active-high synchronous reset
- Modular Verilog RTL
- FPGA and ASIC compatible
- Complete simulation testbench
- Synthesis and physical design implementation flow included

---

# Architecture

The scrambler XORs the input data with the LFSR output to generate scrambled data.

The descrambler performs the same XOR operation using an identical LFSR configuration to recover the original data.

```
                +----------------+
data_in ------->|                |
                |   Scrambler    |------> Scrambled Data
LFSR ---------->|      XOR       |
                +----------------+

Scrambled Data ------------------------------+

                                            |
                                            v

                +----------------+
                |                |
                |  Descrambler   |------> Original Data
LFSR ---------->|      XOR       |
                +----------------+
```

---

# LFSR Polynomial

The implemented 8-bit Galois LFSR uses the primitive polynomial

```
P(x) = 1 + x³ + x⁴ + x⁵ + x⁸
```

The implemented tap connections are

```verilog
lfsr_out[7] <= feedback;
lfsr_out[6] <= lfsr_out[7];
lfsr_out[5] <= lfsr_out[6] ^ feedback;
lfsr_out[4] <= lfsr_out[5] ^ feedback;
lfsr_out[3] <= lfsr_out[4] ^ feedback;
lfsr_out[2] <= lfsr_out[3];
lfsr_out[1] <= lfsr_out[2];
lfsr_out[0] <= lfsr_out[1];
```

---

# Project Structure

```
.
├── rtl
│   ├── top_main.v
│   ├── scrambler.v
│   ├── descrambler.v
│   └── top.v
│
├── sim
│   └── tb_top.v
│
├── internship
│   └── IMPLEMENTATION FLOW
│       ├── SIMULATION.jpeg
│       ├── SYNTHESIS.jpeg
│       ├── FLOORPLAN.jpeg
│       ├── PLACEMENT.jpeg
│       ├── PLACEMENT2.jpeg
│       ├── POWERPLAN.jpeg
│       ├── CTS.jpeg
│       └── ROUTING.jpeg
│
└── README.md
```

---

# Module Hierarchy

```
top
├── scrambler
│   
└── descrambler
```

---

# Input / Output

| Signal | Direction | Description |
|---------|-----------|-------------|
| clk | Input | System Clock |
| reset | Input | Active High Reset |
| data_in | Input | Serial Input Data |
| data_out | Output | Serial Output Data |

---

# Simulation

Behavioral simulation verifies that

- Input data is successfully scrambled.
- The descrambler correctly reconstructs the original data.
- The recovered data matches the transmitted data after the expected pipeline delay.

Simulation waveform:

<p align="center">
  <img src="IMPLEMENTATION%20FLOW/SIMULATION.jpeg" width="700">
</p>

# Synthesis

RTL synthesized successfully.

Highlights:

- No inferred latches
- Fully synchronous design
- FPGA/ASIC synthesizable
- Optimized register implementation

Screenshot:

<p align="center">
  <img src="IMPLEMENTATION%20FLOW/SYNTHESIS.jpeg" width="700">
</p>

# Physical Design Flow

## Floorplanning

Defines the die area and placement region.

<p align="center">
  <img src="IMPLEMENTATION%20FLOW/FLOORPLAN.jpeg" width="700">
</p>

## Placement

Standard cells placed within the core.

<p align="center">
  <img src="IMPLEMENTATION%20FLOW/PLACEMENT.jpeg" width="700">
</p>

<p align="center">
  <img src="IMPLEMENTATION%20FLOW/PLACEMENT2.jpeg" width="700">
</p>

## Power Planning

Power rings and stripes generated.

<p align="center">
  <img src="IMPLEMENTATION%20FLOW/POWERPLAN.jpeg" width="700">
</p>

## Clock Tree Synthesis (CTS)

Balanced clock tree generated with minimized skew.

<p align="center">
  <img src="IMPLEMENTATION%20FLOW/CTS.jpeg" width="700">
</p>

## Routing

Final routed design after timing optimization.

<p align="center">
  <img src="IMPLEMENTATION%20FLOW/ROUTING.jpeg" width="700">
</p>


# Running the Simulation (Vivado)

1. Create a new RTL Project.
2. Add the RTL files.

```
scrambler.v
descrambler.v
top.v
```

3. Add the simulation source

```
tb_top.v
```

4. Set **tb_top** as the simulation top module.

5. Run **Behavioral Simulation**.

---

# Design Highlights

- Modular RTL design
- Self-synchronizing scrambling architecture
- 8-bit Galois LFSR
- Suitable for FPGA and ASIC implementation
- Easy to integrate into serial communication systems
- Fully verified through simulation

---

# Tools Used

- Verilog HDL
- Cadence tools(Xcelium,Genus,Innovus,Vituoso)
- FPGA Design Flow
- ASIC Physical Design Flow

---

# Reference

Lurina, M., Hadiyoso, S., & Astuti, I. (2017).

**Scrambling and De-Scrambling Implementation Using LFSR Method on FPGA**

This project implements an 8-bit Galois LFSR-based scrambler/descrambler inspired by the architecture presented in the above publication.


B.Tech Electronics and Communication Engineering

FPGA | Digital Design | Verilog HDL | ASIC Design
