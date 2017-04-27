-- Suggestions for packages which might be useful:

  with Ada.Real_Time;              use Ada.Real_Time;
--  with Ada.Text_IO;                use Ada.Text_IO;
with Exceptions;                 use Exceptions;
--  with Real_Type;                  use Real_Type;
--  with Generic_Sliding_Statistics;
--  with Rotations;                  use Rotations;
with Vectors_3D;                 use Vectors_3D;
with Vehicle_Interface;          use Vehicle_Interface;
with Vehicle_Message_Type;       use Vehicle_Message_Type;
with Swarm_Structures;           use Swarm_Structures;
with Swarm_Structures_Base;      use Swarm_Structures_Base;
with Swarm_Configurations;       use Swarm_Configurations; -- for selecting the structure for single/dual globes
with Swarm_Configuration;        use Swarm_Configuration;

package body Vehicle_Task_Type is

   task body Vehicle_Task is

      Vehicle_No : Positive; -- pragma Unreferenced (Vehicle_No);
      Send_Message, My_Message : Inter_Vehicle_Messages := (Clock, (0.0, 0.0, 0.0)); ---variable initialization
      -- You will want to take the pragma out, once you use the "Vehicle_No"
      -- Distance_G : Real; -- an idea to implement stage c
   begin

      -- You need to react to this call and provide your task_id.
      -- You can e.g. employ the assigned vehicle number (Vehicle_No)
      -- in communications with other vehicles.

      accept Identify (Set_Vehicle_No : Positive; Local_Task_Id : out Task_Id) do
         Vehicle_No     := Set_Vehicle_No;
         Local_Task_Id  := Current_Task;
      end Identify;

      -- Replace the rest of this task with your own code.
      -- Maybe synchronizing on an external event clock like "Wait_For_Next_Physics_Update",
      -- yet you can synchronize on e.g. the real-time clock as well.
      -- Don't use busy-waiting here, as this task is not alone on the CPU.

      -- Without control this vehicle will go for its natural swarming instinct.

      select

         Flight_Termination.Stop;

      then abort

         Outer_task_loop : loop

            Wait_For_Next_Physics_Update;
-- Message Passing Part-----------------------------------------------------------------------
             if Energy_Globes_Around'Length >= 1 then
               My_Message.Message_Time := Clock;
               My_Message.Position_G := Vector_3D (Energy_Globes_Around (1).Position);
               Send_Message.Message_Time := Clock;
               Send_Message.Position_G := Vector_3D (Energy_Globes_Around (1).Position);
               Send (Send_Message);
             end if; ------record and store the message about the nearby/detected energy globes'information(position and found time)
            Send (Send_Message); ----Send the initial Send_Message as well if the vehicle cannot locate any energy globe(Energt_Globes_Around'Length=0)
            Receive (Send_Message);
            if My_Message.Message_Time < Send_Message.Message_Time then
               My_Message.Message_Time := Send_Message.Message_Time;
               My_Message.Position_G := Send_Message.Position_G;
            end if; -------update the local My_Message to keep tracking the latest location of the energy globe
-- End Message Passing Part-------------------------------------------------------------------
-- Distribution System Part--------------------------------------------------------------------------
         -- Distribution Structure 1: Geometrical/Symmetrical structure for Single Energy Globe------
           if Swarm_Configuration.Configuration = Single_Globe_In_Orbit then
            if Current_Charge <= 1.0 and then Current_Charge > 0.8 then
               case Vehicle_No is
                  when 1 .. 7 => Set_Destination (My_Message.Position_G + (0.36, 0.0, 0.0)); Set_Throttle (0.8);
                  when 8 .. 14 => Set_Destination (My_Message.Position_G + (-0.36, 0.0, 0.0)); Set_Throttle (0.8);
                  when 15 .. 21 => Set_Destination (My_Message.Position_G + (0.0, 0.36, 0.0)); Set_Throttle (0.8);
                  when 22 .. 28 => Set_Destination (My_Message.Position_G + (0.0, -0.36, 0.0)); Set_Throttle (0.8);
                  when 29 .. 35 => Set_Destination (My_Message.Position_G + (0.0, 0.0, 0.36)); Set_Throttle (0.8);
                  when 36 .. 42 => Set_Destination (My_Message.Position_G + (0.0, 0.0, -0.36)); Set_Throttle (0.8);
                  when others => Set_Destination (My_Message.Position_G + (0.36, 0.36, 0.36)); Set_Throttle (0.8);
               end case;
            end if;
            if Current_Charge <= 0.8 and then Current_Charge > 0.6 then
               case Vehicle_No is
                  when 1 .. 7 => Set_Destination (My_Message.Position_G + (0.18, 0.0, 0.0)); Set_Throttle (0.4);
                  when 8 .. 14 => Set_Destination (My_Message.Position_G + (-0.18, 0.0, 0.0)); Set_Throttle (0.4);
                  when 15 .. 21 => Set_Destination (My_Message.Position_G + (0.0, 0.18, 0.0)); Set_Throttle (0.4);
                  when 22 .. 28 => Set_Destination (My_Message.Position_G + (0.0, -0.18, 0.0)); Set_Throttle (0.4);
                  when 29 .. 35 => Set_Destination (My_Message.Position_G + (0.0, 0.0, 0.18)); Set_Throttle (0.4);
                  when 36 .. 42 => Set_Destination (My_Message.Position_G + (0.0, 0.0, -0.18)); Set_Throttle (0.4);
                  when others => Set_Destination (My_Message.Position_G + (-0.18, -0.18, -0.18)); Set_Throttle (0.4);
               end case;
            end if;
            if Current_Charge <= 0.6 then
                  Set_Destination (My_Message.Position_G);
                  Set_Throttle (0.8);
            end if;
           end if;
         -- End Structure 1--------------------------------------------------------------------
         -- Distribution Structure 2: Spiny/Radial Structure for Dual/Multiple Energy Globes-------------------
            if Swarm_Configuration.Configuration = Dual_Globes_In_Orbit then
               if Current_Charge <= 1.0 and then Current_Charge > 0.9 then
                  case Vehicle_No is
                     when 1 .. 5 => Set_Destination (My_Message.Position_G + (0.1, 0.1, 0.1)); Set_Throttle (0.8);
                     when 6 .. 10 => Set_Destination (My_Message.Position_G + (-0.1, 0.1, 0.1)); Set_Throttle (0.8);
                     when 11 .. 15 => Set_Destination (My_Message.Position_G + (0.1, -0.1, 0.1)); Set_Throttle (0.8);
                     when 16 .. 20 => Set_Destination (My_Message.Position_G + (0.1, 0.1, -0.1)); Set_Throttle (0.8);
                     when 21 .. 25 => Set_Destination (My_Message.Position_G + (-0.1, -0.1, 0.1)); Set_Throttle (0.8);
                     when 26 .. 30 => Set_Destination (My_Message.Position_G + (-0.1, 0.1, -0.1)); Set_Throttle (0.8);
                     when 31 .. 35 => Set_Destination (My_Message.Position_G + (0.1, -0.1, -0.1)); Set_Throttle (0.8);
                     when 36 .. 40 => Set_Destination (My_Message.Position_G + (-0.1, -0.1, -0.1)); Set_Throttle (0.8);
                     when 41 .. 45 => Set_Destination (My_Message.Position_G + (0.05, 0.1, 0.15)); Set_Throttle (0.8);
                     when 46 .. 50 => Set_Destination (My_Message.Position_G + (0.15, 0.1, 0.05)); Set_Throttle (0.8);
                     when 51 .. 55 => Set_Destination (My_Message.Position_G + (-0.05, 0.1, 0.15)); Set_Throttle (0.8);
                     when 56 .. 60 => Set_Destination (My_Message.Position_G + (-0.15, 0.1, 0.05)); Set_Throttle (0.8);
                     when 61 .. 65 => Set_Destination (My_Message.Position_G + (0.05, -0.1, 0.15)); Set_Throttle (0.8);
                     when 66 .. 70 => Set_Destination (My_Message.Position_G + (0.15, -0.1, 0.05)); Set_Throttle (0.8);
                     when 71 .. 75 => Set_Destination (My_Message.Position_G + (0.05, 0.1, -0.15)); Set_Throttle (0.8);
                     when 76 .. 80 => Set_Destination (My_Message.Position_G + (0.15, 0.1, -0.05)); Set_Throttle (0.8);
                     when 81 .. 85 => Set_Destination (My_Message.Position_G + (0.05, -0.1, -0.15)); Set_Throttle (0.8);
                     when 86 .. 90 => Set_Destination (My_Message.Position_G + (0.15, -0.1, -0.05)); Set_Throttle (0.8);
                     when 91 .. 95 => Set_Destination (My_Message.Position_G + (-0.05, -0.1, 0.15)); Set_Throttle (0.8);
                     when others => Set_Destination (My_Message.Position_G + (0.15, 0.15, 0.15)); Set_Throttle (0.8);
                  end case;
               end if;
               if Current_Charge <= 0.9 then
                  Set_Destination (My_Message.Position_G);
                  Set_Throttle (0.8);
               end if;
            end if;
         -- End Structure 2---------------------------------------------------------------------
-- End Distribution System Part-----------------------------------------------------------------
            -- Maybe we do something, look around, listen or talk to somebody?

         end loop Outer_task_loop;

      end select;

   exception
      when E : others => Show_Exception (E);

   end Vehicle_Task;

end Vehicle_Task_Type;
