# Synchronous FIFO – Verilog RTL Design & Verification

## Project Overview

This project implements and verifies a synchronous FIFO (First-In First-Out) memory using Verilog.

The FIFO is designed with:

- 8-bit data width
- 8-word storage depth
- Separate read and write pointers
- Occupancy counter
- Full and empty status flags
- Synchronous reset
- Self-checking verification testbench

The project focuses on RTL design, memory organization, pointer management, status flags, and corner-case verification.

---

## Architecture

### FIFO Specifications

| Parameter | Value |
|---|---:|
| Data Width | 8 bits |
| FIFO Depth | 8 words |
| Address Width | 3 bits |
| Counter Width | 4 bits |
| Clock | Synchronous |
| Reset | Synchronous |

### Main Components

1. **Memory Array**
   - Stores eight 8-bit data values.

2. **Write Pointer**
   - Points to the location where the next data item will be written.

3. **Read Pointer**
   - Points to the location from which the next data item will be read.

4. **Occupancy Counter**
   - Tracks the number of data elements currently stored in the FIFO.

5. **Full Flag**
   - Asserted when the FIFO contains eight data elements.

6. **Empty Flag**
   - Asserted when the FIFO contains zero data elements.

---

## FIFO Operation

### Write Operation

Data is written into the memory when:

```text
wr_en = 1
and
full = 0