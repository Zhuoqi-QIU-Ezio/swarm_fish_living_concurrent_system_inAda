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

pragma Warnings (Off);
pragma Style_Checks (Off);

with GL,  GL.Geometry,  GL.Skins,  GL.skinned_Geometry;

package GLOBE_3D.Sprite is

   -- a 'Visual' which consists of multiple GL.skinned_Geometrys

   type Sprite (max_Geometrys  : Positive) is new Visual with
      record
         skinned_Geometrys       : GL.skinned_geometry.skinned_Geometrys (1 .. max_Geometrys);
         skinned_geometry_Count  : Natural := 0;

         -- private:
         is_Transparent  : Boolean := False;
         face_Count      : Natural := 0;
         Bounds          : GL.geometry.Bounds_record;
      end record;

   type p_Sprite      is access all Sprite'Class;
   type p_sprite_Grid is array (Positive range <>, Positive range <>) of p_Sprite;

   procedure destroy (o  : in out Sprite);

   procedure set_Alpha (o     : in out Sprite;   Alpha  : in GL.Double);
   function  is_Transparent (o     : in Sprite) return Boolean;

   function skinned_Geometrys (o  : in Sprite) return GL.skinned_geometry.skinned_Geometrys;

   procedure add (o  : in out Sprite;   Geometry  : access GL.geometry.Geometry_t'Class;
                                       Skin      : access GL.skins.Skin'Class);

   procedure Pre_calculate (o : in out Sprite);

   procedure Display (
    o       : in out Sprite;
    clip    : in     Clipping_data
);

   function face_Count (o  : in Sprite) return Natural;
   function Bounds     (o  : in Sprite) return GL.geometry.Bounds_record;

end GLOBE_3D.Sprite;
