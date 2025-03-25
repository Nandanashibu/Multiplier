# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Set the input values you want to test
    dut.ui_in.value = 0x32  # B=3 (0b0011), A=2 (0b0010) → 3*2=6
    dut.uio_in.value = 0    # Unused (must be 0)

    # Wait for one clock cycle to see the output values
    await ClockCycles(dut.clk, 1)

    # Check if the output matches the expected multiplication result
    assert dut.uo_out.value == 6, f"Expected 6, got {dut.uo_out.value}"

    # Additional test case
    dut.ui_in.value = 0xFF  # B=15, A=15 → 15*15=225
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 225, f"Expected 225, got {dut.uo_out.value}"

    # Additional test cases can be added here by changing input values,
    # waiting for clock cycles, and asserting expected outputs.
