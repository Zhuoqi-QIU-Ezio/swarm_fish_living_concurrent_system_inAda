--
-- Jan & Uwe R. Zimmer, Australia, July 2011
--

with Vectors_xD_I; pragma Elaborate_All (Vectors_xD_I);

package Vectors_2D_I is

   type xy_Coordinates is (x, y);

   package Vectors_2Di is new Vectors_xD_I (Integer, xy_Coordinates);

   subtype Vector_2D_I is Vectors_2Di.Vector_xD_I;

   Zero_Vector_2D_I : constant Vector_2D_I := Vectors_2Di.Zero_Vector_xD;

   function Image (V : Vector_2D_I) return String renames Vectors_2Di.Image;

   function Norm (V : Vector_2D_I) return Vector_2D_I renames Vectors_2Di.Norm;

   function "*" (Scalar : Float; V : Vector_2D_I) return Vector_2D_I renames Vectors_2Di."*";
   function "*" (V : Vector_2D_I; Scalar : Float) return Vector_2D_I renames Vectors_2Di."*";
   function "/" (V : Vector_2D_I; Scalar : Float) return Vector_2D_I renames Vectors_2Di."/";

   function "*" (V_Left, V_Right : Vector_2D_I) return Float renames Vectors_2Di."*";

   function Angle_Between (V_Left, V_Right : Vector_2D_I) return Float renames Vectors_2Di.Angle_Between;

   function "+" (V_Left, V_Right : Vector_2D_I) return Vector_2D_I renames Vectors_2Di."+";
   function "-" (V_Left, V_Right : Vector_2D_I) return Vector_2D_I renames Vectors_2Di."-";

   function "abs" (V : Vector_2D_I) return Float renames Vectors_2Di."abs";

end Vectors_2D_I;
