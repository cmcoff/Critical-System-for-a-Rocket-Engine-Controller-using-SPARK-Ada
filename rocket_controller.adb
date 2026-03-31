pragma SPARK_Mode (On);

with AS_IO_Wrapper; use AS_IO_Wrapper;
with Engine_Types;  use Engine_Types;
with Safety_Logic;

procedure Rocket_Controller is

   procedure Get_Int_Or_Q
     (Prompt : in  String;
      Min    : in  Integer;
      Max    : in  Integer;
      Value  : out Integer;
      Quit   : out Boolean)
   is
      Buf   : String (1 .. 20);
      L     : Natural;
      Tmp   : Integer;
      Digit : Integer;
      Valid : Boolean;
   begin
      Quit := False;

      loop
         AS_Put_Line (Prompt);
         AS_Get_Line (Buf, L);

         -- Q to quit cycle
         if L = 1 and then (Buf (1) = 'Q' or else Buf (1) = 'q') then
            Quit := True;
            return;
         end if;

         Valid := True;

         -- check length is between 1 and 4 digits
         if L = 0 or else L > 4 then
            Valid := False;
         else
            Tmp := 0;

            -- convert from digits
            for I in 1 .. L loop
               if Buf (I) in '0' .. '9' then
                  Digit := Character'Pos (Buf (I)) - Character'Pos ('0');
                  Tmp   := Tmp * 10 + Digit;
               else
                  Valid := False;
               end if;
            end loop;
         end if;

         -- range check
         if Valid and then Tmp >= Min and then Tmp <= Max then
            Value := Tmp;
            return;
         end if;

         AS_Put_Line ("Invalid value. Please enter a number in range or Q to quit.");
      end loop;
   end Get_Int_Or_Q;

   P_Raw : Integer;
   T_Raw : Integer;
   R_Raw : Integer;
   F_Raw : Integer;

   Quit   : Boolean;
   Action : Action_Type;

begin
   AS_Init_Standard_Input;
   AS_Init_Standard_Output;

   AS_Put_Line ("ROCKET ENGINE SAFETY CONTROLLER");
   AS_Put_Line ("Press Q at any time to quit.");
   AS_Put_Line ("");

   Main_Loop :
   loop
      AS_Put_Line ("--- New control cycle ---");

      -- pressure (between 0 and 300)
      Get_Int_Or_Q ("Enter chamber pressure (between 0 and 300):",
                    0, 300, P_Raw, Quit);
      exit Main_Loop when Quit;

      -- temperature (between 0 and 4000)
      Get_Int_Or_Q ("Enter chamber temperature (between 0 and 4000):",
                    0, 4000, T_Raw, Quit);
      exit Main_Loop when Quit;

      -- requested thrust (between 0 and 100)
      Get_Int_Or_Q ("Enter requested thrust (between 0 and 100):",
                    0, 100, R_Raw, Quit);
      exit Main_Loop when Quit;

      -- fuel level (between 0 and 100)
      Get_Int_Or_Q ("Enter fuel level (between 0 and 100):",
                    0, 100, F_Raw, Quit);
      exit Main_Loop when Quit;

      AS_Put_Line ("");

      Action :=
        Safety_Logic.Decide_Action
          (Pressure         => P_Raw,
           Temperature      => T_Raw,
           Requested_Thrust => R_Raw,
           Fuel_Level       => F_Raw);

      -- output decision
      AS_Put ("Controller action: ");
      case Action is
         when Shutdown =>
            AS_Put_Line ("SHUTDOWN ENGINE");
         when Reduce_Throttle =>
            AS_Put_Line ("REDUCE THROTTLE");
         when Maintain =>
            AS_Put_Line ("MAINTAIN CURRENT THRUST");
         when Increase_Throttle =>
            AS_Put_Line ("INCREASE THROTTLE");
         when Emergency_Vent =>
            AS_Put_Line ("EMERGENCY VENT AND SHUTDOWN");
      end case;

      AS_Put_Line ("");
      -- loop to start a new control cycle
   end loop Main_Loop;

   AS_Put_Line ("Controller stopped.");
end Rocket_Controller;
