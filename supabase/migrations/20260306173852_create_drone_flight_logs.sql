
  create table "public"."drone_flight_logs" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "user_id" uuid,
    "title" text not null,
    "drone_name" text not null,
    "drone_model" text not null,
    "start_latitude" double precision not null,
    "start_longitude" double precision not null,
    "address" text,
    "end_latitude" double precision,
    "end_longitude" double precision,
    "start_time" timestamp with time zone not null,
    "end_time" timestamp with time zone,
    "max_altitude" double precision,
    "flight_duration" double precision,
    "flight_radius" double precision,
    "notes" text,
    "weather_conditions" text[],
    "wind_speed" double precision,
    "pilot_name" text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."drone_flight_logs" enable row level security;

CREATE UNIQUE INDEX drone_flight_logs_pkey ON public.drone_flight_logs USING btree (id);

CREATE INDEX idx_drone_flight_logs_start_time ON public.drone_flight_logs USING btree (start_time DESC);

CREATE INDEX idx_drone_flight_logs_user_id ON public.drone_flight_logs USING btree (user_id);

alter table "public"."drone_flight_logs" add constraint "drone_flight_logs_pkey" PRIMARY KEY using index "drone_flight_logs_pkey";

alter table "public"."drone_flight_logs" add constraint "drone_flight_logs_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."drone_flight_logs" validate constraint "drone_flight_logs_user_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.update_updated_at_column()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$
;

grant delete on table "public"."drone_flight_logs" to "anon";

grant insert on table "public"."drone_flight_logs" to "anon";

grant references on table "public"."drone_flight_logs" to "anon";

grant select on table "public"."drone_flight_logs" to "anon";

grant trigger on table "public"."drone_flight_logs" to "anon";

grant truncate on table "public"."drone_flight_logs" to "anon";

grant update on table "public"."drone_flight_logs" to "anon";

grant delete on table "public"."drone_flight_logs" to "authenticated";

grant insert on table "public"."drone_flight_logs" to "authenticated";

grant references on table "public"."drone_flight_logs" to "authenticated";

grant select on table "public"."drone_flight_logs" to "authenticated";

grant trigger on table "public"."drone_flight_logs" to "authenticated";

grant truncate on table "public"."drone_flight_logs" to "authenticated";

grant update on table "public"."drone_flight_logs" to "authenticated";

grant delete on table "public"."drone_flight_logs" to "service_role";

grant insert on table "public"."drone_flight_logs" to "service_role";

grant references on table "public"."drone_flight_logs" to "service_role";

grant select on table "public"."drone_flight_logs" to "service_role";

grant trigger on table "public"."drone_flight_logs" to "service_role";

grant truncate on table "public"."drone_flight_logs" to "service_role";

grant update on table "public"."drone_flight_logs" to "service_role";


  create policy "Users can delete their own flight logs"
  on "public"."drone_flight_logs"
  as permissive
  for delete
  to public
using ((auth.uid() = user_id));



  create policy "Users can insert their own flight logs"
  on "public"."drone_flight_logs"
  as permissive
  for insert
  to public
with check ((auth.uid() = user_id));



  create policy "Users can update their own flight logs"
  on "public"."drone_flight_logs"
  as permissive
  for update
  to public
using ((auth.uid() = user_id));



  create policy "Users can view their own flight logs"
  on "public"."drone_flight_logs"
  as permissive
  for select
  to public
using ((auth.uid() = user_id));


CREATE TRIGGER update_drone_flight_logs_updated_at BEFORE UPDATE ON public.drone_flight_logs FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


