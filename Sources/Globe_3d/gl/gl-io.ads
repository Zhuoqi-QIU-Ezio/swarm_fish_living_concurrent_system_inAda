------------------------------------------------------------------------------
 --  File :            GL - IO.ads
 --  Description :     I/O for (Open)GL graphics
 --
 --                   This package provides currently:
 --
 --                   ******************************************************
 --                   * INPUT * from a file or a data stream, to a texture *
 --                   ******************************************************
 --
 --                    - TGA image : RGA, RGBA, Grey
 --                    - BMP image : B&W, 16 colours indexed (palette),
 --                        256 colours indexed
 --
 --                   ***************************************************
 --                   * OUTPUT * from the GL active viewport, to a file *
 --                   ***************************************************
 --
 --                    - BMP image : screenshot
 --                    - AVI video : video capture
 --
 ------------------------------------------------------------------------------
 -- Change log:
 --
 -- 19 - Jan - 2010 (GdM) : using workaround to the slow attribute I/O issue (GNAT, OA);
 --                      buffered input; improvements on BMP
 --
 -- 26 - May - 2008 (GdM) : added support for TGA images with RLE encoding
 --
 -- 27 - Jan - 2008 (RK) :  added 'Image' record and a function to get greyscale pixels from an Image.
 --
 -- 10 - May - 2007 (GdM) : screenshot and video capture
 --
 -- 13 - Oct - 2006 (GdM) : new blending_hint out parameter, indicates possible
 --                      blending/transparency
 --
 -- 30 - Apr - 2006 (GdM) : - added multi - format loaders
 --                    - dimensions not power of two allowed, but
 --                      discouraged in the docs.
 --                      - > removed TGA_BAD_DIMENSION

with Ada.Streams.Stream_IO;
with Ada.Unchecked_Deallocation;

package GL.IO is

  File_Not_Found  : exception;

  type Supported_format is (BMP, TGA);

  type Byte_Array is array (Integer range <>) of aliased GL.Ubyte;
  type Byte_Array_Ptr is access all Byte_Array;

  procedure Free is
    new Ada.Unchecked_Deallocation (Byte_Array, Byte_Array_Ptr);

  type Byte_Grid is array (Integer range <>, Integer range <>) of aliased GL.Ubyte;

  type Image is
    record
      blending_hint     : Boolean;        -- has the image blending / transparency /alpha ?
      tex_Format        : GL.TexFormatEnm;
      tex_pixel_Format  : GL.TexPixelFormatEnm;
      size              : Integer;
      Width,
      Height            : Integer;
      Data              : Byte_Array_Ptr;
    end record;

  function To_TGA_Image (Filename : String) return Image;

  function To_TGA_Image (S : Ada.Streams.Stream_IO.Stream_Access) return Image;

  function to_greyscale_Pixels (the_Image : Image) return Byte_Grid;

  -- Multi - format loader:

   procedure Load (name          :     String;            -- file name
                   format        :     Supported_format;  -- expected file format
                   ID            :     Integer;           -- ID is the texture identifier to bind to
                   blending_hint : out Boolean);          -- has blending / transparency /alpha ?

   procedure Load (s             :     Ada.Streams.Stream_IO.Stream_Access; -- input data stream (e.g. UnZip.Streams)
                   format        :     Supported_format;  -- expected file format
                   ID            :     Integer;           -- ID is the texture identifier to bind to
                   blending_hint : out Boolean);          -- has blending / transparency /alpha ?

  -- Loaders specific to different formats:

  ----------------------
  -- BMP format Input --
  ----------------------

   procedure Load_BMP (Name          :     String;   -- File name
                       Id            :     Integer;  -- Id is the texture identifier to bind to
                       blending_hint : out Boolean); -- has the image blending / transparency /alpha ?

  procedure Load_BMP (S             :     Ada.Streams.Stream_IO.Stream_Access;  -- Input data stream
                      Id            :     Integer;  -- Id is the texture identifier to bind to
                      blending_hint : out Boolean); -- has the image blending / transparency /alpha ?

  Unsupported_BMP_format,
  Not_BMP_format,
  BMP_Unsupported_Bits_per_Pixel,
  Unsupported_compression :      exception;

  ----------------------
  -- TGA format Input --
  ----------------------

   procedure Load_TGA (Name          :     String;   -- File name
                       Id            :     Integer;  -- Id is the texture identifier to bind to
                       blending_hint : out Boolean); -- has the image blending / transparency /alpha ?

   procedure Load_TGA (S             :     Ada.Streams.Stream_IO.Stream_Access; -- Input data stream
                       Id            :     Integer;  -- Id is the texture identifier to bind to
                       blending_hint : out Boolean); -- has the image blending / transparency /alpha ?

  TGA_Unsupported_Image_Type      : exception;   -- color mapped or compressed image
  TGA_Unsupported_Bits_per_pixel  : exception;   -- image bits is not 8, 24 or 32
  TGA_Bad_Data                    : exception;   -- image data could not be loaded

  ---------------------------------------------------------------------------
  -- Image ("screenshot") of the current, active viewport (RGB BMP format) --
  ---------------------------------------------------------------------------

  procedure Screenshot (Name : String);

  --------------------------------------------------
  -- Video capture (RGB uncompressed, AVI format) --
  --------------------------------------------------

  procedure Start_Capture (AVI_Name : String; frame_rate : Positive);

  procedure Capture_Frame; -- captures the current, active viewport.

  procedure Stop_Capture;

  --------------------------------------------------------------------------
  -- An object - oriented stream buffering, initially for reading images to --
  -- the GL system, but that may be useful elsewhere, hence its presence  --
  -- in this package's specification                                      --
  --------------------------------------------------------------------------
  --
  type Input_buffer is private;

  procedure Attach_Stream (b   : out Input_buffer;
                           stm :     Ada.Streams.Stream_IO.Stream_Access);

  procedure Get_Byte (b : in out Input_buffer; Return_Byte : out Ubyte);
  pragma Inline (Get_Byte);

private

  type Input_buffer is record
    data        : Byte_Array (1 .. 1024);
    stm         : Ada.Streams.Stream_IO.Stream_Access;
    InBufIdx    : Positive;   --  Points to next char in buffer to be read
    MaxInBufIdx : Natural;    --  Count of valid chars in input buffer
    InputEoF    : Boolean;    --  End of file indicator
  end record;

end GL.IO;
