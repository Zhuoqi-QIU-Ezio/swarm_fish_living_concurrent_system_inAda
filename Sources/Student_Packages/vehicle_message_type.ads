-- Suggestions for packages which might be useful:
  with Ada.Real_Time;         use Ada.Real_Time;
  with Vectors_3D;            use Vectors_3D;

package Vehicle_Message_Type is

   -- Replace this record definition by what your vehicles need to communicate.

   type Inter_Vehicle_Messages is record
      Message_Time : Time;
      Position_G : Vector_3D;
      -- Message_Requirement : Boolean; -- an idea to improve the message passing part
   end record;

end Vehicle_Message_Type;
