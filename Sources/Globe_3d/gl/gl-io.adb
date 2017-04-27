--
 -- Input:
 --   TGA  : Orig. author is Nate Miller (tga.c, 7 - Aug - 1999), vandals1@home.com
 --   BMP  : from Gautier's SVGA.IO package
 --
 -- Output:
 --   BMP  : from http://wiki.delphigl.com/index.php/Screenshot (Delphi)
 --   AVI  : from specification, plus re - using the raw bitmap output from BMP

with Ada.Exceptions;                    use Ada.Exceptions;
with Ada.Unchecked_Conversion;
with System;

package body GL.IO is

   use Ada.Streams.Stream_IO;

   type U8  is mod 2 ** 8;   for U8'Size  use 8;
   type U16 is mod 2 ** 16;  for U16'Size use 16;
   type U32 is mod 2 ** 32;  for U32'Size use 32;

   type I32 is range -2 ** 31 .. 2 ** 31 - 1; for I32'Size use 32;

   not_yet_implemented  : exception;

   function to_greyscale_Pixels (the_Image : Image) return Byte_Grid is

      the_Grid  : Byte_Grid (1 .. the_Image.Height, 1 .. the_Image.Width);

   begin
      case the_Image.tex_pixel_Format is
         when GL.LUMINANCE =>

            for Row in the_Grid'Range (1) loop
               for Col in the_Grid'Range (2) loop
                  the_Grid (Row, Col) := the_Image.Data.all (the_Image.Width * (Row - 1) + Col - 1);
               end loop;
            end loop;

         when others =>
            raise not_yet_implemented;       -- tbd : do these
      end case;
      return the_Grid;
   end to_greyscale_Pixels;

   procedure Insert_into_GL (id              : Integer;
                             Insert_Size     : Integer;
                             width           : Integer;
                             height          : Integer;
                             texFormat       : TexFormatEnm;
                             texPixelFormat  : TexPixelFormatEnm;
                             image_p         : Byte_Array_Ptr
                            ) is
      pragma Unreferenced (Insert_Size);

      ptr : constant GL.pointer := image_p.all (0)'Access;

   begin
      BindTexture (TEXTURE_2D, Uint (id));
      PixelStore (UNPACK_ALIGNMENT, 1);
      TexParameter (TEXTURE_2D, TEXTURE_WRAP_S, REPEAT);
      TexParameter (TEXTURE_2D, TEXTURE_WRAP_T, REPEAT);
      -- TexParameter (TEXTURE_2D, TEXTURE_MAG_FILTER, NEAREST);
      TexParameter (TEXTURE_2D, TEXTURE_MAG_FILTER, LINEAR);
      -- TexParameter (TEXTURE_2D, TEXTURE_MIN_FILTER, NEAREST);
      TexParameter (TEXTURE_2D, TEXTURE_MIN_FILTER, LINEAR);
      TexEnv (TEXTURE_ENV, TEXTURE_ENV_MODE, MODULATE);
      TexImage2D (TEXTURE_2D, 0, texFormat, Sizei (width),
                  Sizei (height), 0, texPixelFormat, GL_UNSIGNED_BYTE,
                  ptr);
   end Insert_into_GL;

   -- Workaround for the severe xxx'Read xxx'Write performance
   -- problems in the GNAT and ObjectAda compilers (as in 2009)
   -- This is possible if and only if Byte = Stream_Element and
   -- arrays types are both packed the same way.
   --
   subtype Size_test_a is Byte_Array (1 .. 19);
   subtype Size_test_b is Ada.Streams.Stream_Element_Array (1 .. 19);
   workaround_possible : constant Boolean :=
     Size_test_a'Size = Size_test_b'Size and then
     Size_test_a'Alignment = Size_test_b'Alignment;
   --

   procedure Fill_Buffer (b : in out Input_buffer);
   -- ^ Spec here to avoid in Get_Byte below (GNAT 2009):
   -- warning : call to subprogram with no separate spec prevents inlining

   procedure Fill_Buffer (b : in out Input_buffer)
   is
      --
      procedure BlockRead (
                           buffer        :    out Byte_Array;
                           actually_read :    out Natural
                          )
      is
         use Ada.Streams;
         Last_Read : Stream_Element_Offset;
      begin
         if workaround_possible then
            declare
               SE_Buffer : Stream_Element_Array (1 .. buffer'Length);
               -- direct mapping : buffer = SE_Buffer
               for SE_Buffer'Address use buffer'Address;
               pragma Import (Ada, SE_Buffer);
            begin
               Read (b.stm.all, SE_Buffer, Last_Read);
            end;
         else
            declare
               SE_Buffer : Stream_Element_Array (1 .. buffer'Length);
               -- need to copy array
            begin
               Read (b.stm.all, SE_Buffer, Last_Read);
               for i in buffer'Range loop
                  buffer (i) := Ubyte (SE_Buffer (Stream_Element_Offset (i - buffer'First) + SE_Buffer'First));
               end loop;
            end;
         end if;
         actually_read := Natural (Last_Read);
      end BlockRead;

   begin
      BlockRead (
                 buffer        => b.data,
                 actually_read => b.MaxInBufIdx
                );
      b.InputEoF := b.MaxInBufIdx = 0;
      b.InBufIdx := 1;
   end Fill_Buffer;

   procedure Attach_Stream (b    : out Input_buffer;
                            stm  :     Ada.Streams.Stream_IO.Stream_Access) is

   begin
      b.stm := stm;
      Fill_Buffer (b);
   end Attach_Stream;

   procedure Get_Byte (b : in out Input_buffer; Return_Byte : out Ubyte) is

   begin
      if b.InBufIdx > b.MaxInBufIdx then
         Fill_Buffer (b);
         if b.InputEoF then
            raise End_Error;
         end if;
      end if;
      Return_Byte := b.data (b.InBufIdx);
      b.InBufIdx := b.InBufIdx + 1;
   end Get_Byte;

   function To_TGA_Image (S  :  Ada.Streams.Stream_IO.Stream_Access) return Image is

      the_Image  : Image;
      stream_buf : Input_buffer;

      -- Run Length Encoding --
      RLE : Boolean;
      RLE_pixels_remaining : Natural := 0;
      pix_mem : Byte_Array (1 .. 4);
      is_run_packet : Boolean;

      procedure RLE_Pixel (iBits : Integer; pix : out Byte_Array) is

         procedure Get_pixel is

         begin
            case iBits is
            when 32 => -- BGRA
               Get_Byte (stream_buf, pix (pix'First + 2));
               Get_Byte (stream_buf, pix (pix'First + 1));
               Get_Byte (stream_buf, pix (pix'First));
               Get_Byte (stream_buf, pix (pix'First + 3));
            when 24 => -- BGR
               Get_Byte (stream_buf, pix (pix'First + 2));
               Get_Byte (stream_buf, pix (pix'First + 1));
               Get_Byte (stream_buf, pix (pix'First));
            when 8  => -- Grey
               Get_Byte (stream_buf, pix (pix'First));
            when others =>
               null;
            end case;
         end Get_pixel;

         tmp : GL.Ubyte;

      begin --  RLE_Pixel
         if RLE_pixels_remaining = 0 then -- load RLE code
            Get_Byte (stream_buf, tmp);
            Get_pixel;
            RLE_pixels_remaining := GL.Ubyte'Pos (tmp and 16#7F#);
            is_run_packet := (tmp and 16#80#) /= 0;
            if is_run_packet then
               case iBits is
               when 32 =>
                  pix_mem (1 .. 4) := pix;
               when 24 =>
                  pix_mem (1 .. 3) := pix;
               when 8  =>
                  pix_mem (1 .. 1) := pix;
               when others =>
                  null;
               end case;
            end if;
         else
            if is_run_packet then
               case iBits is
               when 32 =>
                  pix := pix_mem (1 .. 4);
               when 24 =>
                  pix := pix_mem (1 .. 3);
               when 8  =>
                  pix := pix_mem (1 .. 1);
               when others =>
                  null;
               end case;
            else
               Get_pixel;
            end if;
            RLE_pixels_remaining := RLE_pixels_remaining - 1;
         end if;
      end RLE_Pixel;

      --  =============
      --  getRGBA

      --  Reads in RGBA data for a 32bit image.
      --  =============

      procedure getRGBA (buffer : out Byte_Array) is
         i : Integer := buffer'First;
      begin
         if RLE then
            while i <= buffer'Last - 3 loop
               RLE_Pixel (32, buffer (i .. i + 3));
               i := i + 4;
            end loop;
         else
            while i <= buffer'Last - 3 loop
               -- TGA is stored in BGRA, make it RGBA
               Get_Byte (stream_buf, buffer (i + 2));
               Get_Byte (stream_buf, buffer (i + 1));
               Get_Byte (stream_buf, buffer (i));
               Get_Byte (stream_buf, buffer (i + 3));
               i := i + 4;
            end loop;
         end if;
         the_Image.tex_Format      := GL.RGBA;
         the_Image.tex_pixel_Format := GL.RGBA;
      end getRGBA;

      --  =============
      --  getRGB

      --  Reads in RGB data for a 24bit image.
      --  =============

      procedure getRGB (buffer : out Byte_Array) is
         i : Integer := buffer'First;
      begin
         if RLE then
            while i <= buffer'Last - 2 loop
               RLE_Pixel (24, buffer (i .. i + 2));
               i := i + 3;
            end loop;
         else
            while i <= buffer'Last - 2 loop
               -- TGA is stored in BGR, make it RGB
               Get_Byte (stream_buf, buffer (i + 2));
               Get_Byte (stream_buf, buffer (i + 1));
               Get_Byte (stream_buf, buffer (i));
               i := i + 3;
            end loop;
         end if;
         the_Image.tex_Format      := GL.RGB;
         the_Image.tex_pixel_Format := GL.RGB;
      end getRGB;

      --  =============
      --  getGray

      --  Gets the grayscale image data.  Used as an alpha channel.
      --  =============

      procedure getGray (buffer : out Byte_Array) is
      begin
         if RLE then
            for b in buffer'Range loop
               RLE_Pixel (8, buffer (b .. b));
            end loop;
         else
            for b in buffer'Range loop
               Get_Byte (stream_buf, buffer (b));
            end loop;
         end if;
         the_Image.tex_Format      := GL.LUMINANCE; -- ALPHA
         the_Image.tex_pixel_Format := GL.LUMINANCE;
      end getGray;

      --  =============
      --  getData

      --  Gets the image data for the specified bit depth.
      --  =============

      procedure getData (iBits : Integer; buffer : out Byte_Array) is
      begin
         Attach_Stream (stream_buf, S);
         case iBits is
         when 32 =>
            getRGBA (buffer);
            the_Image.blending_hint := True;
         when 24 =>
            getRGB (buffer);
            the_Image.blending_hint := False;
         when 8  =>
            getGray (buffer);
            the_Image.blending_hint := True;
         when others => null;
         end case;
      end getData;

      TGA_type : Byte_Array (0 .. 3);
      info     : Byte_Array (0 .. 5);
      dummy    : Byte_Array (1 .. 8);

      Image_Bits : Integer;
      Image_Type : Integer;

   begin -- to_TGA_Image
      Byte_Array'Read (S, TGA_type); -- read in colormap info and image type
      Byte_Array'Read (S, dummy);    -- seek past the header and useless info
      Byte_Array'Read (S, info);

      if TGA_type (1) /= GL.Ubyte'Val (0) then
         Raise_Exception (
                          TGA_Unsupported_Image_Type'Identity,
                          "TGA : palette not supported, please use BMP"
                         );
      end if;

      -- Image type:
      --      1=8 - bit palette style
      --      2=Direct [A]RGB image
      --      3=grayscale
      --      9=RLE version of Type 1
      --     10=RLE version of Type 2
      --     11=RLE version of Type 3

      Image_Type := GL.Ubyte'Pos (TGA_type (2));
      RLE := Image_Type >= 9;
      if RLE then
         Image_Type := Image_Type - 8;
         RLE_pixels_remaining := 0;
      end if;
      if Image_Type /= 2 and then Image_Type /= 3 then
         Raise_Exception (
                          TGA_Unsupported_Image_Type'Identity,
                          "TGA type =" & Integer'Image (Image_Type)
                         );
      end if;

      the_Image.Width  := GL.Ubyte'Pos (info (0)) + GL.Ubyte'Pos (info (1)) * 256;
      the_Image.Height := GL.Ubyte'Pos (info (2)) + GL.Ubyte'Pos (info (3)) * 256;
      Image_Bits   := GL.Ubyte'Pos (info (4));

      the_Image.size := the_Image.Width * the_Image.Height;

      -- 30 - Apr - 2006 : dimensions not power of two allowed, but discouraged in the docs.
      --
      --  -- make sure dimension is a power of 2
      --  if not (checkSize (imageWidth)  and  checkSize (imageHeight)) then
      --     raise TGA_BAD_DIMENSION;
      --  end if;

      -- make sure we are loading a supported TGA_type
      if Image_Bits /= 32 and then Image_Bits /= 24 and then Image_Bits /= 8 then
         raise TGA_Unsupported_Bits_per_pixel;
      end if;

      -- Allocation
      the_Image.Data := new Byte_Array (0 .. (Image_Bits / 8) * the_Image.size - 1);
      getData (Image_Bits, the_Image.Data.all);

      return the_Image;
   end To_TGA_Image;

   function To_TGA_Image (Filename : String) return Image is

      f          : File_Type;
      the_Image  : Image;

   begin
      begin
         Open (f, In_File, Filename);
      exception
         when Name_Error => Raise_Exception (File_Not_Found'Identity, " file name:" & Filename);
      end;
      the_Image := To_TGA_Image (Stream (f));
      Close (f);
      return the_Image;
   exception
      when e : others =>
         Close (f);
         Raise_Exception (Exception_Identity (e), " file name:" & Filename);
         return the_Image;
   end To_TGA_Image;

   --  =============
   --  loadTGA

   --  Loads up a targa stream.
   --  Supported types are 8, 24 and 32 uncompressed images.
   --  id is the texture ID to bind to.
   --  =============

   procedure Load_TGA (S             :     Ada.Streams.Stream_IO.Stream_Access;
                       Id            :     Integer;     -- Id is the texture identifier to bind to
                       blending_hint : out Boolean) is  -- has the image blending / transparency /alpha ?

      the_Image  : Image := To_TGA_Image (S);

   begin
      Insert_into_GL (id             => Id,
                      Insert_Size    => the_Image.size,
                      width          => the_Image.Width,
                      height         => the_Image.Height,
                      texFormat      => the_Image.tex_Format,
                      texPixelFormat => the_Image.tex_pixel_Format,
                      image_p        => the_Image.Data);

      -- release our data, its been uploaded to the GL system
      Free (the_Image.Data);

      blending_hint := the_Image.blending_hint;
   end Load_TGA;

   -- Template for all loaders from a file
   generic
      with procedure Stream_Loader (S : Stream_Access; id : Integer; blending_hint : out Boolean);
   procedure Load_XXX (name : String; id : Integer; blending_hint : out Boolean);

   procedure Load_XXX (name : String; id : Integer; blending_hint : out Boolean) is
      f : File_Type;
   begin
      begin
         Open (f, In_File, name);
      exception
         when Name_Error => Raise_Exception (File_Not_Found'Identity, " file name:" & name);
      end;
      Stream_Loader (Stream (f), id, blending_hint);
      Close (f);
   exception
      when e : others =>
         Close (f);
         Raise_Exception (Exception_Identity (e), " file name:" & name);
   end Load_XXX;

   procedure i_Load_TGA is new Load_XXX (Stream_Loader => Load_TGA);

   procedure Load_TGA (Name : String; Id : Integer; blending_hint : out Boolean) renames i_Load_TGA;

   -- BMP

   procedure Load_BMP (S             :     Ada.Streams.Stream_IO.Stream_Access; -- Input data stream
                       Id            :     Integer;     -- Id is the texture identifier to bind to
                       blending_hint : out Boolean) is  -- has the image blending / transparency /alpha ?

      imageData : Byte_Array_Ptr := null;
      stream_buf : Input_buffer;

      subtype Y_Loc is Natural range 0 .. 4095;
      subtype X_Loc is Natural range 0 .. 4095;

      -- 256 - col types

      subtype Color_Type is GL.Ubyte;

      type RGB_Color_Bytes is
         record
            Red    : Color_Type;
            Green  : Color_Type;
            Blue   : Color_Type;
         end record;

      type Color_Palette is array (Color_Type) of RGB_Color_Bytes;

      Palette  : Color_Palette;

      ----------------------------------------------------
      -- BMP format I/O                                 --
      --                                                --
      -- Rev 1.5  10 - May - 2006 GdM : added 4 - bit support  --
      -- Rev 1.4  11/02/99    RBS                       --
      --                                                --
      ----------------------------------------------------
      -- Coded by G. de Montmollin

      -- Code additions, changes, and corrections by Bob Sutton
      --
      -- Remarks expanded and altered
      -- Provided for scanline padding in data stream
      -- Corrected stream reading for images exceeding screen size.
      -- Provided selectable trim modes for oversize images
      -- Procedures originally Read_BMP_dimensions now Read_BMP_Header
      -- Some exceptions added
      --
      -- Rev 1.2  RBS.  Added variable XY screen location for BMP
      -- Rev 1.3  RBS.  Added image inversion & reversal capability
      -- Rev 1.4  RBS.  Activated LOCATE centering / clipping options
      --
      -- This version presumes that the infile is a new style, 256 color bitmap.
      -- The Bitmap Information Header structure (40 bytes) is presumed
      -- instead of the pre - Windows 3.0 Bitmap Core Header Structure (12 Bytes)
      -- Pos 15 (0EH), if 28H, is valid BIH structure.  If 0CH, is BCH structure.

      procedure Read_BMP_Header (S : Stream_Access;
                                 width      : out X_Loc;
                                 height     : out Y_Loc;
                                 image_bits : out Integer;
                                 offset     : out U32) is

         fsz : U32;
         ih : U32;
         w, dummy16 : U16;
         n : U32;
         Str2 :  String (1 .. 2);
         Str4 :  String (1 .. 4);
         Str20 : String (1 .. 20);

         -- Get numbers with correct trucmuche endian, to ensure
         -- correct header loading on some non - Intel machines

         generic
            type Number is mod <>; -- range <> in Ada83 version (fake Interfaces)
         procedure Read_Intel_x86_number (n : out Number);

         procedure Read_Intel_x86_number (n : out Number) is
            b : GL.Ubyte;
            m : Number := 1;
         begin
            n := 0;
            for i in 1 .. Number'Size / 8 loop
               GL.Ubyte'Read (S, b);
               n := n + m * Number (b);
               m := m * 256;
            end loop;
         end Read_Intel_x86_number;

         procedure Read_Intel is new Read_Intel_x86_number (U16);
         procedure Read_Intel is new Read_Intel_x86_number (U32);

      begin
         --   First 14 bytes is file header structure.
         --   Pos= 1,  read 2 bytes, file signature word
         String'Read (S, Str2);
         if Str2 /= "BM" then
            raise Not_BMP_format;
         end if;
         --   Pos= 3,  read the file size
         Read_Intel (fsz);
         --   Pos= 7, read four bytes, unknown
         String'Read (S, Str4);
         --   Pos= 11, read four bytes offset, file top to bitmap data.
         --            For 256 colors, this is usually 36 04 00 00
         Read_Intel (offset);
         --   Pos= 15. The beginning of Bitmap information header.
         --   Data expected :  28H, denoting 40 byte header
         Read_Intel (ih);
         --   Pos= 19. Bitmap width, in pixels.  Four bytes
         Read_Intel (n);
         width :=  X_Loc (n);
         --   Pos= 23. Bitmap height, in pixels.  Four bytes
         Read_Intel (n);
         height := Y_Loc (n);
         --   Pos= 27, skip two bytes.  Data is number of Bitmap planes.
         Read_Intel (dummy16); -- perform the skip
         --   Pos= 29, Number of bits per pixel
         --   Value 8, denoting 256 color, is expected
         Read_Intel (w);
         if w /= 8 and then w /= 4 and then w /= 1 then
            raise BMP_Unsupported_Bits_per_Pixel;
         end if;
         image_bits := Integer (w);
         --   Pos= 31, read four bytees
         Read_Intel (n);                -- Type of compression used
         if n /= 0 then
            raise Unsupported_compression;
         end if;

         --   Pos= 35 (23H), skip twenty bytes
         String'Read (S, Str20);     -- perform the skip

         --   Pos= 55 (36H), - start of palette
      end Read_BMP_Header;

      procedure Load_BMP_Palette (S           :     Stream_Access;
                                  Image_Bits  :     Integer;
                                  BMP_Palette : out Color_Palette) is

         dummy : GL.Ubyte;
         mc : constant Color_Type := (2**Image_Bits) - 1;

      begin
         for DAC in 0 .. mc loop
            GL.Ubyte'Read (S, BMP_Palette (DAC).Blue);
            GL.Ubyte'Read (S, BMP_Palette (DAC).Green);
            GL.Ubyte'Read (S, BMP_Palette (DAC).Red);
            GL.Ubyte'Read (S, dummy);
         end loop;
      end Load_BMP_Palette;

      -- Load image only from stream (after having read header and palette!)

      procedure Load_BMP_Image (S           : Stream_Access;
                                width       :        X_Loc;
                                height      :        Y_Loc;
                                Buffer      : in out Byte_Array;
                                BMP_bits    :        Integer;
                                BMP_Palette : Color_Palette) is

         idx : Natural;
         b01, b : GL.Ubyte := 0;
         pair : Boolean := True;
         bit : Natural range 0 .. 7 := 0;
         --
         x3 : Natural; -- idx + x*3 (each pixel takes 3 bytes)
         x3_max : Natural;
         --
         procedure Fill_palettized is
            pragma Inline (Fill_palettized);
         begin
            Buffer (x3) := Ubyte (BMP_Palette (b).Red);
            Buffer (x3 + 1) := Ubyte (BMP_Palette (b).Green);
            Buffer (x3 + 2) := Ubyte (BMP_Palette (b).Blue);
         end Fill_palettized;
         --
      begin
         Attach_Stream (stream_buf, S);
         for y in 0 .. height - 1 loop
            idx := y * width * 3; -- GL destination picture is 24 bit
            x3 := idx;
            x3_max := idx + (width - 1) * 3;
            case BMP_bits is
            when 1 => -- B/W
               while x3 <= x3_max loop
                  if bit = 0 then
                     Get_Byte (stream_buf, b01);
                  end if;
                  b := (b01 and 16#80#) / 16#80#;
                  Fill_palettized;
                  b01 := b01 * 2; -- cannot overflow.
                  if bit = 7 then
                     bit := 0;
                  else
                     bit := bit + 1;
                  end if;
                  x3 := x3 + 3;
               end loop;
            when 4 => -- 16 colour image
               while x3 <= x3_max loop
                  if pair then
                     Get_Byte (stream_buf, b01);
                     b := (b01 and 16#F0#) / 16#10#;
                  else
                     b := (b01 and 16#0F#);
                  end if;
                  pair := not pair;
                  Fill_palettized;
                  x3 := x3 + 3;
               end loop;
            when 8 => -- 256 colour image
               while x3 <= x3_max loop
                  Get_Byte (stream_buf, b);
                  Fill_palettized;
                  x3 := x3 + 3;
               end loop;
            when others =>
               null;
            end case;
         end loop;
      end Load_BMP_Image;

      Width                : X_Loc;
      Height               : Y_Loc;
      offset               : U32;
      BMP_bits, imagebits  : Integer;
      BMP_Size             : Integer;
      BMP_tex_format       : GL.TexFormatEnm;
      BMP_tex_pixel_format : GL.TexPixelFormatEnm;

   begin
      Read_BMP_Header (S, Width, Height, BMP_bits, offset);
      imagebits := 24;
      blending_hint := False; -- no blending with BMP's
      BMP_tex_format      := GL.RGB;
      BMP_tex_pixel_format := GL.RGB;
      Load_BMP_Palette (S, BMP_bits, Palette);

      BMP_Size := Width * Height;

      -- Allocation
      imageData := new Byte_Array (0 .. (imagebits / 8) * BMP_Size - 1);

      Load_BMP_Image
        (S, Width, Height, imageData.all,
         BMP_bits, Palette);

      Insert_into_GL (id             => Id,
                      Insert_Size    => BMP_Size,
                      width          => Width,
                      height         => Height,
                      texFormat      => BMP_tex_format,
                      texPixelFormat => BMP_tex_pixel_format,
                      image_p        => imageData
                     );

      -- release our data, its been uploaded to the GL system
      Free (imageData);

   end Load_BMP;

   procedure i_Load_BMP is new Load_XXX (Stream_Loader => Load_BMP);

   procedure Load_BMP (Name : String; Id : Integer; blending_hint : out Boolean) renames i_Load_BMP;

   procedure Load (name          :     String;            -- file name
                   format        :     Supported_format;  -- expected file format
                   ID            :     Integer;           -- ID is the texture identifier to bind to
                   blending_hint : out Boolean) is        -- has blending / transparency /alpha ?

   begin
      case format is
      when BMP => Load_BMP (name, ID, blending_hint);
      when TGA => Load_TGA (name, ID, blending_hint);
      end case;
   end Load;

   procedure Load (s             :     Ada.Streams.Stream_IO.Stream_Access; -- input data stream (e.g. Unzip.Streams)
                   format        :     Supported_format;  -- expected file format
                   ID            :     Integer;           -- ID is the texture identifier to bind to
                   blending_hint : out Boolean) is        -- has blending / transparency /alpha ?

   begin
      case format is
      when BMP => Load_BMP (s, ID, blending_hint);
      when TGA => Load_TGA (s, ID, blending_hint);
      end case;
   end Load;

   -------------
   -- Outputs --
   -------------

   generic
      type Number is mod <>;
      s : Stream_Access;
   procedure Write_Intel_x86_number (n : Number);

   procedure Write_Intel_x86_number (n : Number) is
      m : Number := n;
      bytes : constant Integer := Number'Size / 8;
   begin
      for i in 1 .. bytes loop
         U8'Write (s, U8 (m mod 256));
         m := m / 256;
      end loop;
   end Write_Intel_x86_number;

   procedure Write_raw_BGR_frame (s : Stream_Access; width, height : Natural) is
      -- 4 - byte padding for .bmp/.avi formats is the same as GL's default
      -- padding : see glPixelStore, GL_[UN]PACK_ALIGNMENT = 4 as initial value.
      -- http://www.opengl.org/sdk/docs/man/xhtml/glPixelStore.xml
      --
      padded_row_size : constant Positive :=
        4 * Integer (C_Float'Ceiling (C_Float (width) * 3.0 / 4.0));
      -- (in bytes)
      --
      type Temp_bitmap_type is array (Natural range <>) of aliased GL.Ubyte;
      PicData : Temp_bitmap_type (0 .. (padded_row_size + 4) * (height + 4) - 1);
      -- No dynamic allocation needed!
      -- The "+ 4" are there to avoid parity address problems when GL writes
      -- to the buffer.
      type loc_pointer is new GL.pointer;
      function Cvt is new Ada.Unchecked_Conversion (System.Address, loc_pointer);
      -- This method is functionally identical as GNAT's Unrestricted_Access
      -- but has no type safety (cf GNAT Docs)
      pragma No_Strict_Aliasing (loc_pointer); -- recommended by GNAT 2005 +
      pPicData : loc_pointer;
      data_max : constant Integer := padded_row_size * height - 1;
   begin
      pPicData := Cvt (PicData (0)'Address);
      GL.ReadPixels (
                     0, 0,
                     GL.Sizei (width), GL.Sizei (height),
                     GL.BGR,
                     GL.GL_UNSIGNED_BYTE,
                     GL.pointer (pPicData)
                    );
      if workaround_possible then
         declare
            use Ada.Streams;
            SE_Buffer    : Stream_Element_Array (0 .. Stream_Element_Offset (PicData'Last));
            for SE_Buffer'Address use PicData'Address;
            pragma Import (Ada, SE_Buffer);
         begin
            Ada.Streams.Write (s.all, SE_Buffer (0 .. Stream_Element_Offset (data_max)));
         end;
      else
         Temp_bitmap_type'Write (s, PicData (0 .. data_max));
      end if;
   end Write_raw_BGR_frame;

   -------------------------------------------------------
   -- BMP RGB (A) output of the current, active viewport --
   -------------------------------------------------------

   procedure Screenshot (Name : String) is
      -- Translated by (New) P2Ada v. 15 - Nov - 2006
      -- http://wiki.delphigl.com/index.php/Screenshot
      f : Ada.Streams.Stream_IO.File_Type;

      type Bitmap_File_Header is record
         bfType      : U16;
         bfSize      : U32;
         bfReserved1 : U16 := 0;
         bfReserved2 : U16 := 0;
         bfOffBits   : U32;
      end record;
      pragma Pack (Bitmap_File_Header);
      for Bitmap_File_Header'Size use 8 * 14;

      type Bitmap_Info_Header is record
         biSize          : U32;
         biWidth         : I32;
         biHeight        : I32;
         biPlanes        : U16;
         biBitCount      : U16;
         biCompression   : U32;
         biSizeImage     : U32;
         biXPelsPerMeter : I32 := 0;
         biYPelsPerMeter : I32 := 0;
         biClrUsed       : U32 := 0;
         biClrImportant  : U32 := 0;
      end record;
      pragma Pack (Bitmap_Info_Header);
      for Bitmap_Info_Header'Size use 8 * 40;

      FileInfo            : Bitmap_Info_Header;
      FileHeader          : Bitmap_File_Header;
      Screenshot_Viewport : array (0 .. 3) of aliased GL.Int;

      type GL_IntPointer is new GL.intPointer;
      function Cvt is new Ada.Unchecked_Conversion (System.Address, GL_IntPointer);
      -- This method is functionally identical as GNAT's Unrestricted_Access
      -- but has no type safety (cf GNAT Docs)
      pragma No_Strict_Aliasing (GL_IntPointer); -- recommended by GNAT 2005+

   begin
      --  Gr��e des Viewports abfragen --> Sp�tere Bildgr��enangaben
      GL.GetIntegerv (GL.VIEWPORT, GL.intPointer (Cvt (Screenshot_Viewport (0)'Address)));

      --  Initialisieren der Daten des Headers
      FileHeader.bfType := 16#4D42#; -- 'BM'
      FileHeader.bfOffBits := Bitmap_Info_Header'Size / 8 + Bitmap_File_Header'Size / 8;

      --  Schreiben der Bitmap - Informationen
      FileInfo.biSize       := Bitmap_Info_Header'Size / 8;
      FileInfo.biWidth      := I32 (Screenshot_Viewport (2));
      FileInfo.biHeight     := I32 (Screenshot_Viewport (3));
      FileInfo.biPlanes     := 1;
      FileInfo.biBitCount   := 24;
      FileInfo.biCompression := 0;
      FileInfo.biSizeImage  :=
        U32 (
             -- 4 - byte padding for .bmp/.avi formats
             4 * Integer (C_Float'Ceiling (C_Float (FileInfo.biWidth) * 3.0 / 4.0)) *
               Integer (FileInfo.biHeight)
            );

      --  Gr��enangabe auch in den Header �bernehmen
      FileHeader.bfSize := FileHeader.bfOffBits + FileInfo.biSizeImage;

      --  Und den ganzen M�ll in die Datei schieben ; - )
      --  Moderne Leute nehmen daf�r auch Streams . ..
      Create (f, Out_File, Name);
      declare
         procedure Write_Intel is new Write_Intel_x86_number (U16, Stream (f));
         procedure Write_Intel is new Write_Intel_x86_number (U32, Stream (f));
         function Cvt is new Ada.Unchecked_Conversion (I32, U32);

      begin
         -- ** Only for Intel endianess : ** --
         --  BITMAPFILEHEADER'Write (Stream (F), FileHeader);
         --  BITMAPINFOHEADER'Write (Stream (F), FileInfo);
         --
         -- ** Endian - safe : ** --
         Write_Intel (FileHeader.bfType);
         Write_Intel (FileHeader.bfSize);
         Write_Intel (FileHeader.bfReserved1);
         Write_Intel (FileHeader.bfReserved2);
         Write_Intel (FileHeader.bfOffBits);
         --
         Write_Intel (FileInfo.biSize);
         Write_Intel (Cvt (FileInfo.biWidth));
         Write_Intel (Cvt (FileInfo.biHeight));
         Write_Intel (FileInfo.biPlanes);
         Write_Intel (FileInfo.biBitCount);
         Write_Intel (FileInfo.biCompression);
         Write_Intel (FileInfo.biSizeImage);
         Write_Intel (Cvt (FileInfo.biXPelsPerMeter));
         Write_Intel (Cvt (FileInfo.biYPelsPerMeter));
         Write_Intel (FileInfo.biClrUsed);
         Write_Intel (FileInfo.biClrImportant);
         --
         Write_raw_BGR_frame (Stream (f), Integer (Screenshot_Viewport (2)), Integer (Screenshot_Viewport (3)));
         Close (f);
      exception
         when others =>
            Close (f);
            raise;
      end;
   end Screenshot;

   -------------------
   -- Video capture --
   -------------------

   -- Exceptionally we define global variables since it is not expected
   -- that more that one capture is taken at the same time.
   avi : Ada.Streams.Stream_IO.File_Type;
   frames : Natural;
   rate : Positive;
   width, height : Positive;
   bmp_size : U32;

   procedure Write_RIFF_headers is
      -- Written 1st time to take place (but # of frames unknown)
      -- Written 2nd time for setting # of frames, sizes, etc.
      --
      padded_row_size : constant Positive :=
        4 * Integer (C_Float'Ceiling (C_Float (width) * 3.0 / 4.0));
      calc_bmp_size : constant U32 := U32 (padded_row_size * height);
      index_size : constant U32 := U32 (frames) * 16;
      movie_size : constant U32 := 4 + U32 (frames) * (calc_bmp_size + 8);
      second_list_size : constant U32 := 4 + 64 + 48;
      first_list_size  : constant U32 := (4 + 64) + (8 + second_list_size);
      file_size : constant U32 := 8 + (8 + first_list_size) + (4 + movie_size) + (8 + index_size);
      s : constant Stream_Access := Stream (avi);
      procedure Write_Intel is new Write_Intel_x86_number (U16, s);
      procedure Write_Intel is new Write_Intel_x86_number (U32, s);
      microseconds_per_frame : constant U32 := U32 (1_000_000.0 / Long_Float (rate));

   begin
      bmp_size := calc_bmp_size;
      String'Write (s, "RIFF");
      U32'Write (s, file_size);
      String'Write (s, "AVI ");
      String'Write (s, "LIST");
      Write_Intel (first_list_size);
      String'Write (s, "hdrl");
      String'Write (s, "avih");
      Write_Intel (U32'(56));
      -- Begin of AVI Header
      Write_Intel (microseconds_per_frame);
      Write_Intel (U32'(0));  -- MaxBytesPerSec
      Write_Intel (U32'(0));  -- Reserved1
      Write_Intel (U32'(16)); -- Flags (16 = has an index)
      Write_Intel (U32 (frames));
      Write_Intel (U32'(0));  -- InitialFrames
      Write_Intel (U32'(1));  -- Streams
      Write_Intel (bmp_size);
      Write_Intel (U32 (width));
      Write_Intel (U32 (height));
      Write_Intel (U32'(0));  -- Scale
      Write_Intel (U32'(0));  -- Rate
      Write_Intel (U32'(0));  -- Start
      Write_Intel (U32'(0));  -- Length
      -- End of AVI Header
      String'Write (s, "LIST");
      Write_Intel (second_list_size);
      String'Write (s, "strl");
      -- Begin of Str
      String'Write (s, "strh");
      Write_Intel (U32'(56));
      String'Write (s, "vids");
      String'Write (s, "DIB ");
      Write_Intel (U32'(0));     -- flags
      Write_Intel (U32'(0));     -- priority
      Write_Intel (U32'(0));     -- initial frames
      Write_Intel (microseconds_per_frame); -- Scale
      Write_Intel (U32'(1_000_000));        -- Rate
      Write_Intel (U32'(0));                -- Start
      Write_Intel (U32 (frames));            -- Length
      Write_Intel (bmp_size);               -- SuggestedBufferSize
      Write_Intel (U32'(0));                -- Quality
      Write_Intel (U32'(0));                -- SampleSize
      Write_Intel (U32'(0));
      Write_Intel (U16 (width));
      Write_Intel (U16 (height));
      -- End of Str
      String'Write (s, "strf");
      Write_Intel (U32'(40));
      -- Begin of BMI
      Write_Intel (U32'(40));    -- BM header size (like BMP)
      Write_Intel (U32 (width));
      Write_Intel (U32 (height));
      Write_Intel (U16'(1));     -- Planes
      Write_Intel (U16'(24));    -- BitCount
      Write_Intel (U32'(0));     -- Compression
      Write_Intel (bmp_size);    -- SizeImage
      Write_Intel (U32'(3780));  -- XPelsPerMeter
      Write_Intel (U32'(3780));  -- YPelsPerMeter
      Write_Intel (U32'(0));     -- ClrUsed
      Write_Intel (U32'(0));     -- ClrImportant
      -- End of BMI
      String'Write (s, "LIST");
      Write_Intel (movie_size);
      String'Write (s, "movi");
   end Write_RIFF_headers;

   procedure Start_Capture (AVI_Name : String; frame_rate : Positive) is

      Capture_Viewport  : array (0 .. 3) of aliased GL.Int;

      type GL_Int_Pointer is new GL.intPointer;
      function Cvt is new Ada.Unchecked_Conversion (System.Address, GL_Int_Pointer);
      -- This method is functionally identical as GNAT's Unrestricted_Access
      -- but has no type safety (cf GNAT Docs)
      pragma No_Strict_Aliasing (GL_Int_Pointer); -- recommended by GNAT 2005 +

   begin
      Create (avi, Out_File, AVI_Name);
      frames := 0;
      rate := frame_rate;
      GL.GetIntegerv (GL.VIEWPORT, GL.intPointer (Cvt (Capture_Viewport (0)'Address)));
      width := Positive (Capture_Viewport (2));
      height := Positive (Capture_Viewport (3));
      -- NB : GL viewport resizing should be blocked during the video capture!
      Write_RIFF_headers;
   end Start_Capture;

   procedure Capture_Frame is

      s : constant Stream_Access := Stream (avi);
      procedure Write_Intel is new Write_Intel_x86_number (U32, s);

   begin
      String'Write (s, "00db");
      Write_Intel (bmp_size);
      Write_raw_BGR_frame (s, width, height);
      frames := frames + 1;
   end Capture_Frame;

   procedure Stop_Capture is

      index_size : constant U32 := U32 (frames) * 16;
      s : constant Stream_Access := Stream (avi);
      procedure Write_Intel is new Write_Intel_x86_number (U32, s);
      ChunkOffset : U32 := 4;

   begin
      -- write the index section
      String'Write (s, "idx1");
      --
      Write_Intel (index_size);
      for f in 1 .. frames loop
         String'Write (s, "00db");
         Write_Intel (U32'(16)); -- keyframe
         Write_Intel (ChunkOffset);
         ChunkOffset := ChunkOffset + bmp_size + 8;
         Write_Intel (bmp_size);
      end loop;
      -- Go back to file beginning .. .
      Set_Index (avi, 1);
      Write_RIFF_headers; -- rewrite headers with correct data
      Close (avi);
   end Stop_Capture;

end GL.IO;
