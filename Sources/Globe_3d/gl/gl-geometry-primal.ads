pragma Style_Checks (Off);

-------------------------------------------------------------------------
 --  GL.Geometry - GL geometry primitives
 --
 --  Copyright (c) Rod Kay 2007
 --  AUSTRALIA
 --  Permission granted to use this software, without any warranty,
 --  for any purpose, provided this copyright note remains attached
 --  and unmodified if sources are distributed further.
 -------------------------------------------------------------------------

with GL.geometry.Primitives;

package GL.Geometry.primal is

   type primal_Geometry is new Geometry_t with
      record
         Primitive  : primitives.p_Primitive;
      end record;

   type p_primal_Geometry is access all primal_Geometry;

   function  primitive_Id  (Self  : in     primal_Geometry) return GL.ObjectTypeEnm;

   function  vertex_Count  (Self  : in     primal_Geometry) return GL.geometry.vertex_Id;
   function  Vertices      (Self  : in     primal_Geometry) return GL.geometry.GL_Vertex_array;
   procedure set_Vertices  (Self  : in out primal_Geometry;   To  : access GL.geometry.GL_Vertex_array);

   function  indices_Count (Self  : in     primal_Geometry) return GL.positive_uInt;
   function  Indices       (Self  : in     primal_Geometry) return GL.geometry.vertex_Id_array;
   procedure set_Indices   (Self  : in out primal_Geometry;   To  : access GL.geometry.vertex_Id_array);

   function  Bounds        (Self  : in     primal_Geometry) return GL.geometry.Bounds_record;

   procedure Draw          (Self  : in     primal_Geometry);

   procedure destroy (Self  : in out primal_Geometry);

end GL.Geometry.primal;
