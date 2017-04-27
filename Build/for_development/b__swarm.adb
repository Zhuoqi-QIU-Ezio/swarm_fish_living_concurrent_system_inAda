pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__swarm.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__swarm.adb");
pragma Suppress (Overflow_Check);

with System.Restrictions;
with Ada.Exceptions;

package body ada_main is
   pragma Warnings (Off);

   E140 : Short_Integer; pragma Import (Ada, E140, "system__os_lib_E");
   E011 : Short_Integer; pragma Import (Ada, E011, "system__soft_links_E");
   E186 : Short_Integer; pragma Import (Ada, E186, "system__fat_flt_E");
   E156 : Short_Integer; pragma Import (Ada, E156, "system__fat_lflt_E");
   E150 : Short_Integer; pragma Import (Ada, E150, "system__fat_llf_E");
   E021 : Short_Integer; pragma Import (Ada, E021, "system__exception_table_E");
   E173 : Short_Integer; pragma Import (Ada, E173, "ada__containers_E");
   E128 : Short_Integer; pragma Import (Ada, E128, "ada__io_exceptions_E");
   E147 : Short_Integer; pragma Import (Ada, E147, "ada__numerics_E");
   E167 : Short_Integer; pragma Import (Ada, E167, "ada__strings_E");
   E169 : Short_Integer; pragma Import (Ada, E169, "ada__strings__maps_E");
   E172 : Short_Integer; pragma Import (Ada, E172, "ada__strings__maps__constants_E");
   E087 : Short_Integer; pragma Import (Ada, E087, "ada__tags_E");
   E127 : Short_Integer; pragma Import (Ada, E127, "ada__streams_E");
   E053 : Short_Integer; pragma Import (Ada, E053, "interfaces__c_E");
   E055 : Short_Integer; pragma Import (Ada, E055, "interfaces__c__strings_E");
   E023 : Short_Integer; pragma Import (Ada, E023, "system__exceptions_E");
   E143 : Short_Integer; pragma Import (Ada, E143, "system__file_control_block_E");
   E243 : Short_Integer; pragma Import (Ada, E243, "ada__streams__stream_io_E");
   E138 : Short_Integer; pragma Import (Ada, E138, "system__file_io_E");
   E130 : Short_Integer; pragma Import (Ada, E130, "system__finalization_root_E");
   E125 : Short_Integer; pragma Import (Ada, E125, "ada__finalization_E");
   E188 : Short_Integer; pragma Import (Ada, E188, "system__storage_pools_E");
   E192 : Short_Integer; pragma Import (Ada, E192, "system__finalization_masters_E");
   E190 : Short_Integer; pragma Import (Ada, E190, "system__storage_pools__subpools_E");
   E071 : Short_Integer; pragma Import (Ada, E071, "system__task_info_E");
   E276 : Short_Integer; pragma Import (Ada, E276, "ada__calendar_E");
   E300 : Short_Integer; pragma Import (Ada, E300, "ada__calendar__delays_E");
   E153 : Short_Integer; pragma Import (Ada, E153, "system__assertions_E");
   E233 : Short_Integer; pragma Import (Ada, E233, "system__pool_global_E");
   E334 : Short_Integer; pragma Import (Ada, E334, "system__random_seed_E");
   E015 : Short_Integer; pragma Import (Ada, E015, "system__secondary_stack_E");
   E208 : Short_Integer; pragma Import (Ada, E208, "ada__strings__unbounded_E");
   E241 : Short_Integer; pragma Import (Ada, E241, "system__strings__stream_ops_E");
   E385 : Short_Integer; pragma Import (Ada, E385, "system__tasking__async_delays_E");
   E107 : Short_Integer; pragma Import (Ada, E107, "system__tasking__initialization_E");
   E045 : Short_Integer; pragma Import (Ada, E045, "ada__real_time_E");
   E134 : Short_Integer; pragma Import (Ada, E134, "ada__text_io_E");
   E117 : Short_Integer; pragma Import (Ada, E117, "system__tasking__protected_objects_E");
   E121 : Short_Integer; pragma Import (Ada, E121, "system__tasking__protected_objects__entries_E");
   E115 : Short_Integer; pragma Import (Ada, E115, "system__tasking__queuing_E");
   E381 : Short_Integer; pragma Import (Ada, E381, "system__tasking__stages_E");
   E374 : Short_Integer; pragma Import (Ada, E374, "barrier_type_E");
   E266 : Short_Integer; pragma Import (Ada, E266, "bzip2_E");
   E099 : Short_Integer; pragma Import (Ada, E099, "exceptions_E");
   E361 : Short_Integer; pragma Import (Ada, E361, "generic_protected_E");
   E159 : Short_Integer; pragma Import (Ada, E159, "gl_E");
   E198 : Short_Integer; pragma Import (Ada, E198, "gl__buffer_E");
   E179 : Short_Integer; pragma Import (Ada, E179, "gl__errors_E");
   E206 : Short_Integer; pragma Import (Ada, E206, "gl__geometry_E");
   E288 : Short_Integer; pragma Import (Ada, E288, "gl__frustums_E");
   E239 : Short_Integer; pragma Import (Ada, E239, "gl__io_E");
   E247 : Short_Integer; pragma Import (Ada, E247, "gl__materials_E");
   E216 : Short_Integer; pragma Import (Ada, E216, "gl__math_E");
   E237 : Short_Integer; pragma Import (Ada, E237, "gl__textures_E");
   E181 : Short_Integer; pragma Import (Ada, E181, "glu_E");
   E202 : Short_Integer; pragma Import (Ada, E202, "gl__buffer__texture_coords_E");
   E185 : Short_Integer; pragma Import (Ada, E185, "gl__skins_E");
   E290 : Short_Integer; pragma Import (Ada, E290, "gl__skinned_geometry_E");
   E294 : Short_Integer; pragma Import (Ada, E294, "glut_E");
   E342 : Short_Integer; pragma Import (Ada, E342, "glut__devices_E");
   E348 : Short_Integer; pragma Import (Ada, E348, "game_control_E");
   E292 : Short_Integer; pragma Import (Ada, E292, "glut_2d_E");
   E338 : Short_Integer; pragma Import (Ada, E338, "graphics_setup_E");
   E352 : Short_Integer; pragma Import (Ada, E352, "keyboard_E");
   E146 : Short_Integer; pragma Import (Ada, E146, "real_type_E");
   E145 : Short_Integer; pragma Import (Ada, E145, "generic_sliding_statistics_E");
   E298 : Short_Integer; pragma Import (Ada, E298, "graphics_framerates_E");
   E305 : Short_Integer; pragma Import (Ada, E305, "matrices_E");
   E307 : Short_Integer; pragma Import (Ada, E307, "quaternions_E");
   E354 : Short_Integer; pragma Import (Ada, E354, "screenshots_E");
   E396 : Short_Integer; pragma Import (Ada, E396, "swarm_control_concurrent_generic_E");
   E392 : Short_Integer; pragma Import (Ada, E392, "vectors_2d_E");
   E309 : Short_Integer; pragma Import (Ada, E309, "vectors_3d_E");
   E303 : Short_Integer; pragma Import (Ada, E303, "rotations_E");
   E389 : Short_Integer; pragma Import (Ada, E389, "vectors_3d_lf_E");
   E326 : Short_Integer; pragma Import (Ada, E326, "vectors_4d_E");
   E393 : Short_Integer; pragma Import (Ada, E393, "vectors_2d_i_E");
   E316 : Short_Integer; pragma Import (Ada, E316, "vectors_2d_n_E");
   E394 : Short_Integer; pragma Import (Ada, E394, "vectors_2d_p_E");
   E391 : Short_Integer; pragma Import (Ada, E391, "vectors_conversions_E");
   E379 : Short_Integer; pragma Import (Ada, E379, "vehicle_task_type_E");
   E274 : Short_Integer; pragma Import (Ada, E274, "zip_streams_E");
   E270 : Short_Integer; pragma Import (Ada, E270, "zip_E");
   E162 : Short_Integer; pragma Import (Ada, E162, "globe_3d_E");
   E346 : Short_Integer; pragma Import (Ada, E346, "actors_E");
   E249 : Short_Integer; pragma Import (Ada, E249, "globe_3d__math_E");
   E251 : Short_Integer; pragma Import (Ada, E251, "globe_3d__options_E");
   E253 : Short_Integer; pragma Import (Ada, E253, "globe_3d__portals_E");
   E350 : Short_Integer; pragma Import (Ada, E350, "globe_3d__software_anti_aliasing_E");
   E255 : Short_Integer; pragma Import (Ada, E255, "globe_3d__textures_E");
   E344 : Short_Integer; pragma Import (Ada, E344, "glut__windows_E");
   E301 : Short_Integer; pragma Import (Ada, E301, "graphics_structures_E");
   E157 : Short_Integer; pragma Import (Ada, E157, "graphics_configuration_E");
   E323 : Short_Integer; pragma Import (Ada, E323, "spaceship_p_E");
   E325 : Short_Integer; pragma Import (Ada, E325, "sphere_p_E");
   E359 : Short_Integer; pragma Import (Ada, E359, "swarm_structures_base_E");
   E358 : Short_Integer; pragma Import (Ada, E358, "swarm_configurations_E");
   E262 : Short_Integer; pragma Import (Ada, E262, "unzip_E");
   E280 : Short_Integer; pragma Import (Ada, E280, "unzip__streams_E");
   E383 : Short_Integer; pragma Import (Ada, E383, "vehicle_interface_E");
   E278 : Short_Integer; pragma Import (Ada, E278, "zip__crc_E");
   E272 : Short_Integer; pragma Import (Ada, E272, "zip__headers_E");
   E264 : Short_Integer; pragma Import (Ada, E264, "unzip__decompress_E");
   E268 : Short_Integer; pragma Import (Ada, E268, "unzip__decompress__huffman_E");
   E321 : Short_Integer; pragma Import (Ada, E321, "models_E");
   E319 : Short_Integer; pragma Import (Ada, E319, "graphics_data_E");
   E328 : Short_Integer; pragma Import (Ada, E328, "graphics_opengl_E");
   E356 : Short_Integer; pragma Import (Ada, E356, "swarm_configuration_E");
   E372 : Short_Integer; pragma Import (Ada, E372, "swarm_structures_E");
   E370 : Short_Integer; pragma Import (Ada, E370, "swarm_data_E");
   E369 : Short_Integer; pragma Import (Ada, E369, "swarm_control_E");
   E043 : Short_Integer; pragma Import (Ada, E043, "callback_procedures_E");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E383 := E383 - 1;
      E369 := E369 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "swarm_control__finalize_spec");
      begin
         F1;
      end;
      declare
         procedure F2;
         pragma Import (Ada, F2, "swarm_data__finalize_spec");
      begin
         E370 := E370 - 1;
         F2;
      end;
      E372 := E372 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "swarm_structures__finalize_spec");
      begin
         F3;
      end;
      E280 := E280 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "vehicle_interface__finalize_spec");
      begin
         F4;
      end;
      declare
         procedure F5;
         pragma Import (Ada, F5, "globe_3d__textures__finalize_body");
      begin
         E255 := E255 - 1;
         F5;
      end;
      declare
         procedure F6;
         pragma Import (Ada, F6, "unzip__streams__finalize_spec");
      begin
         F6;
      end;
      declare
         procedure F7;
         pragma Import (Ada, F7, "swarm_structures_base__finalize_spec");
      begin
         E359 := E359 - 1;
         F7;
      end;
      declare
         procedure F8;
         pragma Import (Ada, F8, "graphics_structures__finalize_spec");
      begin
         E301 := E301 - 1;
         F8;
      end;
      E344 := E344 - 1;
      declare
         procedure F9;
         pragma Import (Ada, F9, "glut__windows__finalize_spec");
      begin
         F9;
      end;
      E162 := E162 - 1;
      declare
         procedure F10;
         pragma Import (Ada, F10, "globe_3d__finalize_spec");
      begin
         F10;
      end;
      E274 := E274 - 1;
      declare
         procedure F11;
         pragma Import (Ada, F11, "zip_streams__finalize_spec");
      begin
         F11;
      end;
      declare
         procedure F12;
         pragma Import (Ada, F12, "glut__finalize_body");
      begin
         E294 := E294 - 1;
         F12;
      end;
      E185 := E185 - 1;
      declare
         procedure F13;
         pragma Import (Ada, F13, "gl__skins__finalize_spec");
      begin
         F13;
      end;
      E237 := E237 - 1;
      declare
         procedure F14;
         pragma Import (Ada, F14, "gl__textures__finalize_spec");
      begin
         F14;
      end;
      E206 := E206 - 1;
      declare
         procedure F15;
         pragma Import (Ada, F15, "gl__geometry__finalize_spec");
      begin
         F15;
      end;
      E198 := E198 - 1;
      declare
         procedure F16;
         pragma Import (Ada, F16, "gl__buffer__finalize_spec");
      begin
         F16;
      end;
      E374 := E374 - 1;
      declare
         procedure F17;
         pragma Import (Ada, F17, "barrier_type__finalize_spec");
      begin
         F17;
      end;
      E121 := E121 - 1;
      declare
         procedure F18;
         pragma Import (Ada, F18, "system__tasking__protected_objects__entries__finalize_spec");
      begin
         F18;
      end;
      E134 := E134 - 1;
      declare
         procedure F19;
         pragma Import (Ada, F19, "ada__text_io__finalize_spec");
      begin
         F19;
      end;
      E208 := E208 - 1;
      declare
         procedure F20;
         pragma Import (Ada, F20, "ada__strings__unbounded__finalize_spec");
      begin
         F20;
      end;
      declare
         procedure F21;
         pragma Import (Ada, F21, "system__file_io__finalize_body");
      begin
         E138 := E138 - 1;
         F21;
      end;
      E192 := E192 - 1;
      E190 := E190 - 1;
      E233 := E233 - 1;
      declare
         procedure F22;
         pragma Import (Ada, F22, "system__pool_global__finalize_spec");
      begin
         F22;
      end;
      declare
         procedure F23;
         pragma Import (Ada, F23, "system__storage_pools__subpools__finalize_spec");
      begin
         F23;
      end;
      declare
         procedure F24;
         pragma Import (Ada, F24, "system__finalization_masters__finalize_spec");
      begin
         F24;
      end;
      E243 := E243 - 1;
      declare
         procedure F25;
         pragma Import (Ada, F25, "ada__streams__stream_io__finalize_spec");
      begin
         F25;
      end;
      declare
         procedure Reraise_Library_Exception_If_Any;
            pragma Import (Ada, Reraise_Library_Exception_If_Any, "__gnat_reraise_library_exception_if_any");
      begin
         Reraise_Library_Exception_If_Any;
      end;
   end finalize_library;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (C, s_stalib_adafinal, "system__standard_library__adafinal");

      procedure Runtime_Finalize;
      pragma Import (C, Runtime_Finalize, "__gnat_runtime_finalize");

   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      Runtime_Finalize;
      s_stalib_adafinal;
   end adafinal;

   type No_Param_Proc is access procedure;

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Exception_Tracebacks : Integer;
      pragma Import (C, Exception_Tracebacks, "__gl_exception_tracebacks");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Leap_Seconds_Support : Integer;
      pragma Import (C, Leap_Seconds_Support, "__gl_leap_seconds_support");

      procedure Runtime_Initialize (Install_Handler : Integer);
      pragma Import (C, Runtime_Initialize, "__gnat_runtime_initialize");

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := 'b';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      System.Restrictions.Run_Time_Restrictions :=
        (Set =>
          (False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           True, False, False, False, False, False, False, False, 
           False, False, False, False, False, False),
         Value => (0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
         Violated =>
          (True, False, False, True, True, False, False, True, 
           False, False, True, True, True, True, False, False, 
           True, False, False, True, True, False, True, True, 
           False, True, True, True, True, False, True, True, 
           False, True, False, True, True, False, True, True, 
           True, True, False, True, True, True, True, False, 
           False, True, False, True, True, False, False, False, 
           True, True, True, True, True, False, False, True, 
           False, False, True, False, True, True, False, True, 
           True, True, False, True, False, False, False, True, 
           True, True, True, True, True, False),
         Count => (0, 0, 0, 1, 2, 1, 3, 2, 7, 0),
         Unknown => (False, False, False, False, False, False, True, True, True, False));
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Exception_Tracebacks := 1;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;
      Leap_Seconds_Support := 0;

      Runtime_Initialize (1);

      Finalize_Library_Objects := finalize_library'access;

      System.Soft_Links'Elab_Spec;
      System.Fat_Flt'Elab_Spec;
      E186 := E186 + 1;
      System.Fat_Lflt'Elab_Spec;
      E156 := E156 + 1;
      System.Fat_Llf'Elab_Spec;
      E150 := E150 + 1;
      System.Exception_Table'Elab_Body;
      E021 := E021 + 1;
      Ada.Containers'Elab_Spec;
      E173 := E173 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E128 := E128 + 1;
      Ada.Numerics'Elab_Spec;
      E147 := E147 + 1;
      Ada.Strings'Elab_Spec;
      E167 := E167 + 1;
      Ada.Strings.Maps'Elab_Spec;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E172 := E172 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Streams'Elab_Spec;
      E127 := E127 + 1;
      Interfaces.C'Elab_Spec;
      Interfaces.C.Strings'Elab_Spec;
      System.Exceptions'Elab_Spec;
      E023 := E023 + 1;
      System.File_Control_Block'Elab_Spec;
      E143 := E143 + 1;
      Ada.Streams.Stream_Io'Elab_Spec;
      E243 := E243 + 1;
      System.Finalization_Root'Elab_Spec;
      E130 := E130 + 1;
      Ada.Finalization'Elab_Spec;
      E125 := E125 + 1;
      System.Storage_Pools'Elab_Spec;
      E188 := E188 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Storage_Pools.Subpools'Elab_Spec;
      System.Task_Info'Elab_Spec;
      E071 := E071 + 1;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E276 := E276 + 1;
      Ada.Calendar.Delays'Elab_Body;
      E300 := E300 + 1;
      System.Assertions'Elab_Spec;
      E153 := E153 + 1;
      System.Pool_Global'Elab_Spec;
      E233 := E233 + 1;
      System.Random_Seed'Elab_Body;
      E334 := E334 + 1;
      E190 := E190 + 1;
      System.Finalization_Masters'Elab_Body;
      E192 := E192 + 1;
      System.File_Io'Elab_Body;
      E138 := E138 + 1;
      E055 := E055 + 1;
      E053 := E053 + 1;
      Ada.Tags'Elab_Body;
      E087 := E087 + 1;
      E169 := E169 + 1;
      System.Soft_Links'Elab_Body;
      E011 := E011 + 1;
      System.Os_Lib'Elab_Body;
      E140 := E140 + 1;
      System.Secondary_Stack'Elab_Body;
      E015 := E015 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E208 := E208 + 1;
      System.Strings.Stream_Ops'Elab_Body;
      E241 := E241 + 1;
      System.Tasking.Initialization'Elab_Body;
      E107 := E107 + 1;
      Ada.Real_Time'Elab_Spec;
      Ada.Real_Time'Elab_Body;
      E045 := E045 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E134 := E134 + 1;
      System.Tasking.Protected_Objects'Elab_Body;
      E117 := E117 + 1;
      System.Tasking.Protected_Objects.Entries'Elab_Spec;
      E121 := E121 + 1;
      System.Tasking.Queuing'Elab_Body;
      E115 := E115 + 1;
      System.Tasking.Stages'Elab_Body;
      E381 := E381 + 1;
      System.Tasking.Async_Delays'Elab_Body;
      E385 := E385 + 1;
      Barrier_Type'Elab_Spec;
      E374 := E374 + 1;
      E266 := E266 + 1;
      E099 := E099 + 1;
      E361 := E361 + 1;
      GL.BUFFER'ELAB_SPEC;
      E198 := E198 + 1;
      GL.ERRORS'ELAB_SPEC;
      E159 := E159 + 1;
      GL.GEOMETRY'ELAB_SPEC;
      E288 := E288 + 1;
      GL.IO'ELAB_SPEC;
      GL.IO'ELAB_BODY;
      E239 := E239 + 1;
      E247 := E247 + 1;
      GL.MATH'ELAB_SPEC;
      GL.MATH'ELAB_BODY;
      E216 := E216 + 1;
      GL.GEOMETRY'ELAB_BODY;
      E206 := E206 + 1;
      GL.TEXTURES'ELAB_SPEC;
      GL.TEXTURES'ELAB_BODY;
      E237 := E237 + 1;
      E181 := E181 + 1;
      E179 := E179 + 1;
      GL.BUFFER.TEXTURE_COORDS'ELAB_SPEC;
      E202 := E202 + 1;
      GL.SKINS'ELAB_SPEC;
      E185 := E185 + 1;
      E290 := E290 + 1;
      GLUT'ELAB_BODY;
      E294 := E294 + 1;
      GLUT.DEVICES'ELAB_SPEC;
      Game_Control'Elab_Spec;
      E348 := E348 + 1;
      E292 := E292 + 1;
      Keyboard'Elab_Spec;
      E352 := E352 + 1;
      Real_Type'Elab_Spec;
      E146 := E146 + 1;
      E145 := E145 + 1;
      Graphics_Framerates'Elab_Body;
      E298 := E298 + 1;
      E305 := E305 + 1;
      Quaternions'Elab_Body;
      E307 := E307 + 1;
      E354 := E354 + 1;
      Vectors_2d'Elab_Spec;
      E392 := E392 + 1;
      Vectors_3d'Elab_Spec;
      E309 := E309 + 1;
      Rotations'Elab_Spec;
      E303 := E303 + 1;
      Vectors_3d_Lf'Elab_Spec;
      E389 := E389 + 1;
      Vectors_4d'Elab_Spec;
      E326 := E326 + 1;
      Vectors_2d_I'Elab_Spec;
      E393 := E393 + 1;
      Vectors_2d_N'Elab_Spec;
      E316 := E316 + 1;
      Vectors_2d_P'Elab_Spec;
      E394 := E394 + 1;
      E391 := E391 + 1;
      Zip_Streams'Elab_Spec;
      Zip'Elab_Spec;
      E274 := E274 + 1;
      GLOBE_3D'ELAB_SPEC;
      GLOBE_3D.MATH'ELAB_BODY;
      E249 := E249 + 1;
      Actors'Elab_Body;
      E346 := E346 + 1;
      E251 := E251 + 1;
      E253 := E253 + 1;
      E350 := E350 + 1;
      GLOBE_3D.TEXTURES'ELAB_SPEC;
      GLOBE_3D'ELAB_BODY;
      E162 := E162 + 1;
      GLUT.WINDOWS'ELAB_SPEC;
      GLUT.WINDOWS'ELAB_BODY;
      E344 := E344 + 1;
      E342 := E342 + 1;
      Graphics_Structures'Elab_Spec;
      E301 := E301 + 1;
      Graphics_Configuration'Elab_Spec;
      E157 := E157 + 1;
      E323 := E323 + 1;
      E325 := E325 + 1;
      Swarm_Structures_Base'Elab_Spec;
      E359 := E359 + 1;
      Swarm_Configurations'Elab_Spec;
      E358 := E358 + 1;
      Unzip'Elab_Spec;
      Unzip.Streams'Elab_Spec;
      GLOBE_3D.TEXTURES'ELAB_BODY;
      E255 := E255 + 1;
      Vehicle_Interface'Elab_Spec;
      E278 := E278 + 1;
      Zip.Headers'Elab_Spec;
      Zip.Headers'Elab_Body;
      E272 := E272 + 1;
      E270 := E270 + 1;
      E280 := E280 + 1;
      E262 := E262 + 1;
      Unzip.Decompress.Huffman'Elab_Spec;
      E268 := E268 + 1;
      E264 := E264 + 1;
      Models'Elab_Spec;
      Models'Elab_Body;
      E321 := E321 + 1;
      Graphics_Data'Elab_Spec;
      E319 := E319 + 1;
      E338 := E338 + 1;
      Graphics_Opengl'Elab_Body;
      E328 := E328 + 1;
      Swarm_Configuration'Elab_Spec;
      E356 := E356 + 1;
      Swarm_Structures'Elab_Spec;
      E372 := E372 + 1;
      Vehicle_Task_Type'Elab_Body;
      E379 := E379 + 1;
      Swarm_Data'Elab_Spec;
      E370 := E370 + 1;
      Swarm_Control'Elab_Spec;
      E369 := E369 + 1;
      E383 := E383 + 1;
      E396 := E396 + 1;
      Callback_Procedures'Elab_Body;
      E043 := E043 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_swarm");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer
   is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      gnat_argc := argc;
      gnat_argv := argv;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\barrier_type.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\bzip2.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\exceptions.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\generic_protected.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\generic_realtime_buffer.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\gl-buffer.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\gl-buffer-general.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\gl-extended.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\gl.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\gl-frustums.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\gl-io.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\gl-materials.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\gl-math.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\gl-geometry.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\gl-textures.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\glu.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\gl-errors.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\gl-buffer-texture_coords.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\gl-skins.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\gl-skinned_geometry.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\glut.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\game_control.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\glut_2d.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\keyboard.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\real_type.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\generic_sliding_statistics.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\graphics_framerates.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\matrices.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\quaternions.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\screenshots.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\vectors_xd.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\vectors_2d.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\vectors_3d.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\rotations.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\vectors_3d_lf.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\vectors_4d.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\vectors_xd_i.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\vectors_2d_i.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\vectors_2d_n.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\vectors_2d_p.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\vectors_conversions.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\vehicle_message_type.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\zip_streams.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\globe_3d-math.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\actors.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\globe_3d-options.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\globe_3d-portals.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\globe_3d-software_anti_aliasing.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\globe_3d.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\glut-windows.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\glut-devices.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\graphics_structures.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\graphics_configuration.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\spaceship_p.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\sphere_p.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\swarm_structures_base.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\swarm_configurations.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\globe_3d-textures.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\zip-crc.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\zip-headers.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\zip.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\unzip-streams.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\unzip.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\unzip-decompress-huffman.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\unzip-decompress.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\globe_3d-stars_sky.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\models.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\graphics_data.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\graphics_setup.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\graphics_opengl.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\swarm_configuration.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\swarm_structures.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\vehicle_task_type.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\swarm_data.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\swarm_control.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\vehicle_interface.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\swarm_control_concurrent_generic.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\callback_procedures.o
   --   C:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\swarm.o
   --   -LC:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\
   --   -LC:\Users\Zhuoqi QIU\Desktop\COMP2310\assignment\Assignment_1_2015\Build\for_development\
   --   -LC:/gnat/2015/lib/gcc/i686-pc-mingw32/4.9.3/adalib/
   --   -static
   --   -lgnarl
   --   -lgnat
   --   -Xlinker
   --   --stack=0x200000,0x1000
   --   -mthreads
   --   -Wl,--stack=0x2000000
--  END Object file/option list   

end ada_main;
