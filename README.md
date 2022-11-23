# EYRC'22 Swatchhta Bot

- ## Task - 1
  _Objective_: To understand Verilog HDL basics and design methodologies. 
  * [Task 1A](https://github.com/Kishore-R-0x07/eyrc22_SB_3647/tree/main/Task%201/Task%201A) : Combinational Circuit <br>
  **Problem Statement** : Design a combinational circuit to implement 3-input logic function using 8:1 multiplexer and octal-to-binary encoder.
  
  * [Task 1B](https://github.com/Kishore-R-0x07/eyrc22_SB_3647/tree/main/Task%201/Task%201B) : Finite State Machine <br>
  **Problem Statement** : Design a Finite State Machine in Verilog HDL to detect sequence/pattern.
  
  * [Task 1C](https://github.com/Kishore-R-0x07/eyrc22_SB_3647/tree/main/Task%201/Task%201C) : Frequency Counter <br>
  **Problem Statement** : Design a frequency counter which detects frequency of input signal.
  
  * [Task 1D](https://github.com/Kishore-R-0x07/eyrc22_SB_3647/tree/main/Task%201/Task%201D) : Frequency Scaling and PWM <br>
  **Problem Statement** : Implement frequency scaling in Verilog HDL and also implement Pulse Width Modulation.
  

- ## Task - 2

  _Objective_: To study ADC, UART communication protocol, and path planning algorithm.
  * [Task 2A](https://github.com/Kishore-R-0x07/eyrc22_SB_3647/tree/main/Task%202/Task%202A) : ADC <br>
  **Problem Statement** : Design a control module which will communicate with on board ADC (Analog to Digital Converter) and fetch the digital output.
  
  * [Task 2C](Task%202/Task%202C) : Path Planning <br>
  **Problem Statement** : Find the shortest path between two nodes in the arena using any path planning algorithm.
  <img src="https://lh4.googleusercontent.com/r6UFOHhcKxqok5h9F76prWv4ka6pO9_IBsquvMwHqHvV47mwfFyMLeXcT8rXrxDPKue76E80GVJtkgfOD4QKaacMPKgM1WiJZUpY5-pHEzZbqaoswvT9_CLsYQXkX8cp2hwzgEOFH0q-2UyzsfXWhJL_0I38_UtgSOApf6xiGvXtO6l6yWWPOHUkEA" width="500" height="500">
  
  We used the Dijkstra algorithm for solving this problem.
 


## Handling Verilog Files
```
iverilog <testbench_file> <topmodule file> <additional verilog files> ..
vvp a.out
```
Or, alternatively:
```
iverilog -o <filename>.vvp <testbench_file> <topmodule file> <additional verilog files> ..
vvp <filename>.vvp
```

Now, to see waveforms using an application like GTKWave, add the following code inside your testbench module:
```
initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
end
```
Then, you can view _dump.vcd_ file using the desired application.
