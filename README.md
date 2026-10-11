# HealthMind Chat

Build a very minimal, clean, modern AI health assistant web app prototype called HealthMind AI. The design must be inspired by the strongest usability patterns found across leading AI chat interfaces such as ChatGPT, Claude, Gemini, Grok, DeepSeek, Perplexity, Poe, Copilot, Mistral/Le Chat and other modern AI assistants—but do NOT copy any company's interface, branding, colors, layout, icons, or exact visual design. The goal is to combine the best usability ideas into something that feels even simpler and more natural. Research on current conversational-AI interfaces consistently shows that the strongest products favor clean chat layouts, clear navigation, restrained controls, and task-focused interaction rather than dashboard-heavy designs.



CORE DESIGN PRINCIPLE



EXTREME MINIMALISM.



Do NOT create a complicated dashboard.



Do NOT create dozens of cards.



Do NOT show health statistics, graphs, heart-rate widgets, activity panels, multiple colorful sections, or unnecessary information on the home screen.



The user should understand the interface within 3 seconds.



The primary purpose of the application is:



«Open → ask a health/medicine question → receive an answer.»



The UI should feel as simple and familiar as ChatGPT, Claude, Gemini, or DeepSeek, while having its own visual identity.



Think:



ChatGPT-level simplicity + Claude-level readability + Gemini-level useful actions + Perplexity-level source awareness + a small amount of medical-app structure.



---



1. MAIN SCREEN



The main screen should be dominated by the chat.



Desktop layout:



- Very small/simple left sidebar

- Large central chat area

- No right sidebar

- No giant dashboard

- No unnecessary cards



Left sidebar:



At the top:



HealthMind AI



Then only:



- "+ New chat"

- "Chats"

- "Medicine"

- "Health Calendar"

- "Symptom Check"



At the bottom:



- "Settings"

- small user/profile button



The sidebar should be collapsible.



When collapsed, show only icons.



Do NOT add 10–15 navigation items.



---



2. TOP BAR



Keep the top bar extremely simple.



Left:



- Current conversation title



Center/right:



- AI model selector such as:

  "HealthMind AI ▾"



Do not expose technical API/model information to normal users.



Right:



- New chat icon

- Theme icon

- Profile icon



Nothing else.



---



3. CHAT AREA



This is the most important part.



The center of the screen should look like a premium modern AI chat application.



At the beginning of a new conversation:



Large but subtle text:



How can I help with your health today?



Small supporting text:



Ask about symptoms, medicines, health information, or your treatment schedule.



Then only 3–4 small suggestion buttons, for example:



- "Check a symptom"

- "Medicine reminder"

- "Ask about a medicine"

- "Health question"



Do NOT create large colorful cards.



They should be small, clean pill/button-style suggestions.



---



4. CHAT MESSAGE DESIGN



Do NOT use giant colorful chat bubbles.



Use a clean modern conversation layout similar to premium AI assistants:



User message:



- aligned naturally to the right

- subtle background

- rounded but not excessively rounded



AI response:



- aligned left

- mostly plain text

- excellent typography

- generous spacing

- markdown support

- headings

- bullet points

- numbered steps

- tables when necessary



The AI response must feel extremely readable.



Medical information should never look visually overwhelming.



---



5. MESSAGE ACTIONS



Every AI response should have a very small action row underneath:



- Copy

- Regenerate

- Helpful

- Not helpful



These buttons should appear subtly and become more visible on hover/tap.



Make all of them functional in the prototype.



For example:



Copy → copies the response.



Regenerate → generates another mock response.



Helpful / Not helpful → changes visual state.



---



6. CHAT INPUT



The bottom composer is extremely important.



Make it similar in simplicity to the best modern AI chat interfaces.



Large rounded input container:



"Ask anything about your health..."



Inside/below it:



Left:



- "+" attachment button



Optional:



- microphone button



Center:



- small mode selector:

  "Health Mode ▾"



Right:



- Send button



The composer must remain fixed at the bottom while chatting.



Pressing Enter should send the message.



"Shift + Enter" should create a new line.



Send button must work.



---



7. HEALTH-SPECIFIC FEATURES



Do NOT turn these into a giant dashboard.



They should be secondary features accessible from the sidebar and small chat shortcuts.



Medicine



Create a simple medicine screen.



User can add:



- Medicine name

- Dose

- Frequency

- Start date

- End date

- Time



Example:



"Paracetamol 500 mg"

"08:00 AM"

"After food"

"5 days"



The prototype should allow:



- Add medicine

- Edit medicine

- Delete medicine

- Mark dose as taken

- Mark dose as missed



Use local mock data/localStorage for now.



No real backend is required yet.



---



8. MEDICINE REMINDER



Create a simple reminder interface.



Show only today's medicines.



Example:



Today



08:00 AM — Paracetamol 500 mg

02:00 PM — Medicine X

08:00 PM — Medicine Y



Each item should have:



"Taken" button



and



"Skip" button.



The UI should be extremely simple.



Do not create a complicated calendar dashboard.



---



9. HEALTH CALENDAR



Create a clean calendar page.



The calendar should show:



- Medicine schedules

- Symptom-check sessions

- Health notes



Use small dots/indicators instead of large cards.



Clicking a date should show that day's information.



The calendar must actually work in the prototype.



---



10. SYMPTOM CHECKER



This should NOT look like a generic chatbot.



When the user chooses:



Check a symptom



show a simple guided flow:



Step 1



"What are you experiencing?"



Step 2



"Where is the problem?"



Step 3



"When did it start?"



Step 4



"How severe is it?"



Step 5



"Did anything cause it?"



Step 6



"Are you experiencing any warning signs?"



Then show a simple result such as:



Low concern



or



Needs medical attention



or



Seek urgent medical care



For the prototype, use mock responses.



The actual medical AI/backend will be connected later.



---



11. SAFETY UX



Because this is a health-related application, the interface must clearly communicate that the AI provides health guidance and information, not a replacement for a doctor.



Do not put a huge scary warning everywhere.



Instead, show a small subtle disclaimer near relevant medical responses:



"HealthMind AI provides general health information and does not replace professional medical advice."



For emergency-like situations, the UI should visually prioritize:



Seek urgent medical care.



Do not encourage the AI to confidently diagnose diseases or prescribe prescription medicines.



---



12. SEARCH



Add a simple chat search.



Clicking the search icon should open:



Search conversations...



Search should search the mock conversation history.



Results should appear instantly.



Make this functional.



---



13. CHAT HISTORY



The sidebar should contain previous conversations.



Example:



"Hand pain after injury"



"Medicine schedule"



"Fever questions"



"Vitamin D"



Keep titles short.



Allow:



- Open conversation

- Rename conversation

- Delete conversation



Use localStorage/mock state.



---



14. SETTINGS



Settings should remain minimal.



Include only:



Appearance



- Light

- Dark

- System



Notifications



- Medicine reminders toggle



Language



- বাংলা

- English



Account



- Basic profile information



Privacy



- Simple privacy information



Do not create a complicated settings dashboard.



---



15. VISUAL DESIGN



The visual identity should be:



- Minimal

- Premium

- Calm

- Trustworthy

- Medical without looking like a hospital website

- Modern AI product

- Extremely readable



Avoid:



- Excessive gradients

- Neon colors

- Glassmorphism everywhere

- Huge shadows

- Excessive rounded cards

- Excessive animations

- Too many colors

- Dashboard-style widgets

- Decorative illustrations everywhere



Use a restrained color system.



Primary accent can be a calm blue/indigo or blue-green.



Background should be clean.



Typography should be highly readable.



Spacing should feel premium.



The interface must work beautifully on both:



mobile + desktop.



Since many Bangladeshi users will use phones, mobile UI is extremely important.



---



16. MOBILE UI



On mobile:



- Hide the desktop sidebar

- Use a hamburger/menu button

- Keep the chat full-screen

- Keep the composer fixed at the bottom

- Make buttons thumb-friendly

- Keep navigation simple



Do NOT shrink the desktop interface onto mobile.



Create a proper mobile layout.



---



17. FUNCTIONAL PROTOTYPE REQUIREMENT



This is very important.



I don't want a static visual mockup.



Build a working frontend prototype.



Every visible interactive button must perform an appropriate action.



At minimum:



- New Chat → works

- Send message → works

- Enter → sends message

- Attachment button → opens file picker

- Microphone button → shows appropriate prototype state

- Model selector → opens model menu

- Copy → copies response

- Regenerate → creates another mock response

- Helpful → works

- Not Helpful → works

- Search → works

- Chat history → works

- Rename chat → works

- Delete chat → works

- Medicine → works

- Add medicine → works

- Edit medicine → works

- Delete medicine → works

- Taken → works

- Skip → works

- Calendar → works

- Date selection → works

- Symptom checker → works

- Next/Back questions → works

- Settings → works

- Theme switch → works

- Language switch → works



Use local state/localStorage/mock data wherever backend functionality is not yet available.



Do NOT build the backend yet.



---



18. AI BACKEND PLACEHOLDER



Structure the frontend so that the real AI backend can be connected later.



Create a clean service/API layer such as:



"/services/ai"



The current prototype can use mock responses.



Later I should be able to replace the mock function with:



"Gemini API"



without redesigning the frontend.



Do not hard-code the AI logic directly into UI components.



Keep the architecture clean and modular.



---



19. IMPORTANT: DO NOT OVERBUILD



This is the most important instruction.



LESS IS MORE.



If you are unsure whether a UI element is necessary, remove it.



Do not add features simply because modern AI applications have them.



The first impression should be:



«"Oh, this is incredibly simple."»



Not:



«"Wow, there are so many things here."»



The user should immediately know:



Where do I type?



How do I ask a health question?



Where are my medicines?



Where is my symptom checker?



That's it.



---



20. ORIGINALITY



Do not clone ChatGPT.



Do not clone Gemini.



Do not clone Claude.



Do not clone Perplexity.



Do not clone Grok.



Do not clone DeepSeek.



Use their best usability principles, but create an original HealthMind AI visual language.



The final result should feel like:



"If the best AI chat interfaces were redesigned specifically for health, this is what the interface should look like."



---



21. TECH STACK



Use:



- React

- TypeScript

- Tailwind CSS

- Modern component architecture

- Responsive design

- LocalStorage for prototype persistence

- Mock AI service

- Clean reusable components



Avoid unnecessary dependencies.



Keep the code easy to modify later.



---



FINAL QUALITY BAR



Before finishing, test the complete prototype yourself.



Make sure:



1. No button is dead.

2. No navigation link is fake.

3. No overflowing UI exists.

4. Motbile layout works.

5. Desktop layout works.

6. Chat actually behaves like a chat.

7. Medine data persists after refresh.

8. Calendar interactions work.

9. Symptom-check flow works.

10. Search works.

11. Theme switching works.

12. The interface remains minimal.



Most importantly:



Do not add unnecessary UI just to make the application look "feature-rich".



I want a simple, beautiful, production-quality-looking AI health chat interface, not a complicated dashboard.



Build the frontend completely and make every current frontend interaction functional, while keeping the architecture ready for the real Gemini/API backend that will be added later.

This project was built with [Lovable](https://lovable.dev).

## Build with Lovable

Continue developing this project in the [Lovable editor](https://lovable.dev/projects/e0e00b69-49a3-43b0-9b2e-0075392e875f).

- **Ship faster**: describe what you want to build and Lovable handles the code.
- **Stay in sync**: every change made in Lovable is committed straight to this repository.
- **Full ownership**: this code is yours. Push to `main` on GitHub and your changes sync back into Lovable, ready for your next prompt.

## Development

Prefer working locally? You need Node.js and npm — [install with nvm](https://github.com/nvm-sh/nvm#installing-and-updating).

```sh
git clone <this-repository-url>
cd <repository-name>
npm i
npm run dev
```
