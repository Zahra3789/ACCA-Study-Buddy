// ====================================================================== the lesson stories, set at Crafted Crisps
// The Apply-it stories, worked examples and story questions (chapters 1-13) were set at "Sisi Lemonade Ltd". Her
// call: set them at the pre-seen company instead. The words are swapped, not the sums - every number, table and
// answer stays exactly as it was, so all the workings still add up. People become the pre-seen's people (same
// he/she): Hana -> Samantha, Yuki -> Ellie, Kenji -> Ed, Mei -> Nicole, Uncle Taro -> Dean. Bottles of Classic and
// Yuzu Deluxe become bags of Sea Salt and Truffle & Rosemary; Mixing / Bottling become Cooking / Packing; $ -> H$.
(function () {
const e = EXAMS.find(x => x.id === 'SM'); if (!e) return;
// whole sentences that read oddly after a word-for-word swap, rewritten first (matched on the original text)
const SENT = [
  [/Sisi Lemonade Ltd now bottles two drinks, \[b\]Classic\[\/b\] and \[b\]Yuzu Deluxe\[\/b\], in a rented workshop behind the dojo\./g, 'Crafted Crisps makes two lines of crisps, [b]Sea Salt[/b] and [b]Truffle & Rosemary[/b], at its factory on the farm.'],
  [/There are two production departments, Mixing and Bottling, and a tiny Canteen where Yuki eats her noodles\./g, 'Here we follow two production departments, Cooking and Packing, and a service department, Facilities, that keeps the machines running.'],
  [/and a tiny Canteen where Yuki eats her noodles/g, 'and Facilities, which keeps the machines running'],
  [/the noodle bar/g, 'the deli'], [/The noodle bar/g, 'The deli'], [/noodle bar/g, 'deli'], [/noodle-bar/g, 'deli'],
  [/and the Canteen/g, 'and Facilities'], [/the Canteen/g, 'Facilities'],
  [/eats her noodles/g, 'takes her break'], [/noodles/g, 'lunch'],
  [/the Dojo Gate kiosk/g, 'the Farm Gate shop'], [/Dojo Gate kiosk/g, 'Farm Gate shop'], [/Dojo Gate/g, 'Farm Gate'],
  [/Market Square kiosk/g, 'Market Square shop'],
  [/Uncle Taro/g, 'Dean'], [/visiting from afar/g, 'the Managing Director'],
  [/Lemons, yuzu, sugar and glass bottles/g, 'Potatoes, truffle seasoning, oil and packaging'],
  [/fruit and sugar/g, 'potatoes and oil'],
  [/spiced syrup/g, 'spiced seasoning'],
];
// then word for word (longest first)
const WORD = [
  [/Sisi Lemonade Ltd's/g, "Crafted Crisps'"], [/Sisi Lemonade Ltd/g, 'Crafted Crisps'], [/Sisi's Lemonade Stand/g, 'Crafted Crisps'],
  [/Sisi's lemonade business/g, 'Crafted Crisps'], [/lemonade business/g, 'crisp business'], [/Lemonade Stand/g, 'Crafted Crisps'], [/Lemonade/g, 'Crafted Crisps'],
  [/a bottle of lemonade/g, 'a bag of crisps'], [/lemonade/g, 'crisps'],
  [/Yuzu Deluxe/g, 'Truffle & Rosemary'], [/\bYuzu\b/g, 'Truffle'], [/\byuzu\b/g, 'truffle'],
  [/\bClassic\b/g, 'Sea Salt'],
  [/\bBottling\b/g, 'Packing'], [/\bbottling\b/g, 'packing'], [/\bbottled\b/g, 'packed'], [/\bbottles\b/g, 'bags'], [/\bbottle\b/g, 'bag'],
  [/\bBottles\b/g, 'Bags'], [/\bBottle\b/g, 'Bag'], [/\bBottled\b/g, 'Packed'],
  [/\bMixing\b/g, 'Cooking'], [/\bCanteen\b/g, 'Facilities'], [/\bcanteen\b/g, 'facilities'],
  [/\bworkshop\b/g, 'factory'], [/\bWorkshop\b/g, 'Factory'],
  [/\bkiosks\b/g, 'farm shops'], [/\bkiosk\b/g, 'farm shop'], [/\bKiosk\b/g, 'Farm shop'],
  [/\bstall\b/g, 'shop'], [/\bstalls\b/g, 'shops'],
  [/\blemons\b/g, 'potatoes'], [/\bLemons\b/g, 'Potatoes'], [/\blemon\b/g, 'potato'], [/\bLemon\b/g, 'Potato'],
  [/\bsugar\b/g, 'oil'], [/\bSugar\b/g, 'Oil'], [/\bsyrup\b/g, 'seasoning'], [/\bSyrup\b/g, 'Seasoning'],
  [/\bfruit\b/g, 'potatoes'], [/\bFruit\b/g, 'Potatoes'], [/\bTruffle potatoes\b/g, 'Truffle seasoning'],
  [/\blitres\b/g, 'kg'], [/\blitre\b/g, 'kg'],
  [/\bcups\b/g, 'bags'], [/\bcup\b/g, 'bag'], [/\bCups\b/g, 'Bags'], [/\bCup\b/g, 'Bag'],
  [/\bdrinks\b/g, 'crisps'], [/\bthe drink\b/g, 'the crisps'], [/\bdrink\b/g, 'crisp'],
  [/\bthe dojo\b/g, 'the farm'], [/\bThe dojo\b/g, 'The farm'], [/\bdojo\b/g, 'farm'], [/\bDojo\b/g, 'Farm'],
  [/\bHana\b/g, 'Samantha'], [/\bYuki\b/g, 'Ellie'], [/\bKenji\b/g, 'Ed'], [/\bMei\b/g, 'Nicole'], [/\bTaro\b/g, 'Dean'],
  // money: "$1.50", "$ per bag", a lone "$" column heading
  [/(^|[^A-Za-z])\$(?=\s?[\d(])/g, '$1H$$'], [/(^|[\s(["])\$(?=$|[\s)\]".,;:])/g, '$1H$$'],
];
const fix = s => { for (const [a, b] of SENT) s = s.replace(a, b); for (const [a, b] of WORD) s = s.replace(a, b); return s; };
const walk = v => typeof v === 'string' ? fix(v) : Array.isArray(v) ? v.map(walk) : (v && typeof v === 'object') ? Object.fromEntries(Object.entries(v).map(([k, x]) => [k, k === 'type' || k === 'id' ? x : walk(x)])) : v;
for (const c of e.chapters) {
  if (c.id > 13) continue;   // the pre-seen chapter is already about Crafted Crisps
  c.lessons = walk(c.lessons); if (c.beats) c.beats = walk(c.beats); if (c.mtq) c.mtq = walk(c.mtq);
}
e.cards = e.cards.map(k => k.ch > 13 ? k : walk(k));
})();
