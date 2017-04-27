pragma Warnings (Off);
pragma Style_Checks (Off);

with GLOBE_3D.Options,
     GLOBE_3D.Textures,
     GLOBE_3D.Math;

with GL.Buffer.vertex;
with GL.Buffer.indices;
with GL.Buffer.texture_coords;

with Ada.Exceptions; use Ada.Exceptions;
with ada.text_io;    use ada.text_io;

with ada.unchecked_Conversion;

with System;

package body GLOBE_3D.tri_Mesh.vbo is

  use GLOBE_3D.Options;

  package G3DT renames GLOBE_3D.Textures;
  package G3DM renames GLOBE_3D.Math;

   procedure destroy (o : in out tri_Mesh)
   is
      use GL.skinned_geometry;
   begin
      destroy (o.skinned_Geometry);
   end;

   function skinned_Geometrys (o  : in tri_Mesh) return GL.skinned_geometry.skinned_Geometrys
   is
   begin
      return (1 => o.skinned_Geometry);
   end;

   procedure set_Alpha (o     : in out tri_Mesh;   Alpha  : in GL.Double)
   is
   begin
      null;    -- tbd:
   end;

   function  is_Transparent (o     : in tri_Mesh) return Boolean
   is
      use type GL.Double;
   begin
      return o.skinned_Geometry.Skin.is_Transparent;
   end;

   procedure Pre_calculate (o : in out tri_Mesh)
   is
      use GL, G3DM;
   begin
      null;  -- tbd:
   end Pre_calculate;

   procedure Display (o       : in out tri_Mesh;
                      clip    : in     Clipping_data)
   is
   begin
      null;
   end Display;

   procedure set_Vertices (Self  : in out tri_Mesh;   To  : access GL.geometry.GL_vertex_Array)
   is
      use GL.Buffer.vertex, GL.Geometry, GL.Geometry.vbo;

      the_Geometry  : GL.geometry.vbo.vbo_Geometry renames GL.geometry.vbo.vbo_Geometry (self.skinned_geometry.Geometry.all);
   begin
      the_Geometry.Vertices     := to_Buffer (To, usage => GL.static_draw);  -- tbd : check usage
      the_Geometry.vertex_Count := GL.SizeI  (To'Length);

      the_Geometry.Bounds := Bounds (To.all);
   end;

   procedure set_Indices  (Self  : in out tri_Mesh;   To  : access GL.geometry.vertex_Id_array)
   is
      use GL.Buffer.indices, GL.Geometry, GL.Geometry.vbo;
      the_Geometry  : GL.geometry.vbo.vbo_Geometry renames GL.geometry.vbo.vbo_Geometry (self.skinned_geometry.Geometry.all);
   begin
      the_Geometry.indices_Count := GL.SizeI (To'Length);
      the_Geometry.Indices       := to_Buffer (To, usage => GL.static_draw);
   end;

   procedure Skin_is (o  : in out tri_Mesh;   Now  : in GL.skins.p_Skin)
   is
   begin
      o.skinned_Geometry.Skin   := Now;
      o.skinned_Geometry.Veneer := Now.all.new_Veneer (for_geometry => o.skinned_Geometry.Geometry.all);
   end;

   function face_Count (o  : in tri_Mesh) return Natural
   is
      use GL;
      the_Geometry  : GL.geometry.vbo.vbo_Geometry renames GL.geometry.vbo.vbo_Geometry (o.skinned_geometry.Geometry.all);
   begin
      return Natural (the_Geometry.indices_Count / 3);
   end;

   function Bounds (o  : in tri_Mesh) return GL.geometry.Bounds_record
   is
   begin
      return o.skinned_geometry.Geometry.Bounds;
   end;

end GLOBE_3D.tri_Mesh.vbo;
