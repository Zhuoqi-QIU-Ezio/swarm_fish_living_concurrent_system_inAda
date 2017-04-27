pragma Warnings (Off);
pragma Style_Checks (Off);

-------------------------------------------------------------------------
 --  GLOBE_3D - GL - based, real - time, 3D engine
 --
 --  Copyright (c) Gautier de Montmollin/Rod Kay 2007
 --  CH - 8810 Horgen
 --  SWITZERLAND
 --  Permission granted to use this software, without any warranty,
 --  for any purpose, provided this copyright note remains attached
 --  and unmodified if sources are distributed further.
 -------------------------------------------------------------------------

with globe_3d.tri_Mesh;
with GL.Geometry.vbo;
with GL.Textures;

package GLOBE_3D.tri_Mesh.vbo is

   -- provides a triangle mesh Visual, using an openGL 'vertex buffer object' for geometry.
   --

   type tri_Mesh is new globe_3d.tri_mesh.tri_Mesh with
      record
         skinned_Geometry  : GL.skinned_geometry.skinned_Geometry_t := (geometry  => new GL.geometry.vbo.vbo_Geometry'
                                                                                        (gl.geometry.Geometry_t with
                                                                                         primitive_Id  => GL.Triangles,
                                                                                         vertex_Count  => 0,
                                                                                         indices_Count => 0,
                                                                                         others        => <>),
                                                                     skin      => null,
                                                                     veneer    => null);
      end record;

   type p_tri_Mesh       is access all tri_Mesh'Class;
   type p_tri_Mesh_array is array (Positive range <>) of p_tri_Mesh;
   type p_tri_Mesh_grid  is array (Positive range <>, Positive range <>) of p_tri_Mesh;

   procedure destroy (o : in out tri_Mesh);

   procedure Pre_calculate (o : in out tri_Mesh);

   procedure Display (o     : in out tri_Mesh;
                      clip  : in     Clipping_data);

   procedure set_Alpha (o     : in out tri_Mesh;   Alpha  : in GL.Double);
   function  is_Transparent (o     : in tri_Mesh) return Boolean;

   procedure set_Vertices (Self  : in out tri_Mesh;   To  : access GL.geometry.GL_vertex_Array);
   procedure set_Indices  (Self  : in out tri_Mesh;   To  : access GL.geometry.vertex_Id_array);

   function skinned_Geometrys (o  : in tri_Mesh) return GL.skinned_geometry.skinned_Geometrys;
   function face_Count        (o  : in tri_Mesh) return Natural;
   function  Bounds           (o  : in tri_Mesh) return GL.geometry.Bounds_record;

   procedure Skin_is (o  : in out tri_Mesh;   Now  : in GL.skins.p_Skin);

end GLOBE_3D.tri_Mesh.vbo;
