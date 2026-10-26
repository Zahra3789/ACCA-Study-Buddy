<script>
// ====================================================================== Samurai Ledger art (matches the phone app, update 23)
// Sisi is the MtPixls samurai (warm brown skin, re-cut 200 x 112 frames facing right); the moving banner is LyniaDesign's
// Tiny Pixel Japan scenery in parallax. Both are licensed packs used inside this game only. Ninja Adventure lantern and
// spider (CC0); the hats and holly were drawn for the game. This block replaces the drawn-shapes banner, the still
// samurai pictures and the theme trimmings; the questions, lessons and everything else above are unchanged.
(function () {
const ZFW = 200, ZFH = 112, ZFEET = 96, ZBODY = 66;
// [sheet, frames per second, loops]
const ZS = { idle: ['zuru_idle', 8, true], quick: ['zuru_quick', 18, false], slash: ['zuru_slash', 26, false], item: ['zuru_item', 16, false],
  hurt: ['zuru_hurt', 14, false], run: ['zuru_run', 16, true], relax: ['zuru_relax', 6, true], jump: ['zuru_jump', 24, false], walk: ['zuru_walk', 10, true] };
const sheet = a => JI(`../assets/characters/${ZS[a][0]}.png`);
const ready = im => im && im.complete && im.naturalWidth > 0;
const nFrames = a => { const im = sheet(a); return ready(im) ? Math.max(1, Math.floor(im.naturalWidth / ZFW)) : 1; };

// An animation player: frame, timing, finished.
class Anim {
  constructor(name, fpsOver) { this.fpsOver = fpsOver || {}; this.play(name, true); }
  play(name, force) { if (!force && this.name === name && !this.done) return; this.name = name; this.f = 0; this.t = 0; this.done = false; }
  step(dt) { if (this.done) return false; const [, fps0, loop] = ZS[this.name], fps = this.fpsOver[this.name] || fps0, n = nFrames(this.name);
    this.t += dt; let finished = false;
    while (this.t >= 1 / fps) { this.t -= 1 / fps; if (this.f < n - 1) this.f++; else if (loop) this.f = 0; else { this.done = true; finished = true; break; } }
    return finished; }
}
// Draw the current frame with its top-left at (x, y), s = scale.
function drawFrame(g, an, x, y, s) { const im = sheet(an.name); if (!ready(im)) return; g.drawImage(im, an.f * ZFW, 0, ZFW, ZFH, x, y, ZFW * s, ZFH * s); }

// ---------------------------------------------------------------- theme hats
// Where the hat goes in each frame, worked out from her FACE (her ponytail swings): the top of her hair near the
// middle, then the topmost row of skin just under it - her forehead. The brim sits 2 px below that, centred 1 px
// behind the middle of her face, so the hat stays on her head through every move.
const SKIN = [[0xa8, 0x72, 0x4c], [0x8f, 0x5c, 0x3a], [0x70, 0x45, 0x2a]];
const isSkin = (d, p) => SKIN.some(s => Math.abs(d[p] - s[0]) < 16 && Math.abs(d[p + 1] - s[1]) < 16 && Math.abs(d[p + 2] - s[2]) < 16);
const heads = {};
function headOf(a, f) { const key = ZS[a][0];
  if (!heads[key]) { const im = sheet(a); if (!ready(im)) return { x: 101, y: 48 };
    const c = document.createElement('canvas'); c.width = im.naturalWidth; c.height = im.naturalHeight; const g = c.getContext('2d'); g.drawImage(im, 0, 0);
    const d = g.getImageData(0, 0, c.width, c.height).data, out = [], W = c.width;
    for (let fr = 0; fr < W / ZFW; fr++) { const ox = fr * ZFW; let hair = { x: 101, y: 43 };
      scan: for (let y = 0; y < ZFH; y++) for (let x = ox + 70; x < ox + 130; x++) { const p = (y * W + x) * 4;
        if (d[p + 3] > 128 && (0.299 * d[p] + 0.587 * d[p + 1] + 0.114 * d[p + 2]) / 255 < 0.3) { hair = { x: x - ox, y }; break scan; } }
      let top = -1, sx = 0, n = 0;
      for (let y = hair.y; y < Math.min(ZFH, hair.y + 26); y++) { if (top >= 0 && y > top + 3) break;
        for (let x = Math.max(0, hair.x - 16); x < Math.min(ZFW, hair.x + 16); x++) { const p = (y * W + ox + x) * 4;
          if (d[p + 3] > 128 && isSkin(d, p)) { if (top < 0) top = y; sx += x; n++; } } }
      out.push(n ? { x: sx / n - 1, y: top + 2 } : { x: hair.x + 1, y: hair.y + 5 }); }
    heads[key] = out; }
  return heads[key][f] || { x: 101, y: 48 }; }
function hatImg() { const t = theme(); return t === 'xmas' ? JI('../assets/xmas/hat_santa.png') : t === 'halloween' ? JI('../assets/xmas/hat_witch.png') : null; }
function drawHat(g, an, x, y, s) { const h = hatImg(); if (!ready(h)) return; const p = headOf(an.name, an.f), w = h.naturalWidth * s, hh = h.naturalHeight * s;
  g.drawImage(h, x + p.x * s - w / 2, y + p.y * s - hh, w, hh); }

// ---------------------------------------------------------------- Sisi, animated, in battles, lessons and the Section B case
// Never idle: a breath in her stance, then every few seconds a quick-draw, a slash or a trick with an item.
// act('happy') / act('sad') play a reaction straight away.
const lives = [];
class Live {
  constructor(canvas, boxed) { this.c = canvas; this.boxed = boxed; this.an = new Anim('idle'); this.wait = 2; canvas._live = this; lives.push(this); }
  act(m) { this.an.play(m === 'happy' ? 'quick' : m === 'slash' ? 'slash' : m === 'sad' ? 'hurt' : 'idle', true); }
  step(dt) { if (this.an.step(dt)) { this.an.play('idle', true); this.wait = 1.8 + Math.random() * 1.8; }
    if (this.an.name === 'idle') { this.wait -= dt; if (this.wait <= 0) this.an.play(['quick', 'slash', 'item'][Math.floor(Math.random() * 3)], true); } }
  draw() { const c = this.c, g = c.getContext('2d'); g.imageSmoothingEnabled = false; g.clearRect(0, 0, c.width, c.height);
    const s = this.boxed ? (c.height - 12 * 2) * 1.08 / ZBODY : c.height * 0.9 / ZBODY;   // canvas is drawn at 2x its size on screen
    const x = c.width / 2 - ZFW / 2 * s, y = c.height - (this.boxed ? 16 : 0) - ZFEET * s;
    drawFrame(g, this.an, x, y, s); drawHat(g, this.an, x, y, s); }
}
for (const [id, boxed] of [['you', false], ['lessonYou', true], ['mtqYou', true]]) { const c = $(id); if (c && c.getContext) new Live(c, boxed); }
// Sisi reacts with a move instead of a face swap.
mood = function (m, id = 'you') { const c = $(id); if (c && c._live) c._live.act(m); };

// ---------------------------------------------------------------- the moving banner (port of the app's Journey.gd)
const CYCLE = 120, SCENE_H = 180, PATH_Y = 158, SCALE = 1.35, STRIDE = 80;
const LAYERS = [['Sky', 0, 1], ['Clouds', 0.04, 1], ['Fuji', 0.02, 4], ['Mountain_Back', 0.08, 1], ['Mountain_Middle', 0.15, 1], ['Mountain_Front', 0.25, 1],
  ['BackgroundTrees', 0.35, 1], ['Shrine_Multiple', 0.45, 3], ['House', 0.55, 2], ['Trees', 0.7, 1], ['Ground', 1, 1]];
const FRONT = ['Gras', 1.25];
const SET = 0.8, CHOP = 4.2, LIGHT = 4.9, SIT_END = 15, CAMP = 16.5;
const TINT = [[0, [1, .82, .8]], [.1, [1, 1, 1]], [.42, [1, 1, 1]], [.52, [1, .72, .55]], [.6, [.42, .42, .7]], [.9, [.32, .36, .62]], [1, [1, .82, .8]]];
const SNOWY = ['Trees', 'BackgroundTrees', 'Ground', 'Gras', 'Mountain_Front', 'Mountain_Middle', 'Mountain_Back', 'Fuji', 'House', 'Shrine_Multiple'];
const scen = n => JI(`../assets/scenery/${n}.png`);
const J = { clock: 0.3, near: 0, state: 'walk', st: 16, campX: 0, campOn: false, rock: -1, nextRock: 6, rockMove: '', bubble: '', speed: 0, chops: 0,
  move: '', mt: -1, twice: false, smash: null, puffs: [], an: new Anim('run', { slash: 32, quick: 18, item: 18, jump: 24 }), again: 0, againAnim: '' };
J.st = 14 + Math.random() * 6;
const jc = $('journey'), JWW = jc.width, JHH = jc.height, k = JHH / SCENE_H, zx = JWW * 0.32, ground = PATH_Y * k, zs = k * SCALE;
const night = () => J.clock > 0.5 && J.clock < 0.95;
const elapsed = () => CAMP - J.st;
function phase() { if (J.state !== 'camp') return ''; const e = elapsed(); return e < SET ? 'set' : e < CHOP ? 'chop' : e < LIGHT ? 'light' : e < SIT_END ? 'sit' : 'out'; }
function tint() { for (let i = 0; i < TINT.length - 1; i++) { const a = TINT[i], b = TINT[i + 1]; if (J.clock >= a[0] && J.clock <= b[0]) { const t = (J.clock - a[0]) / (b[0] - a[0]); return a[1].map((v, j) => v + (b[1][j] - v) * t); } } return TINT[0][1]; }
const css = c => `rgb(${Math.round(Math.min(1, c[0]) * 255)},${Math.round(Math.min(1, c[1]) * 255)},${Math.round(Math.min(1, c[2]) * 255)})`;
const puff = (x, y) => J.puffs.push([x, y, performance.now() / 1000]);
function play(a) { J.an.play(a); }
function endMove() { J.move = ''; J.mt = -1; J.twice = false; if (J.state === 'walk') play('run'); }
const pickOf = l => l[Math.floor(Math.random() * l.length)];
function nextState() {
  if (J.state !== 'walk') { J.state = 'walk'; J.st = 12 + Math.random() * 8; J.bubble = ''; play('run'); return; }
  if (night() || (J.clock > 0.45 && Math.random() < 0.7)) {
    J.state = 'camp'; J.st = CAMP; J.chops = 0;
    J.campX = J.near + zx + 40 * k + J.speed * J.speed / (2 * STRIDE * zs * 2.5); J.campOn = true; puff(J.campX + 4 * k, ground); J.bubble = 'Firewood!'; play('run');
    return; }
  // by day: a different stop from last time - sword drills, a pause to take in the view, an item trick, a stroll
  J.state = pickOf(['train', 'pause', 'trick', 'stroll'].filter(o => o !== J.lastStop)); J.lastStop = J.state;
  if (J.state === 'train') { J.st = 6; J.bubble = pickOf(['Hyah!', 'Again!', 'Focus. Strike.']); J.an.play('quick', true); }
  else if (J.state === 'pause') { J.st = 4.5; J.bubble = pickOf(['What a view.', 'Breathe in...', 'Hmm. Accruals.', 'One more chapter.']); J.an.play('idle', true); }
  else if (J.state === 'trick') { J.st = 4.5; J.bubble = pickOf(['Watch this!', 'Ta-da!']); J.an.play('item', true); }
  else { J.st = 7; J.bubble = ''; J.an.play('walk', true); } }
// Attacks don't loop: swing, a breath, swing again (drills mix quick-draws and big slashes). Chopping splits the log further.
function animDone() { const a = J.an.name;
  if (phase() === 'chop' && a === 'slash') { J.chops = Math.min(J.chops + 1, 3); if (J.chops === 3) J.bubble = "That'll do."; }
  const again = J.state === 'train' ? (a === 'quick' ? 'slash' : 'quick') : J.state === 'trick' ? 'item' : phase() === 'chop' ? 'slash' : '';
  if (again) { J.againAnim = again; J.again = J.state === 'trick' ? 0.4 : 0.2; J.againFor = J.state; } }
journeyUpdate = function (dt) {
  J.clock = (J.clock + dt / CYCLE) % 1;
  const before = phase(); J.st -= dt; const ph = phase();
  if (ph !== before) {
    if (ph === 'chop') J.an.play('slash', true);
    else if (ph === 'light') { J.an.play('item', true); puff(J.campX + 42 * k, ground); J.bubble = ''; }
    else if (ph === 'sit') { play('relax'); J.bubble = ['A fine night.', 'Debits by the fire...', 'The stars balance too.', 'Rest, then one more chapter.'][Math.floor(Math.random() * 4)]; }
    else if (ph === 'out') { puff(J.campX + 42 * k, ground); J.bubble = ''; } }
  if (J.st <= 0) nextState();
  if (J.again > 0) { J.again -= dt; if (J.again <= 0 && J.state === J.againFor && (J.state !== 'camp' || phase() === 'chop')) J.an.play(J.againAnim, true); }
  if (J.an.step(dt)) animDone();
  const target = J.state === 'walk' ? STRIDE * zs : J.state === 'stroll' ? STRIDE * zs * 0.45 : 0, acc = dt * STRIDE * zs * 2.5;   // a stroll is under half running pace
  J.speed = J.speed < target ? Math.min(target, J.speed + acc) : Math.max(target, J.speed - acc);
  if (J.state === 'walk' && J.an.name !== 'run' && J.mt < 0) play('run');
  if (J.state === 'stroll' && J.an.name !== 'walk') play('walk');
  J.near += J.speed * dt;
  // rocks roll in now and then while she runs (not all jumping); each gets a move - never the same twice running
  if (J.state === 'walk') { J.nextRock -= dt;
    if (J.rock < 0 && J.nextRock <= 0 && J.mt < 0) { J.rock = J.near + JWW + 20; J.nextRock = 9 + Math.random() * 6;
      const ms = ['jump', 'double', 'dash'].filter(m => m !== J.rockMove); J.rockMove = ms[Math.floor(Math.random() * ms.length)]; } }
  if (J.rock >= 0) { const rx = J.rock - J.near, reach = ({ jump: 60, double: 50, dash: 100 })[J.rockMove] * k;
    if (J.mt < 0 && rx < zx + reach && rx > zx - 10 && J.state === 'walk') { J.move = J.rockMove; J.mt = 0;
      if (J.move === 'dash') { J.an.play('quick', true); puff(J.near + zx - 20 * k, ground); } else { J.an.play('jump', true); puff(J.near + zx, ground); } }
    if (J.move === 'dash' && J.mt >= 0 && rx < zx + 16 * k) { puff(J.rock, ground); J.smash = [J.rock, performance.now() / 1000]; J.rock = -1; }
    else if (rx < -40) J.rock = -1; }
  J.lift = 0;
  if (J.mt >= 0) { J.mt += dt;
    if (J.move === 'jump') { const p = Math.min(1, J.mt / 0.95); J.lift = Math.sin(p * Math.PI) * 34 * k; if (p >= 1) endMove(); }
    else if (J.move === 'double') { if (J.mt < 0.4) J.lift = Math.sin(J.mt / 0.55 * Math.PI) * 22 * k;
      else { const p = Math.min(1, (J.mt - 0.4) / 0.95), h0 = Math.sin(0.4 / 0.55 * Math.PI) * 22 * k;
        if (!J.twice) { J.twice = true; J.an.play('jump', true); puff(J.near + zx, ground - h0); }
        J.lift = h0 * (1 - p) + Math.sin(p * Math.PI) * 36 * k; if (p >= 1) endMove(); } }
    else if (J.move === 'dash') { J.near += STRIDE * zs * 2.4 * dt; if (J.mt > 0.5) endMove(); } }
  if (J.campOn && J.campX - J.near < -200) J.campOn = false; };

// themed copies of the scenery layers, made once: snowy at Christmas, a purple dusk at Halloween
const variants = {};
function layerImg(n) { const im = scen(n), th = theme(); if (!ready(im) || !th) return im;
  const key = n + '@' + th; if (variants[key]) return variants[key];
  const m = th === 'xmas' ? (SNOWY.includes(n) ? [1.5, 1.85, 1.95] : null) : (n === 'Sky' || n === 'Clouds' ? [0.7, 0.5, 0.95] : [0.78, 0.62, 0.9]);
  if (!m) return (variants[key] = im);
  const c = document.createElement('canvas'); c.width = im.naturalWidth; c.height = im.naturalHeight; const g = c.getContext('2d'); g.drawImage(im, 0, 0);
  const d = g.getImageData(0, 0, c.width, c.height); for (let p = 0; p < d.data.length; p += 4) for (let j = 0; j < 3; j++) d.data[p + j] = Math.min(255, d.data[p + j] * m[j]);
  g.putImageData(d, 0, 0); return (variants[key] = c); }
// scratch canvases: Sisi and the front layer are tinted on their own (the scenery's tint is a multiply over the whole banner)
const mk = () => { const c = document.createElement('canvas'); c.width = JWW; c.height = JHH; return c; };
const zc = mk(), fc = mk(), mask = mk();
function tinted(c, col) { const g = c.getContext('2d'), m = mask.getContext('2d'); m.clearRect(0, 0, JWW, JHH); m.drawImage(c, 0, 0);
  g.globalCompositeOperation = 'multiply'; g.fillStyle = css(col); g.fillRect(0, 0, JWW, JHH); g.globalCompositeOperation = 'destination-in'; g.drawImage(mask, 0, 0); g.globalCompositeOperation = 'source-over'; }
function frameOf(g, name, f, x, y, w, h) { const im = JI(name); if (!ready(im)) return; const fh = im.naturalHeight, n = Math.max(1, Math.floor(im.naturalWidth / fh));
  g.drawImage(im, (f % n) * fh, 0, fh, fh, x, y, w, h); }
function prop(g, name, x, sk, grow = 1, lift = 0) { const im = JI(name); if (!ready(im) || grow <= 0) return; const w = im.naturalWidth * sk * grow, h = im.naturalHeight * sk * grow;
  g.drawImage(im, x - w / 2, ground - h - lift, w, h); }
journeyDraw = function (g, now) {
  g.imageSmoothingEnabled = false; const near = J.near, th = theme(), t = tint();
  if (!ready(scen('Sky'))) { g.fillStyle = '#2a1e2e'; g.fillRect(0, 0, JWW, JHH); return; }
  for (const [n, sp, rep] of LAYERS) { const im = layerImg(n), w = 353 * k, period = w * rep;
    const off = ((near * sp + (n === 'Clouds' ? now * 4 : 0)) % period + period) % period;
    for (let x = -off; x < JWW; x += period) g.drawImage(im, x, 0, w, JHH);
    if (n === 'Sky' && night()) { const a = Math.max(0, Math.min(1, 1 - Math.abs(J.clock - 0.75) / 0.2));
      for (let i = 0; i < 30; i++) { const r1 = ((Math.sin(i * 12.9898) * 43758.5453) % 1 + 1) % 1, r2 = ((Math.sin(i * 78.233) * 12345.678) % 1 + 1) % 1;
        const sx = ((r1 * JWW * 1.2 - near * 0.01) % JWW + JWW) % JWW; g.fillStyle = `rgba(255,255,230,${a * (0.5 + 0.5 * Math.sin(now * 2.5 + i))})`; g.fillRect(Math.floor(sx), Math.floor(r2 * JHH * 0.45), 2, 2); } } }
  // theme pieces along the path
  if (th) { const period = (th === 'xmas' ? 430 : 360) * k, first = Math.floor((near - 120 * k) / period), last = Math.ceil((near + JWW + 120 * k) / period);
    for (let i = first; i <= last; i++) { const x = i * period + 150 * k - near;
      if (th === 'xmas') { prop(g, '../assets/xmas/tree.png', x, k * 2.2); if (((i % 2) + 2) % 2 === 0) { prop(g, '../assets/xmas/present.png', x + 24 * k, k * 1.6); prop(g, '../assets/xmas/present.png', x - 22 * k, k * 1.3); } }
      else { prop(g, '../assets/xmas/pumpkin.png', x, k * 1.4);
        if (((i % 2) + 2) % 2 === 1) { const lx = x + 70 * k, top = ground - 46 * k; g.strokeStyle = '#3b2a2a'; g.lineWidth = Math.max(2, 2 * k); g.beginPath(); g.moveTo(lx, ground); g.lineTo(lx, top); g.stroke(); } } } }
  // the campsite: stump and log, chopped onto the woodpile; the fire is drawn later, bright
  const e = J.state === 'camp' ? elapsed() : CAMP, cxs = J.campX - near;
  if (J.campOn) { const grow = Math.max(0, Math.min(1, e / SET)); prop(g, '../assets/fx/stump.png', cxs, k * 1.1, grow); const sh = 28 * k * 1.1;
    if (e < CHOP) { const gap = J.chops * 3 * k; if (J.chops === 0) prop(g, '../assets/fx/log.png', cxs, k * 2.2, grow, sh - 4 * k);
      else if (J.chops < 3) { prop(g, '../assets/fx/log.png', cxs - gap, k * 1.6, 1, sh - 4 * k); prop(g, '../assets/fx/log.png', cxs + gap, k * 1.6, 1, sh - 4 * k); } }
    prop(g, '../assets/fx/log_pile.png', cxs + 88 * k, k * 1.3, e < CHOP ? Math.min(1, J.chops / 3) : 1);
    if (e >= LIGHT && !(J.state === 'camp' && e < CAMP && e >= CHOP)) { const h = 32 * k * 1.3; frameOf(g, '../assets/fx/campfire.png', 0, cxs + 46 * k - h / 2, ground - h, h, h); } }
  if (J.rock >= 0) prop(g, '../assets/fx/rock.png', J.rock - near, k * 1.6);
  // the time of day over the whole scene
  g.globalCompositeOperation = 'multiply'; g.fillStyle = css(t); g.fillRect(0, 0, JWW, JHH); g.globalCompositeOperation = 'source-over';
  // things that glow: the campfire, the paper lanterns
  if (J.campOn && J.state === 'camp' && e >= CHOP) { let fire = Math.min(1, (e - CHOP) / (LIGHT - CHOP)); if (e > SIT_END) fire = Math.max(0, 1 - (e - SIT_END) / (CAMP - SIT_END));
    if (fire > 0) { const fx = cxs + 46 * k; g.fillStyle = 'rgba(255,153,64,.18)'; g.beginPath(); g.arc(fx, ground - 10 * k, 36 * k * fire, 0, 6.3); g.fill();
      const h = 32 * k * 1.3 * fire; frameOf(g, '../assets/fx/campfire.png', Math.floor(now * 8), fx - h / 2, ground - h, h, h); } }
  if (th === 'halloween') { const period = 360 * k, first = Math.floor((near - 120 * k) / period), last = Math.ceil((near + JWW + 120 * k) / period), lan = JI('../assets/fx/lantern.png');
    for (let i = first; i <= last; i++) if (((i % 2) + 2) % 2 === 1 && ready(lan)) { const lx = i * period + 150 * k - near + 70 * k, top = ground - 46 * k, ls = 16 * k * 1.2;
      g.fillStyle = `rgba(255,115,51,${0.22 + 0.06 * Math.sin(now * 3.3 + i)})`; g.beginPath(); g.arc(lx, top - 6 * k, 16 * k, 0, 6.3); g.fill();
      g.drawImage(lan, 0, (Math.floor(now / 0.22) % 4) * 16, 16, 16, lx - ls / 2, top - ls + 4 * k, ls, ls); } }
  // Sisi (lit a little more than the scenery so she stays readable), after-images on a dash, her theme hat
  const z = zc.getContext('2d'); z.imageSmoothingEnabled = false; z.clearRect(0, 0, JWW, JHH);
  const fx0 = zx - ZFW / 2 * zs, fy0 = ground - (J.lift || 0) - ZFEET * zs;
  if (J.move === 'dash' && J.mt >= 0) for (let i = 3; i > 0; i--) { z.globalAlpha = 0.45 - i * 0.12; drawFrame(z, J.an, fx0 - i * 26 * k, fy0, zs); }
  z.globalAlpha = 1; drawFrame(z, J.an, fx0, fy0, zs); drawHat(z, J.an, fx0, fy0, zs);
  tinted(zc, t.map(v => v + (1 - v) * 0.35)); g.drawImage(zc, 0, 0);
  // over her: wood chips, dust puffs, the grass
  const f = fc.getContext('2d'); f.imageSmoothingEnabled = false; f.clearRect(0, 0, JWW, JHH); const pnow = performance.now() / 1000;
  if (phase() === 'chop' && J.an.name === 'slash' && J.an.f >= 9 && J.an.f <= 20) frameOf(f, '../assets/fx/wood_chips.png', (J.an.f - 9) % 6, cxs - 6 * k, ground - 46 * k, 24 * k, 24 * k);
  J.puffs = J.puffs.filter(p => pnow - p[2] < 0.5);
  for (const p of J.puffs) frameOf(f, '../assets/fx/smoke.png', Math.floor((pnow - p[2]) / 0.5 * 6), p[0] - near - 18 * k, p[1] - 30 * k, 36 * k, 36 * k);
  const gt = layerImg(FRONT[0]), gw = 353 * k; if (ready(scen(FRONT[0]))) for (let x = -(((near * FRONT[1]) % gw) + gw) % gw; x < JWW; x += gw) f.drawImage(gt, x, 0, gw, JHH);
  tinted(fc, t); g.drawImage(fc, 0, 0);
  // bright bits on top: embers, the cut through a sliced rock, snow or bats, the speech bubble
  if (phase() === 'light' || phase() === 'sit') { const fx = cxs + 46 * k; for (let i = 0; i < 3; i++) { const p = ((now * 0.5 + i * 0.33) % 1);
    g.globalAlpha = 1 - p; frameOf(g, '../assets/fx/embers.png', Math.floor(now * 10) + i, fx - 6 * k + Math.sin(now * 2 + i) * 6 * k, ground - 30 * k - p * 40 * k, 10 * k, 10 * k); } g.globalAlpha = 1; }
  if (J.smash && pnow - J.smash[1] < 0.3) frameOf(g, '../assets/fx/cutx.png', Math.floor((pnow - J.smash[1]) / 0.3 * 4), J.smash[0] - near - 22 * k, ground - 40 * k, 44 * k, 44 * k);
  if (th === 'xmas') { g.fillStyle = 'rgba(255,255,255,.85)';
    for (let i = 0; i < 40; i++) { const r1 = ((Math.sin(i * 12.9898) * 43758.5453) % 1 + 1) % 1, r2 = ((Math.sin(i * 78.233) * 12345.678) % 1 + 1) % 1;
      const y = ((r2 * JHH + now * (18 + r1 * 22)) % JHH), x = (((r1 * JWW * 1.3 + Math.sin(now * 0.8 + i) * 10 - near * 0.15) % JWW) + JWW) % JWW, s = 2 + Math.floor(r1 * 3); g.fillRect(Math.floor(x), Math.floor(y), s, s); } }
  else if (th === 'halloween') { const bat = JI('../assets/xmas/bat.png'); if (ready(bat)) for (let i = 0; i < 3; i++) { const r1 = ((Math.sin(i * 3.7 + 1) * 43758.5453) % 1 + 1) % 1;
    const x = JWW - ((now * (40 + r1 * 30) + r1 * JWW) % (JWW + 80)), y = JHH * (0.12 + 0.22 * r1) + Math.sin(now * 5 + i) * 8, flap = Math.abs(Math.sin(now * 9 + i)) > 0.5; g.drawImage(bat, x, y, 38, flap ? 19 : 12); } }
  if (J.bubble && J.state !== 'walk') { g.font = '18px Body, sans-serif'; const tw = g.measureText(J.bubble).width, bx = Math.max(6, Math.min(JWW - tw - 26, zx - tw / 2)), by = Math.max(4, ground - 55 * zs - 46);
    g.fillStyle = '#2b1d2a'; g.fillRect(bx - 4, by - 4, tw + 28, 34); g.fillStyle = '#fff4d6'; g.fillRect(bx - 2, by - 2, tw + 24, 30); g.fillRect(zx - 4, by + 28, 8, 8);
    g.fillStyle = '#3e2731'; g.fillText(J.bubble, bx + 10, by + 20); }
  g.fillStyle = 'rgba(43,29,42,.9)'; g.fillRect(0, JHH - 4, JWW, 4); };

// ---------------------------------------------------------------- monsters wear the theme hat too
function hatMonsters(root) {
  for (const im of (root || document).querySelectorAll('img')) {
    if (im.dataset.hatted || !im.getAttribute('src') || im.getAttribute('src') !== A('../assets/monster.png') || im.id === 'foe' || im.closest('.mwrap')) continue;
    im.dataset.hatted = '1'; const w = document.createElement('span'); w.className = 'mwrap'; im.replaceWith(w); w.append(im);
    w.insertAdjacentHTML('beforeend', `<img class="mhat s" src="${A('../assets/xmas/hat_santa.png')}" alt=""><img class="mhat w" src="${A('../assets/xmas/hat_witch.png')}" alt="">`); } }
new MutationObserver(ms => { for (const m of ms) for (const n of m.addedNodes) if (n.nodeType === 1) hatMonsters(n.tagName === 'IMG' ? n.parentNode : n); }).observe($('screen'), { childList: true, subtree: true });
hatMonsters();
// the battle monster moves about, so its hat follows it each frame
const foeHat = document.createElement('img'); foeHat.id = 'foeHat'; $('field').append(foeHat);
function syncFoeHat() { const h = hatImg(), foe = $('foe'); if (!h || $('battle').classList.contains('hidden')) { foeHat.style.display = 'none'; return; }
  const r = foe.getBoundingClientRect(), fr = $('field').getBoundingClientRect(), s = stageScale || 1, w = r.width / s * 0.5, hh = w * 13 / 18;
  foeHat.src = h.src; Object.assign(foeHat.style, { display: 'block', width: w + 'px', height: hh + 'px', left: ((r.left - fr.left) / s + r.width / s * 0.25) + 'px',
    top: ((r.top - fr.top) / s + r.height / s * 0.22 - hh) + 'px', opacity: getComputedStyle(foe).opacity }); }

// ---------------------------------------------------------------- theme trimmings round the edges, and themed battles
// Christmas: icicles under the lights, holly in the top corners, snow drifts in the bottom ones.
// Halloween: cobwebs in all four corners and a little spider bobbing on its thread.
const deco = document.createElement('canvas'); deco.id = 'deco'; deco.width = 720; deco.height = 1280; $('screen').append(deco);
const TOP = 74;
function web(g, cx, cy, dx, dy, r) { g.strokeStyle = 'rgba(237,237,247,.55)'; g.lineWidth = 2; const ends = [];
  for (let s = 0; s < 6; s++) { const a = Math.PI / 2 * s / 5, d = [Math.cos(a) * dx, Math.sin(a) * dy]; ends.push(d); g.beginPath(); g.moveTo(cx, cy); g.lineTo(cx + d[0] * r, cy + d[1] * r); g.stroke(); }
  for (const ring of [0.3, 0.52, 0.74, 0.95]) for (let s = 0; s < 5; s++) { const p1 = [cx + ends[s][0] * r * ring, cy + ends[s][1] * r * ring], p2 = [cx + ends[s + 1][0] * r * ring, cy + ends[s + 1][1] * r * ring];
    const mx = (p1[0] + p2[0]) / 2, my = (p1[1] + p2[1]) / 2; g.beginPath(); g.moveTo(p1[0], p1[1]); g.lineTo(mx + (cx - mx) * 0.12, my + (cy - my) * 0.12); g.lineTo(p2[0], p2[1]); g.stroke(); } }
function drawDeco(now) { const th = theme(), g = deco.getContext('2d'); g.imageSmoothingEnabled = false; g.clearRect(0, 0, 720, 1280); deco.style.display = th ? 'block' : 'none'; if (!th) return;
  if (th === 'xmas') { let x = 6, i = 0;
    while (x < 720) { const r = ((Math.sin(i * 12.9898) * 43758.5453) % 1 + 1) % 1, w = 8 + r * 6, h = 10 + r * 22;
      g.fillStyle = 'rgba(224,242,255,.85)'; g.beginPath(); g.moveTo(x, TOP); g.lineTo(x + w, TOP); g.lineTo(x + w / 2, TOP + h); g.fill(); x += w + 10 + r * 18; i++; }
    const ho = JI('../assets/xmas/holly.png'); if (ready(ho)) { const w = ho.naturalWidth * 3, h = ho.naturalHeight * 3; g.drawImage(ho, 4, TOP + 2, w, h); g.drawImage(ho, 720 - 4 - w, TOP + 2, w, h); }
    g.fillStyle = 'rgba(245,250,255,.92)'; for (const [cx, d] of [[-6, 1], [726, -1]]) { g.beginPath(); g.arc(cx, 1294, 52, 0, 6.3); g.fill(); g.beginPath(); g.arc(cx + 40 * d, 1302, 34, 0, 6.3); g.fill(); } }
  else { web(g, 0, TOP, 1, 1, 120); web(g, 720, TOP, -1, 1, 120); web(g, 0, 1280, 1, -1, 110); web(g, 720, 1280, -1, -1, 110);
    const sp = JI('../assets/fx/spider.png'); if (ready(sp)) { const x = 56, y = TOP + 70 + Math.sin(now * 1.3) * 12; g.strokeStyle = 'rgba(235,235,242,.7)'; g.lineWidth = 2;
      g.beginPath(); g.moveTo(x, TOP + 30); g.lineTo(x, y - 18); g.stroke(); g.drawImage(sp, 0, (Math.floor(now * 4) % 4) * 16, 16, 16, x - 24, y - 24, 48, 48); } } }
const props = [];
const _scene = scene;
scene = function (c) { const th = theme();   // a snowy night field with Christmas trees, or a dusky Halloween one with pumpkins
  if (th === 'xmas') c = ['#0f1a3a', '#6f8fc8', '#eef4ff']; else if (th === 'halloween') c = ['#1a0f2e', '#c0602a', '#2e2236'];
  _scene(c); for (const p of props.splice(0)) p.remove();
  const list = th === 'xmas' ? [['tree', 24, 64, 96], ['tree', 300, 48, 72], ['present', 92, 36, 36]] : th === 'halloween' ? [['pumpkin', 30, 72, 58], ['pumpkin', 310, 52, 42]] : [];
  for (const [n, x, w, h] of list) { const im = document.createElement('img'); im.className = 'fprop'; im.src = A(`../assets/xmas/${n}.png`); Object.assign(im.style, { left: x + 'px', top: (372 - h) + 'px', width: w + 'px', height: h + 'px' });
    $('field').prepend(im); props.push(im); } };

// ---------------------------------------------------------------- battle action and banter (as in the app)
// A right answer: Sisi dashes across and cuts (a big slash on a combo). A wrong one: the monster pounces on her.
// Now and then a one-liner pops up: Sisi bragging, the monster yelping, taunting, or begging when it's down.
Object.assign(SENSEI, {
  quip_win: { proper: ['Too easy!', 'Ate and left no crumbs.', 'Debit: you. Credit: the floor.', 'Main character energy.', 'Understood the assignment.', 'Next!'],
    east: ['Light work, wallahi.', 'Sit DOWN, walaal.', 'Debit you, credit the floor, innit.', "You're not ready, sxb.", 'Mashallah to ME, honestly.', 'Bring your cousin next time.', 'Easy. Hooyo could do that one.', "Haye! Who's next?"] },
  quip_hurt: { proper: ['Ouch! My margins!', 'Not the variances!', 'Lowkey that hurt.', 'My reserves!'],
    east: ['Ay! HOOYOOO!', 'Wallahi that hurt!', 'Ow, ow, OW, walaal!', "I'm telling my aabo!", "Waa maxay?! That's not fair!"] },
  quip_taunt: { proper: ['Is that all?', "It's giving... wrong.", 'Not the vibe, bestie.', "Your budget doesn't even balance!", 'Ha! Back to the revision notes!', 'Flop era.'],
    east: ['Ceeb! Your hooyo saw that.', 'Nacas! Who taught you, TikTok?', 'That was embarrassing, wallahi.', "Allow it, you're getting cooked.", 'Even my ayeeyo knows that one!', 'Ha! Back to dugsi with you!', 'Ukun! Sit down.'] },
  quip_low: { proper: ['Wait! Can we talk about this?', 'I yield! Respectfully!', 'Please... not the audit!'],
    east: ["Wait wait, walaal, we're cousins!", "Allow it! I've got kids!", "I'll pay you in xalwo, I swear!", "Waan ka xumahay! I'm sorry!"] } });
// The big pop-up and name tag after an answer: not CORRECT / WRONG (green or red says that) but a quick daft word.
Object.assign(SENSEI, {
  shout_right: { proper: ['NICE!', 'ATE THAT!', 'BIG BRAIN!', 'SHEESH!', 'CLEAN!', 'BIG W!', 'HAYE!'],
    east: ['WALLAHI!', 'MASHALLAH!', 'HAYE!', 'LIGHT WORK!', 'PENG!', 'SAY LESS!', 'HAMBALYO!', 'SUBHANALLAH!'] },
  shout_wrong: { proper: ['OOF!', 'NOPE!', 'FLOP!', 'YIKES!', 'NOT IT!', 'L!', 'CEEB!'],
    east: ['CEEB!', 'NACAS!', 'WARYAA!', 'ALLOW IT!', 'PEAK!', 'UKUN!', 'BRUV...'] } });
let shout = '';
verdict = function (ok) { const v = $('verdict'); shout = S(ok ? 'shout_right' : 'shout_wrong'); v.textContent = shout; v.className = ok ? 'good' : 'bad';
  clearTimeout(v._t); v._t = setTimeout(() => v.className = 'hidden', 1600); };
const _speaker = speaker;
speaker = function (name, style) { _speaker(name, style); if ((name === 'CORRECT' || name === 'WRONG') && shout) $('speaker').textContent = shout; };
// Boss Arena names: daft ones (with a few Somali names mixed in); with E-LDN on, Somali characters.
const BOSS_NAMES = {
  proper: ['Karen', 'Your Situationship', "Man Who Says 'No Cap' Unironically", 'Love Island Reject', 'Group Chat Admin', 'The Guy From Hinge', 'Influencer With 300 Followers',
    'Course Mate Who Never Does Their Part', 'Uber Driver Doing A Podcast', 'Phil Mitchell', 'Pret Barista Who Spells Your Name Wrong', 'Ex Who Watched Your Story',
    'Library Seat Thief', 'Lecturer Who Reads The Slides', 'Brother-In-Law Who Does Crypto', 'Auntie Hodan', 'Cousin Abdi', 'Faduma Who Left You On Read'],
  east: ['Abdi From The Corner Shop', 'Auntie Hodan With The Dacas', 'Uncle Farah, Phone-Case King', 'Cousin Mo Who Owes You 20 Quid', "Ayeeyo's 9-Minute Voice Note",
    'Deeqa From The Wedding Committee', "Hooyo's Friend Who Asks When You're Getting Married", 'Abshir The Uber Driver', "Warsame Who Does 'Business'", 'Xaliimo The Gossip',
    'Macalin From Dugsi', 'The Uncle Who Calls Everyone Doctor', 'Guled The Unemployed Philosopher', 'Your Cousin From Minnesota', "Ali Who's 'Basically A Lawyer'",
    'Sahra And Her Five Sisters', "The Shaah That's Far Too Sweet", 'Cousin Who Snitched To Hooyo'] };
// Siham's extras: TikTok brainrot and the Ash Trevino vs Bri fights, mixed into the lines above.
const more = (k, mode, lines) => SENSEI[k][mode].push(...lines);
more('quip_win', 'proper', ['+1000 aura.', 'Let her cook!', 'Sigma accountant behaviour.', 'You just mogged that question.', 'W rizz on the ledger.']);
more('quip_win', 'east', ['+1000 aura, wallahi.', 'Let her cook, walaal!']);
more('quip_taunt', 'proper', ['-1000 aura.', "That answer is giving Ohio.", 'NPC behaviour.', 'Bro is COOKED.', 'That was messier than an Ash and Bri fight.', 'Delulu is not the solulu.']);
more('quip_taunt', 'east', ['Ash and Bri argue better than you answer, walaal.', "-1000 aura, ceeb!"]);
more('quip_hurt', 'proper', ['Fanum taxed my margins!', 'My aura!', "That's lowkey violating."]);
more('quip_low', 'proper', ["Okay okay, you've got rizz!", "Please, I'm just an NPC!"]);
more('shout_right', 'proper', ['+1000 AURA!', 'SIGMA!', 'COOKED IT!']);
more('shout_right', 'east', ['+1000 AURA!']);
more('shout_wrong', 'proper', ['-1000 AURA!', 'OHIO!', 'COOKED!', 'NPC!']);
more('shout_wrong', 'east', ['-1000 AURA!']);
BOSS_NAMES.proper.push('Ash Trevino (Mid-Rant)', 'Bri, Round 7', 'Skibidi Toilet Auditor', 'The Fanum Tax Collector', 'Sigma Grindset CFO', 'Ohio Final Boss', 'Mewing Accountant', 'Delulu Debtor');
BOSS_NAMES.east.push('Ash And Bri, Arguing Again', 'The Fanum Tax Collector');
const _makeLineup = makeLineup;
makeLineup = function () { const out = _makeLineup(), east = settings.sensei === 'east', names = shuffle([...BOSS_NAMES[east ? 'east' : 'proper']]); let i = 0;
  for (const b of out) b.name = b.lv === 'SHOGUN' ? (east ? 'Hooyo, Final Boss' : "Karen's Final Form") : names[i++ % names.length];
  return out; };
let bubble = null;
function quip(fromYou, text) { if (bubble) bubble.remove(); const b = document.createElement('div'); b.className = 'quip' + (fromYou ? '' : ' foe'); b.textContent = text;
  $('field').append(b); bubble = b;
  b.animate([{ transform: 'scale(.4)', opacity: 1 }, { transform: 'scale(1)', opacity: 1, offset: 0.06 }, { transform: 'scale(1)', opacity: 1, offset: 0.88 }, { transform: 'scale(1)', opacity: 0 }], { duration: 2700, easing: 'ease-out' }).onfinish = () => b.remove(); }
const _anim = anim;
anim = function (id, cls) { const e = $(id);
  if (id === 'you' && cls === 'lungeR') { e.animate([{ transform: 'none' }, { transform: 'translate(230px,-120px)', offset: 0.22 }, { transform: 'translate(230px,-120px)', offset: 0.6 }, { transform: 'none' }], { duration: 640, easing: 'ease-out' }); return; }
  if (id === 'foe' && cls === 'lungeL') { e.animate([{ transform: 'none' }, { transform: 'translate(-230px,170px)', offset: 0.24 }, { transform: 'translate(-230px,170px)', offset: 0.45 }, { transform: 'none' }], { duration: 580, easing: 'ease-in-out' }); return; }
  _anim(id, cls); };
mood = function (m, id = 'you') { const c = $(id); if (!c || !c._live) return;
  if (id !== 'you') { c._live.act(m); return; }
  if (m === 'happy') { c._live.act((session && session.combo >= 3) ? 'slash' : 'happy');
    setTimeout(() => { if (FX.knocked) quip(false, S('quip_low')); else if (Math.random() < 0.45) quip(true, S('quip_win')); else if (Math.random() < 0.5) quip(false, S('quip_hurt')); }, 450); }
  else if (m === 'sad') { c._live.act('sad'); if (Math.random() < 0.65) setTimeout(() => quip(false, S('quip_taunt')), 300); }
  else c._live.act(m); };

// ---------------------------------------------------------------- one clock for everything animated here
let last = 0;
function tick(ts) { const dt = last ? Math.min(0.05, (ts - last) / 1000) : 0; last = ts; const now = ts / 1000;
  if (document.visibilityState === 'visible') {
    for (const l of lives) if (l.c.isConnected && l.c.offsetParent !== null) { l.step(dt); l.draw(); }
    syncFoeHat(); drawDeco(now); }
  requestAnimationFrame(tick); }
requestAnimationFrame(tick);
applyFestive();
// The start-up code names every big banner after the app; the Chapter Book's own banner says what it is.
{ const b = document.querySelector('#book .banner'); if (b) b.textContent = 'CHAPTER BOOK'; }
})();
</script>
