import asyncio,json,tempfile
from pathlib import Path
from playwright.async_api import async_playwright
async def check(page,label):
 result=await page.evaluate('''() => {
 const box=document.querySelector('.composer-area').getBoundingClientRect();
 const header=document.querySelector('.topbar').getBoundingClientRect();
 const region=document.querySelector('.chat-conversation > div') || document.querySelector('.chat-welcome');
 return {height:innerHeight,pageHeight:document.documentElement.scrollHeight,pageWidth:document.documentElement.scrollWidth,width:innerWidth,scrollY,composerTop:box.top,composerBottom:box.bottom,headerTop:header.top,regionTop:region.getBoundingClientRect().top,regionBottom:region.getBoundingClientRect().bottom,scrollHeight:region.scrollHeight,clientHeight:region.clientHeight};
 }''')
 assert result['pageHeight']<=result['height']+1,(label,result)
 assert result['pageWidth']<=result['width']+1,(label,result)
 assert result['composerBottom']<=result['height']+1,(label,result)
 assert result['composerTop']>=0,(label,result)
 assert result['headerTop']>=0,(label,result)
 assert result['regionBottom']<=result['composerTop']+1,(label,result)
 assert result['scrollY']==0,(label,result)
 print(label,json.dumps(result))
async def main():
 fixtures = Path(tempfile.mkdtemp(prefix="healthmind-layout-"))
 css = (Path(__file__).resolve().parents[1] / "src/styles.css").read_text()
 css = "\n".join(line for line in css.splitlines() if not line.startswith(("@import", "@source", "@custom-variant")))
 start = css.index("@theme inline"); end = css.index(":root")
 css = css[:start] + css[end:]
 css = css.replace("@layer base {", "").replace("a {text-decoration:none;} }", "a {text-decoration:none;}")
 reset = "*{box-sizing:border-box}h1,p{margin:0}.relative{position:relative}.flex-1{flex:1}.overflow-y-hidden{overflow-y:hidden}"
 side = '<div class="sidebar-brand">HealthMind AI</div><button class="new-chat-button">New chat</button><nav class="sidebar-nav">' + '<button class="nav-button">Health tools</button>' * 4 + '</nav><div class="sidebar-history"><div class="history-label">Recent conversations</div>' + ''.join(f'<div class="history-row"><span class="history-title">Conversation {i}</span></div>' for i in range(12)) + '</div><div class="sidebar-bottom"><div class="nav-button">Settings</div><div class="profile-row">Your profile</div></div>'
 composer = '<div class="composer-area"><div class="composer-inner"><form class="health-composer"><div data-slot="input-group"><textarea aria-label="Health question" style="width:100%"></textarea><div data-slot="input-group-addon"><button>Send message</button></div></div></form><p class="composer-disclaimer">General health information, not a medical diagnosis.<span>Always consult a healthcare professional.</span></p></div></div>'
 welcome = '<div class="chat-welcome"><div class="welcome-brand"><div class="brand-mark-large">Logo</div><span>HealthMind AI</span></div><h1>How can I help with your<br>health today?</h1><p>Ask about symptoms, medicines, health information,<br>or your treatment schedule.</p><div class="suggestions">' + '<button>Check a symptom</button>' * 4 + '</div></div>'
 transcript = '<div class="relative flex-1 overflow-y-hidden chat-conversation"><div style="height:100%;width:100%;overflow:auto"><div class="transcript">' + ''.join(f'<p class="health-message-content">{i}: Your health question and a detailed answer. ' + 'Take care and ask your doctor. ' * 25 + '</p>' for i in range(20)) + '</div></div></div>'
 for state, content in [('welcome', welcome), ('messages', transcript)]:
  (fixtures / f'{state}.html').write_text('<!doctype html><meta name="viewport" content="width=device-width,initial-scale=1"><style>' + reset + css + '</style><div class="app-shell"><aside class="app-sidebar">' + side + '</aside><main class="app-main chat-main"><header class="topbar">HealthMind AI</header><div class="chat-page">' + content + composer + '</div></main></div>')
 async with async_playwright() as p:
  browser=await p.chromium.launch(headless=True)
  page=await browser.new_page(viewport={'width':1280,'height':1800})
  for width,height in [(1280,900),(1920,1080),(390,844),(390,568),(844,390),(390,390)]:
   await page.set_viewport_size({'width':width,'height':height})
   for state in ['welcome','messages']:
    await page.goto((fixtures / f'{state}.html').as_uri())
    await page.get_by_role('textbox').focus()
    await check(page,f'{width}x{height} {state}')
    region=page.locator('.chat-conversation > div') if state=='messages' else page.locator('.chat-welcome')
    await region.evaluate('(el)=>el.scrollTop=el.scrollHeight')
    await check(page,f'{width}x{height} {state} scrolled')
    # Simulate the AI Elements field-sizing-content textarea at its allowed cap.
    await page.get_by_role('textbox').fill('A long question about my health.\n'*40)
    await page.get_by_role('textbox').evaluate('(el)=>el.style.height="192px"')
    await check(page,f'{width}x{height} {state} expanded input')
    await page.screenshot(path=str(fixtures / f'after-{width}-{height}-{state}.png'))
    # The long history must scroll without moving the composer.
    if width>=768:
     side=page.locator('.sidebar-history')
     await side.evaluate('(el)=>el.scrollTop=el.scrollHeight')
     await check(page,f'{width}x{height} {state} history scrolled')
  await browser.close()
asyncio.run(main())
