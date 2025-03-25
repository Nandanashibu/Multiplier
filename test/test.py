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
    dut.ui_in.value = 20  # Example input A
    dut.uio_in.value = 30  # Example input B

    # Wait for one clock cycle to see the output values
    await ClockCycles(dut.clk, 1)

    # Check if the output matches the expected multiplication result
    assert dut.uo_out.value == (20 * 30), f"Expected {20 * 30}, got {dut.uo_out.value}"

    # Additional test cases can be added here by changing input values,
    # waiting for clock cycles, and asserting expected outputs.
