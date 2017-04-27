-------------------------------------------------------------------------
 --  GL.Textures - GL Texture model
 --
 --  Copyright (c) Rod Kay 2007
 --  AUSTRALIA
 --  Permission granted to use this software, without any warranty,
 --  for any purpose, provided this copyright note remains attached
 --  and unmodified if sources are distributed further.
 -------------------------------------------------------------------------

with GL.Geometry;

with Ada.Unchecked_Deallocation;

package GL.Textures is

   -- core types
   --

   subtype texture_Name is GL.Uint;     -- an openGL texture 'name', which is a natural integer.

   type texture_Transform is
     record
       Offset  : Double;
       Scale   : Double;
     end record;

   -- texture co - ordinates
   --

   type Coordinate_1D is
      record
         S  : aliased GL.Double;
      end record;

   type Coordinate_1D_array is array (Natural range <>) of Coordinate_1D;

   type Coordinate_2D is
      record
         S, T  : aliased GL.Double;
      end record;

   type   Coordinate_2D_array is array (GL.Geometry.Positive_Vertex_Id range <>) of aliased Coordinate_2D;   -- tbd : can the index be '1'- based ?
   type p_Coordinate_2D_array is access all Coordinate_2D_array;

   procedure free is new Ada.Unchecked_Deallocation (Coordinate_2D_array, p_Coordinate_2D_array);

   function To_Texture_Coordinates_xz (the_Points  : GL.Geometry.GL_Vertex_array;
                                       Transform_S : texture_Transform;          -- transforms point X ordinate.
                                       Transform_T : texture_Transform)          -- transforms point Z ordinate.
                                       return p_Coordinate_2D_array;                -- using heap to avoid storage_Error with large numbers of points.

   type coordinate_Generator   is abstract tagged null record;
   type p_coordinate_Generator is access all coordinate_Generator'Class;

   function To_Coordinates (Self : coordinate_Generator; the_Vertices : GL.Geometry.GL_Vertex_array) return GL.Textures.p_Coordinate_2D_array is abstract;
   function To_Coordinates (Self : coordinate_Generator; the_Vertices : GL.Geometry.GL_Vertex_array) return GL.Textures.Coordinate_2D_array is abstract;

   type xz_Generator is new coordinate_Generator with
      record
         Transform_S  : texture_Transform;          -- transforms point X ordinate.
         Transform_T  : texture_Transform;          -- transforms point Z ordinate.
      end record;

   overriding function To_Coordinates (Self : xz_Generator; the_Vertices : GL.Geometry.GL_Vertex_array) return GL.Textures.p_Coordinate_2D_array;
   overriding function to_Coordinates (Self : xz_Generator; the_Vertices : GL.Geometry.GL_Vertex_array) return GL.Textures.Coordinate_2D_array;

   type Coordinate_3D is
      record
         S, T, R  : aliased GL.Double;
      end record;

   type Coordinate_3D_array is array (Natural range <>) of Coordinate_3D;

   type Coordinate_4D is
      record
         S, T, R, Q  : aliased GL.Double;
      end record;

   type Coordinate_4D_array is array (Natural range <>) of Coordinate_4D;

   type Size is (Unknown, s2, s4, s8, s16, s32, s64, s128, s256, s512, s1024, s2048);

   function To_Size (From : Positive) return Size;

   -- Object - an openGL texture 'object'.
   --

   type Object  is private;
   type Objects is array (Positive range <>) of Object;

   function New_Texture (image_Filename : String) return Object;

   unsupported_format_Error  : exception;    -- raised when image filename is not of 'bmp' or 'tga' format.

   procedure Destroy (Self  : in out Object);

   procedure Set_Name (Self : in out Object; To : texture_Name);
   function  Name     (Self :        Object) return texture_Name;

   procedure Enable (Self : in out Object);

   function Size_Width  (Self : Object) return Size;
   function Size_Height (Self : Object) return Size;

   function  Is_Transparent (Self :  Object) return Boolean;

   -- Pool - a pool for rapid allocation/deallocation of texture objects.
   --

   type Pool is private;
   type p_Pool is access all Pool;

   function New_Texture (From       : access Pool;
                         min_Width  :        Positive;
                         min_Height :        Positive) return Object;
   --
   -- returns a texture object, whose width and height are powers of two, sufficient to contain the requested minimums.
   -- tbd : add texture properties to construction parameters !

   procedure Free (Self : in out Pool; the_Texture : Object);
   --
   -- free's a texture, for future use.

   procedure Vacuum (Self : in out Pool);
   --
   -- releases any allocated, but unused, texture objects.

   -- support
   --

   function Power_of_2_Ceiling (From : Positive) return GL.Sizei;

private

   type Object is tagged
      record
         Name    : aliased texture_Name := 0;
         Width,
         Height  :         Size := Unknown;

         is_Transparent  : Boolean;

         Pool    : Textures.p_Pool;
      end record;

   -- pool
   --
   -- re - uses existing textures when possible for performance.

   type pool_texture_List is
      record
         Textures  : Objects (1 .. 3000);
         Last      : Natural            := 0;
      end record;

   type p_pool_texture_List is access all pool_texture_List;

   type pool_texture_Lists_by_size is array (Size, Size) of p_pool_texture_List;

   type Pool is
      record
         unused_Textures_for_size  : pool_texture_Lists_by_size;
      end record;

end GL.Textures;
