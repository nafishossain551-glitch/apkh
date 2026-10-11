# Chat viewport fix

## What changed
- `src/styles.css`: constrain chat to a two-row grid with a shrinkable, scrollable welcome/transcript row and a content-sized composer row.
- Remove upward transforms from welcome content so its first lines remain reachable.
- Keep the top bar from shrinking, and cap growing input height relative to the viewport.
- Preserve the existing bounded shell and independently scrolling conversation history.
- `AGENTS.md`: document the layout invariant.
- `tests/chat-layout-regression.py`: repeatable isolated browser layout regression.

## Checks performed
- Browser layout fixture using the actual app stylesheet: 1280×900, 1920×1080, 390×844, 390×568, 844×390, 390×390.
- Welcome content, long transcript, scrolled conversation history, focused input, and expanded multiline input remain within the viewport.
- 13 existing health-rules tests passed; updated CSS parses with Lightning CSS.

## Limitations
The browser regression is an isolated layout fixture, not the signed-in running app. Live sign-in, real AI responses, and physical phone keyboard behavior were not tested. No backend logic, connections, or credentials were changed.

The clean source archive excludes `.env`, Git metadata, dependencies and generated output. Keep your original environment configuration when applying this fix. For an existing app, replace only `src/styles.css`; the notes and regression test are optional additions.

## Repeat the layout check
With Python Playwright installed and Chromium available, run:
`python3 tests/chat-layout-regression.py`
The script writes temporary fixtures and screenshots outside the source folder.
