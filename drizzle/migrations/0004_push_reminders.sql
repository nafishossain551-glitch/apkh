ALTER TABLE public.notification_devices ADD COLUMN IF NOT EXISTS timezone text NOT NULL DEFAULT 'UTC';
CREATE UNIQUE INDEX IF NOT EXISTS notification_devices_token_uniq ON public.notification_devices(token);
CREATE TABLE IF NOT EXISTS public.reminder_sends (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  medicine_id uuid NOT NULL,
  scheduled_date date NOT NULL,
  scheduled_time text NOT NULL,
  sent_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (medicine_id, scheduled_date, scheduled_time)
);
GRANT ALL ON public.reminder_sends TO service_role;
ALTER TABLE public.reminder_sends ENABLE ROW LEVEL SECURITY;
CREATE EXTENSION IF NOT EXISTS pg_cron;
CREATE EXTENSION IF NOT EXISTS pg_net;