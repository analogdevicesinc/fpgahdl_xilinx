// ***************************************************************************
// Copyright 2014(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module util_multiplexer (
    input           pwm_ah_0_i,
    input           pwm_al_0_i,
    input           pwm_bh_0_i,
    input           pwm_bl_0_i,
    input           pwm_ch_0_i,
    input           pwm_cl_0_i,
    input           pwm_ah_1_i,
    input           pwm_al_1_i,
    input           pwm_bh_1_i,
    input           pwm_bl_1_i,
    input           pwm_ch_1_i,
    input           pwm_cl_1_i,
    input           fmc_en_0_i,
    input           fmc_en_1_i,
    input   [ 7:0]  gpo_0_i,
    input   [ 7:0]  gpo_1_i,

    output          pwm_ah_o,
    output          pwm_al_o,
    output          pwm_bh_o,
    output          pwm_bl_o,
    output          pwm_ch_o,
    output          pwm_cl_o,
    output          fmc_en_o,
    output  [ 7:0]  gpo_o
);

assign pwm_ah_o = fmc_en_0_i ? pwm_ah_0_i : fmc_en_1_i ? pwm_ah_1_i : 1'b0;
assign pwm_al_o = fmc_en_0_i ? pwm_al_0_i : fmc_en_1_i ? pwm_al_1_i : 1'b0;
assign pwm_bh_o = fmc_en_0_i ? pwm_bh_0_i : fmc_en_1_i ? pwm_bh_1_i : 1'b0;
assign pwm_bl_o = fmc_en_0_i ? pwm_bl_0_i : fmc_en_1_i ? pwm_bl_1_i : 1'b0;
assign pwm_ch_o = fmc_en_0_i ? pwm_ch_0_i : fmc_en_1_i ? pwm_ch_1_i : 1'b0;
assign pwm_cl_o = fmc_en_0_i ? pwm_cl_0_i : fmc_en_1_i ? pwm_cl_1_i : 1'b0;
assign gpo_o    = gpo_0_i | gpo_1_i;
assign fmc_en_o = fmc_en_0_i | fmc_en_1_i;

endmodule
