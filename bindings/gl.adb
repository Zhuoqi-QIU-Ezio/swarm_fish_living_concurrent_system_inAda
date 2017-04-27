-- Change log:

-- GdM : 26-Jul-2011 : using System.Address_To_Access_Conversions

-- GdM : 28-Nov-2005 : replaced Unrestricted_Access with Address
--                   since Unrestricted_Access is GNAT-Specific

-- GdM : 27-Jan-2004 : Added Material_Float_vector and Material ( .. .) for it

-- GdM : 11-Apr-2002  : * "gl .. ." and other useless C prefixes removed
--                    * removing of pointers and
--                      " .. .4f" -style suffixes in progress

with Interfaces.C.Strings;
with GL.Extended;

package body GL is

   procedure Light
     (Light_id  : LightIDEnm;
      pname     : LightParameterVEnm;
      params    : Light_Float_vector)
   is
      params_copy : aliased Light_Float_vector := params;
   begin
      Lightfv (Light_id, pname, params_copy (0)'Unchecked_Access);
   end Light;

   procedure Material (face   : FaceEnm;
                       pname  : MaterialParameterVEnm;
                       params : Material_Float_vector) is

      params_copy : aliased Material_Float_vector := params;

   begin
      Materialfv (face, pname, params_copy (0)'Unchecked_Access);
   end Material;

   procedure Vertex (v : Double_Vector_3D) is

   begin
      Vertex3dv (A2A_double.To_Pointer (v (0)'Address));
      -- This method is functionally identical
      -- to using GNAT's 'Unrestricted_Access
   end Vertex;

   procedure Normal (v : Double_Vector_3D) is

   begin
      Normal3dv (A2A_double.To_Pointer (v (0)'Address));
   end Normal;

   procedure Translate (v : Double_Vector_3D) is

   begin
      Translate (v (0), v (1), v (2));
   end Translate;

   procedure Color (v : RGB_Color) is
   begin
      Color3dv (A2A_double.To_Pointer (v.Red'Address));
   end Color;

   procedure Color (v : RGBA_Color) is
   begin
      Color4dv (A2A_double.To_Pointer (v.red'Address));
   end Color;

   function GetString (name : StringEnm) return String is
      function Cvt is new Ada.Unchecked_Conversion (ubytePtr, Interfaces.C.Strings.chars_ptr);
      ps : constant Interfaces.C.Strings.chars_ptr := Cvt (GL.GetString (name));
      use Interfaces.C.Strings;
   begin
      -- OpenGL doc : If an error is generated, glGetString returns 0.
      if ps = Null_Ptr then
         -- We still return a string, but an empty one (this is abnormal)
         return "";
      else
         return Interfaces.C.Strings.Value (ps);
      end if;
   end GetString;

   -----------------------------
   -- Wrappers of GL.Extended --
   -----------------------------

   procedure Gen_Buffers (n        : GL.Sizei;
                         buffers  : GL.uintPtr)
                        renames GL.Extended.GenBuffers;

   procedure Delete_Buffers (n        : GL.Sizei;
                            buffers  : GL.uintPtr)
                           renames GL.Extended.DeleteBuffers;

   procedure BindBuffer (target  : VBO_Target;
                         buffer  : GL.Uint)
                        renames GL.Extended.BindBuffer;

   procedure Buffer_Data (target  : GL.VBO_Target;
                         size    : GL.sizeiPtr;
                         data    : GL.pointer;
                         usage   : GL.VBO_Usage)
                        renames GL.Extended.BufferData;

   procedure BufferSubData (target  : GL.VBO_Target;
                            offset  : GL.intPtr;
                            size    : GL.sizeiPtr;
                            data    : GL.pointer)
                           renames GL.Extended.BufferSubData;

   function MapBuffer   (target  : GL.VBO_Target;
                         Policy  : GL.Access_Policy) return GL.pointer
                        renames GL.Extended.MapBuffer;

   function UnmapBuffer (target  : GL.VBO_Target) return GL_Boolean
                        renames GL.Extended.UnmapBuffer;

   procedure GetBufferParameter (target  : GL.VBO_Target;
                                 value   : Buffer_Parameter;
                                 data    : intPointer)
                                renames GL.Extended.GetBufferParameter;

end GL;
