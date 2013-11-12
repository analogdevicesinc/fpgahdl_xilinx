// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
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

module cf_hdmi_16b_es (
  // hdmi input (to vdma) interface

  h2v_hdmi_clk,
  h2v_hdmi_data,

  // vdma clock

  vdma_clk,

  // vdma output (from hdmi) interface

  h2v_vdma_fs,
  h2v_vdma_fs_ret,
  h2v_vdma_valid,
  h2v_vdma_be,
  h2v_vdma_data,
  h2v_vdma_last,
  h2v_vdma_ready,

  // processor signals

  up_rstn,
  up_clk,
  up_sel,
  up_rwn,
  up_addr,
  up_wdata,
  up_rdata,
  up_ack,
  up_status,

  // debug signals (chipscope)

  vdma_dbg_data,
  vdma_dbg_trigger,
  h2v_dbg_data,
  h2v_dbg_trigger);

  input           h2v_hdmi_clk;
  input   [15:0]  h2v_hdmi_data;

  input           vdma_clk;
  output          h2v_vdma_fs;
  input           h2v_vdma_fs_ret;
  output          h2v_vdma_valid;
  output  [ 7:0]  h2v_vdma_be;
  output  [63:0]  h2v_vdma_data;
  output          h2v_vdma_last;
  input           h2v_vdma_ready;

  input           up_rstn;
  input           up_clk;
  input           up_sel;
  input           up_rwn;
  input   [ 4:0]  up_addr;
  input   [31:0]  up_wdata;
  output  [31:0]  up_rdata;
  output          up_ack;
  output  [ 7:0]  up_status;

  output  [75:0]  vdma_dbg_data;
  output  [15:0]  vdma_dbg_trigger;
  output  [61:0]  h2v_dbg_data;
  output  [ 7:0]  h2v_dbg_trigger;

  // hdmi to vdma (hdmi input)
  cf_h2v i_h2v (
    .hdmi_clk (h2v_hdmi_clk),
    .hdmi_data (h2v_hdmi_data),
    .vdma_clk (vdma_clk),
    .vdma_fs (h2v_vdma_fs),
    .vdma_fs_ret (h2v_vdma_fs_ret),
    .vdma_valid (h2v_vdma_valid),
    .vdma_be (h2v_vdma_be),
    .vdma_data (h2v_vdma_data),
    .vdma_last (h2v_vdma_last),
    .vdma_ready (h2v_vdma_ready),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_sel (up_sel),
    .up_rwn (up_rwn),
    .up_addr (up_addr),
    .up_wdata (up_wdata),
    .up_rdata (up_rdata),
    .up_ack (up_ack),
    .up_status (up_status),
    .vdma_dbg_data (vdma_dbg_data[39:0]),
    .vdma_dbg_trigger (vdma_dbg_trigger[7:0]),
    .hdmi_dbg_data (h2v_dbg_data),
    .hdmi_dbg_trigger (h2v_dbg_trigger));

endmodule

// ***************************************************************************
// ***************************************************************************
