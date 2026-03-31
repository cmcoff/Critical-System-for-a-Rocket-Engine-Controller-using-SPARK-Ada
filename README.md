# Critical-System-for-a-Rocket-Engine-Controller-using-SPARK-Ada
This system models a rocket engine controller. In doing so, this system monitors four important 
variables of a rocket engine. The system monitors the chamber pressure, chamber temperature, 
thrust, and fuel level. During each controller cycle, the user enters values for these variables to 
simulate what a sensor would measure. Using these inputs, the controller can then carry out 
actions. The actions include Increase Throttle, Reduce Throttle, Maintain, Emergency Vent and 
Shutdown. The decision the controller makes is based on safety limits that are preset to ensure 
the system is running correctly. The final decision is then printed to the console following the 
inputs from the user. The user is given the option to quit the controller at any given time.  
This controller is a safety critical system as it has parameters which prevent disastrous actions 
from occurring. This controller does this by setting limits and not allowing for actions to exceed 
them. For example, if the temperature of the engine is near capacity, the controller will stop the 
thrust from being increased, as it could cause engine failure. This is also true for the fuel levels. 
If the fuel levels are deemed to be low by the controller, the thrust cannot be increased but 
instead decreased. When a variable is defined as a potential safety issue, the controller will opt 
for either the Shutdown or the Emergency Vent action to maintain the safety. The model uses 
SPARK Ada preconditions and postconditions to determine the safe ranges and those that pose 
a danger.
