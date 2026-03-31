pragma SPARK_Mode (On);

package Engine_Types is


   -- controller commands
   type Action_Type is
     (Shutdown,
      Reduce_Throttle,
      Maintain,
      Increase_Throttle,
      Emergency_Vent);

   subtype Percentage    is Integer;
   subtype Pressure_Bar  is Integer;
   subtype Temperature_C is Integer;

   -- safety limits
   Max_Pressure          : constant Pressure_Bar  := 200;
   Emergency_Pressure    : constant Pressure_Bar  := 240;
   Max_Temperature       : constant Temperature_C := 3200;
   Emergency_Temperature : constant Temperature_C := 3600;

   -- fuel thresholds
   Critical_Fuel_Level   : constant Percentage    := 10;
   Low_Fuel_Level        : constant Percentage    := 30;
   High_Thrust_Threshold : constant Percentage    := 65;

end Engine_Types;
