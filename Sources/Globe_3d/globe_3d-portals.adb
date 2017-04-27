with GLU;

with GLOBE_3D.Math;

package body GLOBE_3D.Portals is

   -- Cheap but fast portal method with rectangles.

   procedure Intersect (A, B : Rectangle; C : out Rectangle; non_empty : out Boolean) is

   begin
      C := (X1 => Integer'Max (A.X1, B.X1),
            X2 => Integer'Min (A.X2, B.X2),
            Y1 => Integer'Max (A.Y1, B.Y1),
            Y2 => Integer'Min (A.Y2, B.Y2));
      non_empty := C.X1 <= C.X2 and then C.Y1 <= C.Y2;
   end Intersect;

   procedure Projection (P       :     Point_3D;
                         x, y    : out Integer;
                         success : out Boolean) is

      model, proj : GLU.Matrix_Double;
      view        : GLU.Viewport_Rec;
      uu, vv, ww  : GL.Double;

      z_a : constant := 0.0001;
      z_z : constant := 1.0 - z_a;
      -- GLU sometimes gives fuzzy (e.g. -3612 instead of +4243)
      -- x, y coordinates, with z outside ]0;1[; looks like a wrap-around
      -- of large integer values

   begin
      GLU.Get (GL.MODELVIEW_MATRIX, model);
      GLU.Get (GL.PROJECTION_MATRIX, proj);
      GLU.Get (view);
      GLU.Project (P (0), P (1), P (2), model, proj, view, uu, vv, ww, success);
      success := success and then ww > z_a and then ww < z_z;
      if success then
         x := Integer (uu);
         y := Integer (vv);
         -- info_a_pnt (0) := (uu, vv, ww);
      else
         x := -1;
         y := -1;
      end if;
   end Projection;

   procedure Find_bounding_box (o       :     Object_3D'Class;
                                face    :     Positive;
                                b       : out Rectangle;
                                success : out Boolean) is

      x, y : Integer;
      proj_success : Boolean;
      use GLOBE_3D.Math;

   begin
      b := (X1 | Y1 => Integer'Last, X2 | Y2 => Integer'First);

      for sf in reverse 1 .. o.Face_Invariant (face).last_edge loop
         Projection (o.Point (o.Face_Invariant (face).P_compact (sf)) + o.Centre,
                     x, y,
                     proj_success);
         if proj_success then
            -- info_a_pnt (sf) := info_a_pnt (0);
            b := (X1 => Integer'Min (b.X1, x),
                  X2 => Integer'Max (b.X2, x),
                  Y1 => Integer'Min (b.Y1, y),
                  Y2 => Integer'Max (b.Y2, y));
         else
            success := False;
            return; -- we cannot project all edges of the polygon, then fail.
         end if;
      end loop;
      success := True;
   end Find_bounding_box;

   procedure Draw_boundary (main, clip : Rectangle) is

      z : constant := 0.0;

      procedure Line (x1, y1, x2, y2 : Integer) is

      begin
         Vertex (GL.Double (x1), GL.Double (y1), z);
         Vertex (GL.Double (x2), GL.Double (y2), z);
      end Line;

      procedure Frame_Rect (x1, y1, x2, y2 : Integer) is

      begin
         Line (x1, y1, x2, y1);
         Line (x2, y1, x2, y2);
         Line (x2, y2, x1, y2);
         Line (x1, y2, x1, y1);
      end Frame_Rect;

      rect : Rectangle;

   begin
      GL.Disable (GL.LIGHTING);
      GL.Disable (GL.TEXTURE_2D);
      -- GL.Disable (GL.DEPTH_TEST); -- eeerh, @#*$!, doesn't work!
      -- Workaround, we make the rectangle 1 pixel smaller
      rect := (clip.X1 + 1, clip.Y1 + 1, clip.X2 - 1, clip.Y2 - 1);
      -- Push current matrix mode and viewport attributes.
      GL.PushAttrib (GL.TRANSFORM_BIT + GL.VIEWPORT_BIT);
      GL.MatrixMode (GL.PROJECTION);
      GL.PushMatrix;
      GL.LoadIdentity;
      GL.Ortho (ortho_left   => 0.0,
                ortho_right  => GL.Double (main.X2 - 1),
                bottom       => 0.0,
                top          => GL.Double (main.Y2 - 1),
                near_val     => -1.0,
                far_val      => 1.0);

      GL.MatrixMode (GL.MODELVIEW);
      GL.PushMatrix;
      GL.LoadIdentity;

      -- A green rectangle to signal the clipping area
      GL.Color (0.1, 1.0, 0.1, 1.0);
      GL_Begin (GL.LINES);
      Frame_Rect (rect.X1,  rect.Y1,  rect.X2,  rect.Y2);
      GL_End;
      -- A red cross across the area
      GL.Color (1.0, 0.1, 0.1, 1.0);
      GL_Begin (GL.LINES);
      Line (clip.X1, clip.Y1, clip.X2, clip.Y2);
      Line (clip.X2, clip.Y1, clip.X1, clip.Y2);
      GL_End;

      GL.PopMatrix;
      GL.MatrixMode (GL.PROJECTION);
      GL.PopMatrix;
      GL.PopAttrib;
      GL.Enable (GL.LIGHTING);
      -- GL.Enable (GL.DEPTH_TEST);

   end Draw_boundary;

end GLOBE_3D.Portals;
