pragma SPARK_Mode (On);

with Engine_Types;  use Engine_Types;

package Safety_Logic is

   function Decide_Action
     (Pressure         : Pressure_Bar;
      Temperature      : Temperature_C;
      Requested_Thrust : Percentage;
      Fuel_Level       : Percentage) return Action_Type
   with
     Global  => null,
     Depends => (Decide_Action'Result =>
                   (Pressure, Temperature, Requested_Thrust, Fuel_Level)),

     -- input ranges
     Pre =>
       Pressure         >= 0 and then Pressure         <= 300  and then
       Temperature      >= 0 and then Temperature      <= 4000 and then
       Requested_Thrust >= 0 and then Requested_Thrust <= 100  and then
       Fuel_Level       >= 0 and then Fuel_Level       <= 100,

     -- safety variables
     Post =>
       -- no increase or maintaning during emergency
       (if Pressure > Max_Pressure
           or else Temperature > Max_Temperature
           or else Fuel_Level < Critical_Fuel_Level
        then
           Decide_Action'Result /= Increase_Throttle and then
           Decide_Action'Result /= Maintain
        else
           True) and then

       -- vent in hard emergency
       (if Pressure >= Emergency_Pressure
           or else Temperature >= Emergency_Temperature
        then
           Decide_Action'Result = Emergency_Vent
        else
           True);

end Safety_Logic;
