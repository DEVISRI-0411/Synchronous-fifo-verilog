# 8×8 Synchronous FIFO Design and Verification using Verilog

## Project Overview

Designed and verified an 8×8 synchronous FIFO (First-In First-Out) buffer using Verilog RTL.

The design uses a memory array, independent read and write pointers, an occupancy counter, and full/empty status flags. A self-checking Verilog testbench was developed to verify normal operations and corner cases through simulation.

---

## FIFO Specifications

| Parameter | Specification |
|-----------|---------------|
| FIFO Type | Synchronous FIFO |
| Data Width | 8 bits |
| FIFO Depth | 8 words |
| Memory Size | 8 × 8 |
| Read Pointer | 3-bit |
| Write Pointer | 3-bit |
| Occupancy Counter | 4-bit |
| Full Flag | Yes |
| Empty Flag | Yes |
| Reset | Synchronous |
| HDL | Verilog |
| Simulator | Icarus Verilog |
| Waveform Viewer | GTKWave |

---

## Architecture

The FIFO consists of the following main components:

- 8 × 8 memory array
- Independent write pointer
- Independent read pointer
- FIFO occupancy counter
- Full status flag
- Empty status flag
- Synchronous reset

### FIFO Operation

Data is written into the memory when:

```text
wr_en = 1
and
full = 0