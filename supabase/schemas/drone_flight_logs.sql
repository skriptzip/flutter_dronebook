-- DroneBook Schema: Drone Flight Logs
-- This file declares the desired state of the drone_flight_logs table and related objects

-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- CREATE EXTENSION IF NOT EXISTS "postgis";

-- Drone Flight Logs table
CREATE TABLE IF NOT EXISTS public.drone_flight_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    drone_name TEXT NOT NULL,
    drone_model TEXT NOT NULL,
    start_latitude DOUBLE PRECISION NOT NULL,
    start_longitude DOUBLE PRECISION NOT NULL,
    address TEXT,
    end_latitude DOUBLE PRECISION,
    end_longitude DOUBLE PRECISION,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ,
    max_altitude DOUBLE PRECISION,
    flight_duration DOUBLE PRECISION,
    flight_radius DOUBLE PRECISION,
    notes TEXT,
    weather_conditions TEXT[],
    wind_speed DOUBLE PRECISION,
    pilot_name TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- RLS
ALTER TABLE public.drone_flight_logs ENABLE ROW LEVEL SECURITY;

-- Policies for drone_flight_logs
CREATE POLICY "Users can view their own flight logs"
    ON public.drone_flight_logs FOR SELECT
    USING ((select auth.uid()) = user_id);

CREATE POLICY "Users can insert their own flight logs"
    ON public.drone_flight_logs FOR INSERT
    WITH CHECK ((select auth.uid()) = user_id);

CREATE POLICY "Users can update their own flight logs"
    ON public.drone_flight_logs FOR UPDATE
    USING ((select auth.uid()) = user_id);

CREATE POLICY "Users can delete their own flight logs"
    ON public.drone_flight_logs FOR DELETE
    USING ((select auth.uid()) = user_id);
