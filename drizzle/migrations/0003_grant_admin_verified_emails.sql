CREATE UNIQUE INDEX IF NOT EXISTS user_roles_user_role_uniq ON public.user_roles(user_id, role);
CREATE OR REPLACE FUNCTION public.grant_admin_for_listed_email()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  IF NEW.email_confirmed_at IS NOT NULL AND lower(NEW.email) IN ('nafishossain551@gmail.com','sakirulislamsiam08@gmail.com') THEN
    INSERT INTO public.user_roles(user_id, role) VALUES (NEW.id, 'admin') ON CONFLICT DO NOTHING;
  END IF;
  RETURN NEW;
END $$;
REVOKE EXECUTE ON FUNCTION public.grant_admin_for_listed_email() FROM PUBLIC, anon, authenticated;
DROP TRIGGER IF EXISTS on_auth_user_created_grant_admin ON auth.users;
CREATE TRIGGER on_auth_user_created_grant_admin AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.grant_admin_for_listed_email();
DROP TRIGGER IF EXISTS on_auth_user_confirmed_grant_admin ON auth.users;
CREATE TRIGGER on_auth_user_confirmed_grant_admin AFTER UPDATE OF email_confirmed_at ON auth.users FOR EACH ROW WHEN (OLD.email_confirmed_at IS NULL AND NEW.email_confirmed_at IS NOT NULL) EXECUTE FUNCTION public.grant_admin_for_listed_email();
INSERT INTO public.user_roles(user_id, role)
SELECT id, 'admin' FROM auth.users WHERE email_confirmed_at IS NOT NULL AND lower(email) IN ('nafishossain551@gmail.com','sakirulislamsiam08@gmail.com')
ON CONFLICT DO NOTHING;