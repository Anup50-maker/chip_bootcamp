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

    # Test case 1: Stone (00) vs Scissors (10) -> P1 wins (output should be 49)
    dut.ui_in.value = 0b00001000  # P1=00, P2=10
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 49, f"Expected 49 (P1 wins), got {dut.uo_out.value}"

    # Test case 2: Paper (01) vs Paper (01) -> Tie (output should be 0)
    dut.ui_in.value = 0b01010100  # P1=01, P2=01
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0, f"Expected 0 (Tie), got {dut.uo_out.value}"

    # Test case 3: Invalid move (11) -> Output should be 63
    dut.ui_in.value = 0b11000000  # P1=11 (invalid)
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 63, f"Expected 63 (Invalid), got {dut.uo_out.value}"

    dut._log.info("All tests passed!")
