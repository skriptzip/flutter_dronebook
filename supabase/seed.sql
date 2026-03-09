-- Supabase seed file for DroneBook local development
-- This file contains sample data for development
-- Schema is declared in supabase/schemas/

-- Create a test user (password: testpassword123)
INSERT INTO auth.users (
    id,
    instance_id,
    email,
    encrypted_password,
    email_confirmed_at,
    created_at,
    updated_at,
    raw_app_meta_data,
    raw_user_meta_data,
    is_super_admin,
    role,
    aud
) VALUES (
    '00000000-0000-0000-0000-000000000001'::uuid,
    '00000000-0000-0000-0000-000000000000'::uuid,
    'test@example.com',
    '$2a$10$rHzXbVDLzGzxR8Y0qF5N2ulMHgYBHLpGFTjV3fBhN0k8TQ6xL8eOO', -- bcrypt hash for 'testpassword123'
    NOW(),
    NOW(),
    NOW(),
    '{"provider":"email","providers":["email"]}'::jsonb,
    '{"name":"Test Pilot"}'::jsonb,
    false,
    'authenticated',
    'authenticated'
) ON CONFLICT (id) DO NOTHING;

-- Insert sample drone flight logs
INSERT INTO public.drone_flight_logs (
    id,
    user_id,
    title,
    drone_name,
    drone_model,
    start_latitude,
    start_longitude,
    address,
    end_latitude,
    end_longitude,
    start_time,
    end_time,
    max_altitude,
    flight_duration,
    flight_radius,
    notes,
    weather_conditions,
    wind_speed,
    pilot_name
) VALUES 
(
    uuid_generate_v4(),
    '00000000-0000-0000-0000-000000000001'::uuid,
    'Morning Test Flight',
    'DJI Mavic',
    'DJI Mavic 3 Pro',
    52.520008,
    13.404954,
    'Alexanderplatz, Berlin, Germany',
    52.521008,
    13.405954,
    NOW() - INTERVAL '2 days',
    NOW() - INTERVAL '2 days' + INTERVAL '15 minutes',
    120.5,
    15.0,
    250.0,
    'Clear weather, excellent visibility. First test flight in this area.',
    ARRAY['Clear', 'Sunny'],
    12.5,
    'Test Pilot'
),
(
    uuid_generate_v4(),
    '00000000-0000-0000-0000-000000000001'::uuid,
    'Park Photography Session',
    'DJI Mini',
    'DJI Mini 3 Pro',
    48.858844,
    2.294351,
    'Champ de Mars, Paris, France',
    48.859844,
    2.295351,
    NOW() - INTERVAL '5 days',
    NOW() - INTERVAL '5 days' + INTERVAL '28 minutes',
    95.0,
    28.0,
    180.0,
    'Beautiful sunset photography. Got some amazing shots of the park.',
    ARRAY['Partly Cloudy', 'Warm'],
    8.0,
    'Test Pilot'
),
(
    uuid_generate_v4(),
    '00000000-0000-0000-0000-000000000001'::uuid,
    'Coastal Survey',
    'Autel Evo',
    'Autel Evo II Pro',
    51.507351,
    -0.127758,
    'Westminster, London, UK',
    NULL,
    NULL,
    NOW() - INTERVAL '1 week',
    NOW() - INTERVAL '1 week' + INTERVAL '42 minutes',
    150.0,
    42.0,
    500.0,
    'Mapped the coastline for documentation purposes. Strong winds made it challenging.',
    ARRAY['Windy', 'Overcast'],
    25.0,
    'Test Pilot'
);
