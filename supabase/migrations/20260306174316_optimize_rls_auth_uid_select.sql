drop trigger if exists "update_drone_flight_logs_updated_at" on "public"."drone_flight_logs";

drop policy "Users can delete their own flight logs" on "public"."drone_flight_logs";

drop policy "Users can insert their own flight logs" on "public"."drone_flight_logs";

drop policy "Users can update their own flight logs" on "public"."drone_flight_logs";

drop policy "Users can view their own flight logs" on "public"."drone_flight_logs";

drop function if exists "public"."update_updated_at_column"();

drop index if exists "public"."idx_drone_flight_logs_start_time";

drop index if exists "public"."idx_drone_flight_logs_user_id";


  create policy "Users can delete their own flight logs"
  on "public"."drone_flight_logs"
  as permissive
  for delete
  to public
using ((( SELECT auth.uid() AS uid) = user_id));



  create policy "Users can insert their own flight logs"
  on "public"."drone_flight_logs"
  as permissive
  for insert
  to public
with check ((( SELECT auth.uid() AS uid) = user_id));



  create policy "Users can update their own flight logs"
  on "public"."drone_flight_logs"
  as permissive
  for update
  to public
using ((( SELECT auth.uid() AS uid) = user_id));



  create policy "Users can view their own flight logs"
  on "public"."drone_flight_logs"
  as permissive
  for select
  to public
using ((( SELECT auth.uid() AS uid) = user_id));



