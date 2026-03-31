pragma SPARK_Mode (On);

package body Safety_Logic is

   function Decide_Action
     (Pressure         : Pressure_Bar;
      Temperature      : Temperature_C;
      Requested_Thrust : Percentage;
      Fuel_Level       : Percentage) return Action_Type
   is
   begin
      -- hard emergency
      if Pressure    >= Emergency_Pressure
        or else Temperature >= Emergency_Temperature
      then
         return Emergency_Vent;

      -- almost emergency
      elsif Pressure > Max_Pressure
        or else Temperature > Max_Temperature
        or else Fuel_Level < Critical_Fuel_Level
      then
         return Shutdown;

      --close to limits: reduce throttle
      elsif Pressure    >= Max_Pressure   - 10
        or else Temperature >= Max_Temperature - 200
      then
         return Reduce_Throttle;

      -- safe
      elsif Requested_Thrust > High_Thrust_Threshold
        and then Fuel_Level > Low_Fuel_Level
        and then Pressure    < Max_Pressure   - 30
        and then Temperature < Max_Temperature - 400
      then
         return Increase_Throttle;
      else
         return Maintain;
      end if;
   end Decide_Action;

end Safety_Logic;
