# MIPS CPU

A Verilog-based MIPS CPU implementation developed as a digital system design project.  
This repository contains both multi-cycle and pipelined CPU designs, together with reference models, memory program files, and Vivado project files for simulation and FPGA-oriented development.

## Project Overview

This project explores the design and implementation of a simplified MIPS processor using Verilog HDL. The main goal is to understand how a processor executes instructions at the hardware level, including instruction fetch, decode, execution, memory access, and write-back.

The repository includes:

- A multi-cycle MIPS CPU implementation
- A pipelined MIPS CPU implementation
- A pipeline reference model
- Program memory file for instruction testing
- Vivado project files for simulation, synthesis, and hardware design workflow

## Repository Structure

MIPS_CPU/
├── VerilogFiles/
│   ├── Multi_Cycle/              # Multi-cycle MIPS CPU implementation
│   ├── Pipeline/                 # Pipelined MIPS CPU implementation
│   ├── PipelineReferenceModel/   # Reference model for pipeline behaviour
│   └── prog.mem                  # Program memory file for simulation/testing
├── MIPS_CPU.srcs/                # Vivado source files
├── MIPS_CPU.sim/                 # Vivado simulation files
├── MIPS_CPU.runs/                # Vivado synthesis/implementation runs
├── MIPS_CPU.hw/                  # Hardware-related Vivado files
├── MIPS_CPU.xpr                  # Vivado project file
└── Draftmisp.drawio              # CPU architecture/design diagram
Main Features
Multi-Cycle CPU

The multi-cycle implementation divides instruction execution into several clock cycles. This design helps demonstrate how different CPU stages share hardware resources over time.

Typical stages include:

Instruction Fetch
Instruction Decode
Execute
Memory Access
Write Back

This structure is useful for understanding CPU control logic, datapath sequencing, and instruction-level execution.

Pipelined CPU

The pipelined implementation improves instruction throughput by overlapping different stages of multiple instructions. This design demonstrates how modern processors increase performance by allowing several instructions to be processed simultaneously.

Typical pipeline stages include:

IF — Instruction Fetch
ID — Instruction Decode
EX — Execute
MEM — Memory Access
WB — Write Back

This part of the project focuses on pipeline datapath design, stage registers, control signal propagation, and instruction flow.

Program Memory

The prog.mem file is used to store test instructions for CPU simulation. It allows the CPU to fetch and execute predefined instructions during behavioural simulation.

Tools Used
Verilog HDL
Xilinx Vivado
XSIM / Vivado Simulator
FPGA digital design workflow
Draw.io for architecture diagrams
Learning Outcomes

Through this project, I gained practical experience in:

Designing CPU datapaths in Verilog
Implementing instruction fetch, decode, execute, memory, and write-back logic
Understanding the difference between multi-cycle and pipelined CPU architectures
Building and simulating processor control logic
Using Vivado for HDL simulation and hardware project management
Debugging CPU behaviour through waveform analysis
How to Open the Project
Clone the repository:
git clone https://github.com/TonnyChenProgramming/MIPS_CPU.git
Open the Vivado project file:
MIPS_CPU.xpr
In Vivado, run behavioural simulation to inspect CPU execution and waveform behaviour.
Suggested Simulation Flow
Open the project in Vivado.
Check that the Verilog source files are correctly included.
Load or verify prog.mem for instruction memory content.
Run behavioural simulation.
Inspect waveforms for:
Program counter updates
Instruction fetch
Register file read/write
ALU operations
Memory access
Pipeline stage behaviour, if using the pipelined CPU
Notes

This project is intended for learning and demonstrating computer architecture concepts through hardware implementation. It focuses on processor datapath design, control logic, simulation, and FPGA-oriented development rather than building a fully commercial MIPS-compatible processor.
