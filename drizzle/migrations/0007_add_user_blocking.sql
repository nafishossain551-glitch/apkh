ALTER TABLE public.profiles ADD COLUMN blocked_at timestamptz;

CREATE OR REPLACE FUNCTION public.is_blocked(_user_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = _user_id AND blocked_at IS NOT NULL
  )
$$;

-- Blocked users are denied access to all their data tables (restrictive policies AND with existing ones).
CREATE POLICY blocked_deny ON public.conversations AS RESTRICTIVE FOR ALL TO authenticated USING (NOT public.is_blocked(auth.uid()));
CREATE POLICY blocked_deny ON public.messages AS RESTRICTIVE FOR ALL TO authenticated USING (NOT public.is_blocked(auth.uid()));
CREATE POLICY blocked_deny ON public.medicines AS RESTRICTIVE FOR ALL TO authenticated USING (NOT public.is_blocked(auth.uid()));
CREATE POLICY blocked_deny ON public.medicine_events AS RESTRICTIVE FOR ALL TO authenticated USING (NOT public.is_blocked(auth.uid()));
CREATE POLICY blocked_deny ON public.health_notes AS RESTRICTIVE FOR ALL TO authenticated USING (NOT public.is_blocked(auth.uid()));
CREATE POLICY blocked_deny ON public.symptom_sessions AS RESTRICTIVE FOR ALL TO authenticated USING (NOT public.is_blocked(auth.uid()));
CREATE POLICY blocked_deny ON public.symptom_answers AS RESTRICTIVE FOR ALL TO authenticated USING (NOT public.is_blocked(auth.uid()));
CREATE POLICY blocked_deny ON public.feedback AS RESTRICTIVE FOR ALL TO authenticated USING (NOT public.is_blocked(auth.uid()));
CREATE POLICY blocked_deny ON public.notification_devices AS RESTRICTIVE FOR ALL TO authenticated USING (NOT public.is_blocked(auth.uid()));
CREATE POLICY blocked_deny ON public.reminder_sends AS RESTRICTIVE FOR ALL TO authenticated USING (NOT public.is_blocked(auth.uid()));

-- Admins can read blocked status and set/clear it.
CREATE POLICY "Admins can update profiles" ON public.profiles FOR UPDATE TO authenticated
  USING (public.has_role(auth.uid(), 'admin'))
  WITH CHECK (public.has_role(auth.uid(), 'admin'));