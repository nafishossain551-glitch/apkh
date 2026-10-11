<!-- LOVABLE:BEGIN -->
> [!IMPORTANT]
> This project is connected to [Lovable](https://lovable.dev). Avoid rewriting
> published git history — force pushing, or rebasing/amending/squashing commits
> that are already pushed — as it rewrites history on Lovable's side and the
> user will likely lose their project history.
>
> Commits you push to the connected branch sync back to Lovable and show up in
> the editor, so keep the branch in a working state.
<!-- LOVABLE:END -->

## Application architecture
- All user health data lives in Lovable Cloud tables with RLS scoped to auth.uid(); the client store (src/lib/health-store.tsx) is a thin cache keyed by user id so data never leaks between accounts.
- Admin privileges come only from the separate user_roles table via has_role(); every admin server function re-checks the role server-side, and ADMIN_EMAILS (server secret) is only a bootstrap to grant the first admin.
- All AI calls run server-side through src/lib/ai/router.server.ts (primary + fallback model from admin settings, validated against the allowlist in src/lib/ai/catalog.ts); the browser never chooses a model or sees keys.
- Chat streams through the /api/chat server route (bearer token auth) so responses can stream; other app logic uses createServerFn.
- Emergency screening (src/lib/ai/safety.ts) is deterministic and runs before any AI call; built-in emergency patterns cannot be disabled by admin rules.
- Prompts are layered: core identity, safety, admin system prompt, enabled rules, matched response rules, retrieved knowledge, user context — never send the whole knowledge base.
- Dose schedules and reminders are deterministic (src/lib/schedule.ts) and never use AI.
- Use dedicated TanStack routes for health tools, chat threads and each admin section; URLs must restore the selected conversation on reload.
- Define visual roles and responsive layouts in the global design system; shared UI controls use the existing Button primitives.

- Chat uses a bounded two-row grid: only the welcome/transcript region scrolls, while the composer and header remain in the viewport; this prevents intrinsic content height from pushing input off-screen.
