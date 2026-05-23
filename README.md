# MIPS CPU

A Verilog-based MIPS CPU implementation developed as a digital system design project.

This repository contains both **multi-cycle** and **pipelined** MIPS CPU designs, together with reference models, program memory files, and Vivado project files for simulation and FPGA-oriented development.

## Project Overview

This project explores the design and implementation of a simplified MIPS processor using Verilog HDL. The main goal is to understand how a processor executes instructions at the hardware level, including:

- Instruction fetch
- Instruction decode
- Execution
- Memory access
- Write-back

The repository includes:

- Multi-cycle MIPS CPU implementation
- Pipelined MIPS CPU implementation
- Pipeline reference model
- Program memory file for instruction testing
- Vivado project files for simulation, synthesis, and FPGA development workflow

## Repository Structure

```text
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
```

## Main Features

### Multi-Cycle CPU

The multi-cycle implementation divides instruction execution into several clock cycles. This design demonstrates how different CPU stages can share hardware resources over time.

Typical stages include:

1. Instruction Fetch
2. Instruction Decode
3. Execute
4. Memory Access
5. Write Back

This structure is useful for understanding CPU control logic, datapath sequencing, and instruction-level execution.

### Pipelined CPU

The pipelined implementation improves instruction throughput by overlapping different stages of multiple instructions. This design demonstrates how modern processors improve performance by processing several instructions at the same time.

Typical pipeline stages include:

1. IF — Instruction Fetch
2. ID — Instruction Decode
3. EX — Execute
4. MEM — Memory Access
5. WB — Write Back

This part of the project focuses on:

- Pipeline datapath design
- Pipeline stage registers
- Control signal propagation
- Instruction flow through the processor
- Waveform-based debugging and verification

### Program Memory

The `prog.mem` file is used to store test instructions for CPU simulation. It allows the CPU to fetch and execute predefined instructions during behavioural simulation.

## Tools Used

- Verilog HDL
- Xilinx Vivado
- XSIM / Vivado Simulator
- FPGA digital design workflow
- Draw.io for architecture diagrams

## Learning Outcomes

Through this project, I gained practical experience in:

- Designing CPU datapaths in Verilog
- Implementing instruction fetch, decode, execute, memory, and write-back logic
- Understanding the difference between multi-cycle and pipelined CPU architectures
- Building and simulating processor control logic
- Using Vivado for HDL simulation and hardware project management
- Debugging CPU behaviour through waveform analysis
- Understanding how hardware-level control signals coordinate instruction execution

## How to Open the Project

Clone the repository:

```bash
git clone https://github.com/TonnyChenProgramming/MIPS_CPU.git
```

Open the Vivado project file:

```text
MIPS_CPU.xpr
```

Then run behavioural simulation in Vivado to inspect CPU execution and waveform behaviour.

## Suggested Simulation Flow

1. Open the project in Vivado.
2. Check that the Verilog source files are correctly included.
3. Load or verify `prog.mem` for instruction memory content.
4. Run behavioural simulation.
5. Inspect waveforms for:
   - Program counter updates
   - Instruction fetch
   - Register file read/write operations
   - ALU operations
   - Memory access
   - Write-back behaviour
   - Pipeline stage behaviour, if using the pipelined CPU

## Notes

This project is intended for learning and demonstrating computer architecture concepts through hardware implementation. It focuses on processor datapath design, control logic, simulation, and FPGA-oriented development rather than building a fully commercial MIPS-compatible processor.
 
