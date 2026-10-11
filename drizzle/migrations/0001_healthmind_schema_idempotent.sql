DO $$ BEGIN CREATE TYPE public.app_role AS ENUM ('admin','user'); EXCEPTION WHEN duplicate_object THEN NULL; END $$;

CREATE TABLE IF NOT EXISTS public.user_roles (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE, role public.app_role NOT NULL, created_at timestamptz NOT NULL DEFAULT now(), UNIQUE(user_id, role));
CREATE OR REPLACE FUNCTION public.has_role(_user_id uuid, _role public.app_role) RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$ SELECT EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = _user_id AND role = _role) $$;

CREATE TABLE IF NOT EXISTS public.profiles (id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE, display_name text NOT NULL DEFAULT '', email text, language text NOT NULL DEFAULT 'en', appearance text NOT NULL DEFAULT 'system', reminders boolean NOT NULL DEFAULT true, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS public.conversations (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), user_id uuid NOT NULL, title text NOT NULL DEFAULT 'New conversation', risk_level text, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS public.messages (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), conversation_id uuid NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE, user_id uuid NOT NULL, role text NOT NULL, content text NOT NULL, metadata jsonb NOT NULL DEFAULT '{}', model text, risk_level text, created_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS public.feedback (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), message_id uuid NOT NULL REFERENCES public.messages(id) ON DELETE CASCADE, user_id uuid NOT NULL, rating text NOT NULL, comment text, created_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS public.health_notes (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), user_id uuid NOT NULL, title text NOT NULL DEFAULT '', content text NOT NULL, note_date date NOT NULL DEFAULT current_date, created_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS public.medicines (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), user_id uuid NOT NULL, name text NOT NULL, dose text NOT NULL DEFAULT '', frequency text NOT NULL DEFAULT 'daily', times text[] NOT NULL DEFAULT '{}', food_timing text NOT NULL DEFAULT '', notes text NOT NULL DEFAULT '', start_date date NOT NULL DEFAULT current_date, end_date date, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS public.medicine_events (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), user_id uuid NOT NULL, medicine_id uuid NOT NULL REFERENCES public.medicines(id) ON DELETE CASCADE, scheduled_date date NOT NULL, scheduled_time text NOT NULL, status text NOT NULL, acted_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS public.symptom_sessions (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), user_id uuid NOT NULL, chief_complaint text NOT NULL DEFAULT '', language text NOT NULL DEFAULT 'en', status text NOT NULL DEFAULT 'in_progress', risk_level text, result jsonb, session_date date NOT NULL DEFAULT current_date, completed_at timestamptz, created_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS public.symptom_answers (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), session_id uuid NOT NULL REFERENCES public.symptom_sessions(id) ON DELETE CASCADE, user_id uuid NOT NULL, position int NOT NULL, question text NOT NULL, answer text NOT NULL, created_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS public.notification_devices (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), user_id uuid NOT NULL, platform text NOT NULL, token text NOT NULL, created_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS public.ai_settings (id int PRIMARY KEY DEFAULT 1, model text NOT NULL DEFAULT 'google/gemini-3.1-flash-lite', fallback_model text NOT NULL DEFAULT 'google/gemini-3.8-flash', temperature numeric, max_output_tokens int NOT NULL DEFAULT 2000, system_prompt text NOT NULL DEFAULT '', chat_enabled boolean NOT NULL DEFAULT true, symptom_checker_enabled boolean NOT NULL DEFAULT true, knowledge_retrieval_enabled boolean NOT NULL DEFAULT true, daily_limit int NOT NULL DEFAULT 100, per_minute_limit int NOT NULL DEFAULT 10, updated_at timestamptz NOT NULL DEFAULT now(), updated_by uuid);
INSERT INTO public.ai_settings (id) VALUES (1) ON CONFLICT DO NOTHING;
CREATE TABLE IF NOT EXISTS public.ai_rules (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), name text NOT NULL, description text NOT NULL DEFAULT '', category text NOT NULL DEFAULT 'general', instruction text NOT NULL, enabled boolean NOT NULL DEFAULT true, priority int NOT NULL DEFAULT 0, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS public.response_rules (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), name text NOT NULL, condition_type text NOT NULL, condition_value text NOT NULL DEFAULT '', action text NOT NULL, enabled boolean NOT NULL DEFAULT true, priority int NOT NULL DEFAULT 0, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS public.safety_rules (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), name text NOT NULL, keywords text NOT NULL, guidance text NOT NULL DEFAULT '', risk_level text NOT NULL DEFAULT 'urgent', enabled boolean NOT NULL DEFAULT true, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS public.knowledge_documents (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), title text NOT NULL, content text NOT NULL, category text NOT NULL DEFAULT 'general', topic text NOT NULL DEFAULT '', keywords text NOT NULL DEFAULT '', language text NOT NULL DEFAULT 'en', source text NOT NULL DEFAULT '', source_url text NOT NULL DEFAULT '', status text NOT NULL DEFAULT 'draft', review_date date, search tsvector GENERATED ALWAYS AS (to_tsvector('simple', coalesce(title,'')||' '||coalesce(keywords,'')||' '||coalesce(content,''))) STORED, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now());
CREATE INDEX IF NOT EXISTS knowledge_documents_search_idx ON public.knowledge_documents USING gin(search);
CREATE TABLE IF NOT EXISTS public.medicine_knowledge (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), generic_name text NOT NULL, brand_names text NOT NULL DEFAULT '', active_ingredient text NOT NULL DEFAULT '', classification text NOT NULL DEFAULT '', dosage_form text NOT NULL DEFAULT '', strength text NOT NULL DEFAULT '', common_uses text NOT NULL DEFAULT '', side_effects text NOT NULL DEFAULT '', warnings text NOT NULL DEFAULT '', contraindications text NOT NULL DEFAULT '', interactions text NOT NULL DEFAULT '', pregnancy_lactation text NOT NULL DEFAULT '', age_considerations text NOT NULL DEFAULT '', source text NOT NULL DEFAULT '', source_url text NOT NULL DEFAULT '', status text NOT NULL DEFAULT 'draft', last_reviewed date, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS public.ai_usage_logs (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), user_id uuid, feature text NOT NULL, provider text NOT NULL, model text NOT NULL, status text NOT NULL, input_tokens int, output_tokens int, latency_ms int, estimated_cost numeric, error_code text, created_at timestamptz NOT NULL DEFAULT now());
CREATE TABLE IF NOT EXISTS public.admin_logs (id uuid PRIMARY KEY DEFAULT gen_random_uuid(), admin_id uuid NOT NULL, action text NOT NULL, target_type text NOT NULL DEFAULT '', target_id text, details jsonb NOT NULL DEFAULT '{}', created_at timestamptz NOT NULL DEFAULT now());

GRANT SELECT ON public.user_roles TO authenticated;
GRANT SELECT, INSERT ON public.ai_usage_logs, public.admin_logs TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.profiles, public.conversations, public.messages, public.feedback, public.health_notes, public.medicines, public.medicine_events, public.symptom_sessions, public.symptom_answers, public.notification_devices, public.ai_settings, public.ai_rules, public.response_rules, public.safety_rules, public.knowledge_documents, public.medicine_knowledge TO authenticated;
GRANT ALL ON public.user_roles, public.profiles, public.conversations, public.messages, public.feedback, public.health_notes, public.medicines, public.medicine_events, public.symptom_sessions, public.symptom_answers, public.notification_devices, public.ai_settings, public.ai_rules, public.response_rules, public.safety_rules, public.knowledge_documents, public.medicine_knowledge, public.ai_usage_logs, public.admin_logs TO service_role;

DO $$ DECLARE t text; p record; BEGIN
  FOREACH t IN ARRAY ARRAY['user_roles','profiles','conversations','messages','feedback','health_notes','medicines','medicine_events','symptom_sessions','symptom_answers','notification_devices','ai_settings','ai_rules','response_rules','safety_rules','knowledge_documents','medicine_knowledge','ai_usage_logs','admin_logs'] LOOP
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', t);
    FOR p IN SELECT policyname FROM pg_policies WHERE schemaname='public' AND tablename=t LOOP
      EXECUTE format('DROP POLICY %I ON public.%I', p.policyname, t);
    END LOOP;
  END LOOP;
  FOREACH t IN ARRAY ARRAY['conversations','messages','feedback','health_notes','medicines','medicine_events','symptom_sessions','symptom_answers','notification_devices'] LOOP
    EXECUTE format('CREATE POLICY "own rows" ON public.%I FOR ALL TO authenticated USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid())', t);
  END LOOP;
  FOREACH t IN ARRAY ARRAY['ai_settings','ai_rules','response_rules','safety_rules','knowledge_documents','medicine_knowledge'] LOOP
    EXECUTE format('CREATE POLICY "signed-in read" ON public.%I FOR SELECT TO authenticated USING (true)', t);
    EXECUTE format('CREATE POLICY "admin write" ON public.%I FOR ALL TO authenticated USING (public.has_role(auth.uid(),''admin'')) WITH CHECK (public.has_role(auth.uid(),''admin''))', t);
  END LOOP;
END $$;

CREATE POLICY "own roles" ON public.user_roles FOR SELECT TO authenticated USING (user_id = auth.uid() OR public.has_role(auth.uid(),'admin'));
CREATE POLICY "own profile" ON public.profiles FOR ALL TO authenticated USING (id = auth.uid()) WITH CHECK (id = auth.uid());
CREATE POLICY "admin read profiles" ON public.profiles FOR SELECT TO authenticated USING (public.has_role(auth.uid(),'admin'));
CREATE POLICY "admin read feedback" ON public.feedback FOR SELECT TO authenticated USING (public.has_role(auth.uid(),'admin'));
CREATE POLICY "own usage read" ON public.ai_usage_logs FOR SELECT TO authenticated USING (user_id = auth.uid() OR public.has_role(auth.uid(),'admin'));
CREATE POLICY "own usage insert" ON public.ai_usage_logs FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());
CREATE POLICY "admin logs" ON public.admin_logs FOR ALL TO authenticated USING (public.has_role(auth.uid(),'admin')) WITH CHECK (public.has_role(auth.uid(),'admin') AND admin_id = auth.uid());

CREATE OR REPLACE FUNCTION public.search_conversations(_query text) RETURNS TABLE(id uuid, title text, updated_at timestamptz) LANGUAGE sql STABLE SECURITY INVOKER SET search_path = public AS $$
  SELECT DISTINCT c.id, c.title, c.updated_at FROM public.conversations c LEFT JOIN public.messages m ON m.conversation_id = c.id
  WHERE c.user_id = auth.uid() AND (c.title ILIKE '%'||_query||'%' OR m.content ILIKE '%'||_query||'%')
  ORDER BY c.updated_at DESC LIMIT 50 $$;

CREATE OR REPLACE FUNCTION public.handle_new_user() RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  INSERT INTO public.profiles (id, email, display_name) VALUES (NEW.id, NEW.email, COALESCE(NEW.raw_user_meta_data->>'display_name', split_part(NEW.email,'@',1), '')) ON CONFLICT (id) DO NOTHING;
  INSERT INTO public.user_roles (user_id, role) VALUES (NEW.id, 'user') ON CONFLICT DO NOTHING;
  RETURN NEW;
END $$;
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();