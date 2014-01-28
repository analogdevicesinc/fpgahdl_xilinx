// Declare the module black box
module motor_control_cw (
    ce , 
    clk , 
    kd , 
    ki , 
    kp , 
    motor_speed , 
    new_motor_speed , 
    ref_speed , 
    rst , 
    err , 
    pwm , 
    speed 
    ); // synthesis black_box 


    // Inputs
    input ce;
    input clk;
    input [31:0] kd;
    input [31:0] ki;
    input [31:0] kp;
    input [31:0] motor_speed;
    input new_motor_speed;
    input [31:0] ref_speed;
    input rst;

    // Outputs
    output [31:0] err;
    output [31:0] pwm;
    output [31:0] speed;


//synthesis attribute box_type motor_control_cw "black_box"
endmodule
