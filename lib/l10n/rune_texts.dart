import 'package:flutter/material.dart';
import '../models/rune.dart';
import 'app_localizations.dart';

/// Контент рун на языках приложения (fallback — русский).
///
/// Обращение к пользователю — на «ты», женский род (как в русском оригинале).
class RuneL10n {
  final String name;
  final String title;
  final String description;
  final String advice;
  final String past;
  final String future;

  const RuneL10n({
    required this.name,
    required this.title,
    required this.description,
    required this.advice,
    required this.past,
    required this.future,
  });
}

/// Ключ элемента руны — стабилен для цвета, подпись локализуется отдельно.
const Map<String, String> kRuneElementKey = {
  'fehu': 'fire',
  'uruz': 'earth',
  'thurisaz': 'fire',
  'ansuz': 'air',
  'raido': 'air',
  'kenaz': 'fire',
  'gebo': 'air',
  'wunjo': 'air',
  'hagalaz': 'water',
  'nauthiz': 'fire',
  'isa': 'water',
  'jera': 'earth',
  'eihwaz': 'earth',
  'perthro': 'water',
  'algiz': 'air',
  'sowilo': 'fire',
  'tiwaz': 'air',
  'berkana': 'earth',
  'ehwaz': 'earth',
  'mannaz': 'air',
  'laguz': 'water',
  'inguz': 'earth',
  'othala': 'earth',
  'dagaz': 'fire',
};

const Map<String, String> _elementL10nKey = {
  'fire': 'elementFire',
  'water': 'elementWater',
  'air': 'elementAir',
  'earth': 'elementEarth',
};

String runeElementLabel(String runeId, String languageCode) {
  final key = kRuneElementKey[runeId] ?? 'fire';
  return AppLocalizations.tr(languageCode, _elementL10nKey[key] ?? 'elementFire');
}

/// Локализованный контент руны. [rune] — базовая модель (русский fallback).
RuneL10n runeL10n(Rune rune, String languageCode) {
  final table = kRuneL10n[rune.id];
  if (table == null) {
    return RuneL10n(
      name: rune.name,
      title: rune.title,
      description: rune.description,
      advice: rune.advice,
      past: rune.predictionPast,
      future: rune.predictionFuture,
    );
  }
  final value = table[languageCode] ?? table['ru']!;
  return value;
}

String languageOf(BuildContext context) =>
    AppLocalizations.of(context).languageCode;

const Map<String, Map<String, RuneL10n>> kRuneL10n = {
  'fehu': {
    'ru': RuneL10n(
      name: 'Феху',
      title: 'Руна богатства',
      description:
          'Феху — руна достатка, имущества и исполнения желаний. Она говорит: то, к чему ты стремишься, уже рядом.',
      advice:
          'Будь щедрой с тем, что имеешь. Деньги любят движение — поделись или вложи.',
      past: 'Возможность обогатилась уже прошла мимо — ты её или заметила, или нет.',
      future: 'Встреча или сделка принесёт прибыль — будь начеку.',
    ),
    'en': RuneL10n(
      name: 'Fehu',
      title: 'Rune of Wealth',
      description:
          'Fehu is the rune of abundance, property and fulfilled wishes. It says: what you strive for is already near.',
      advice:
          'Be generous with what you have. Money loves movement — share it or invest it.',
      past: 'A chance to grow rich already passed you by — you noticed it or not.',
      future: 'A meeting or a deal will bring profit — stay alert.',
    ),
    'de': RuneL10n(
      name: 'Fehu',
      title: 'Runen des Reichtums',
      description:
          'Fehu ist die Rune des Wohlstands, des Besitzes und erfüllter Wünsche. Sie sagt: Wonach du strebst, ist schon nah.',
      advice:
          'Sei großzügig mit dem, was du hast. Geld liebt Bewegung — teile es oder investiere es.',
      past: 'Eine Chance auf Reichtum ist bereits an dir vorbeigegangen — du hast sie bemerkt oder nicht.',
      future: 'Eine Begegnung oder ein Geschäft bringt Gewinn — sei wachsam.',
    ),
    'es': RuneL10n(
      name: 'Fehu',
      title: 'Runa de la riqueza',
      description:
          'Fehu es la runa de la abundancia, la propiedad y los deseos cumplidos. Dice: lo que buscas ya está cerca.',
      advice:
          'Sé generosa con lo que tienes. Al dinero le gusta moverse — compártelo o inviértelo.',
      past: 'Una oportunidad de enriquecerte ya pasó de largo — la notaste o no.',
      future: 'Un encuentro o un trato traerá ganancias — estate atenta.',
    ),
    'fr': RuneL10n(
      name: 'Fehu',
      title: 'Rune de la richesse',
      description:
          'Fehu est la rune de l’abondance, des biens et des souhaits exaucés. Elle dit : ce que tu cherches est déjà proche.',
      advice:
          'Sois généreuse avec ce que tu as. L’argent aime bouger — partage-le ou investis-le.',
      past: 'Une chance de t’enrichir a déjà passé sans s’arrêter — tu l’as remarquée ou non.',
      future: 'Une rencontre ou une affaire rapportera du profit — reste attentive.',
    ),
  },
  'uruz': {
    'ru': RuneL10n(
      name: 'Уруз',
      title: 'Руна силы и мощи',
      description:
          'Уруз — руна первобытной силы, дикой коровы. Она пробуждает в тебе скрытую мощь и способность преодолевать.',
      advice: 'Действуй без колебаний. Сейчас не время для сомнений — сила на твоей стороне.',
      past: 'Испытание, которое ты прошла, закалило тебя сильнее, чем ты думаешь.',
      future: 'Событие потребует твёрдости — не сгибайся, ты выстоишь.',
    ),
    'en': RuneL10n(
      name: 'Uruz',
      title: 'Rune of Strength',
      description:
          'Uruz is the rune of primal strength, the aurochs. It awakens your hidden power and your ability to overcome.',
      advice: 'Act without hesitation. Now is not the time for doubt — strength is on your side.',
      past: 'The trial you went through has hardened you more than you think.',
      future: 'An event will demand firmness — do not bend, you will hold.',
    ),
    'de': RuneL10n(
      name: 'Uruz',
      title: 'Runen der Kraft',
      description:
          'Uruz ist die Rune der Urkraft, des Auerochsen. Sie weckt deine verborgene Macht und deine Fähigkeit, zu überwinden.',
      advice: 'Handle ohne Zögern. Jetzt ist nicht die Zeit für Zweifel — die Kraft ist auf deiner Seite.',
      past: 'Die Prüfung, die du durchstanden hast, hat dich stärker gemacht, als du denkst.',
      future: 'Ein Ereignis wird Härte verlangen — beug dich nicht, du wirst bestehen.',
    ),
    'es': RuneL10n(
      name: 'Uruz',
      title: 'Runa de la fuerza',
      description:
          'Uruz es la runa de la fuerza primordial, del uro. Despierta tu poder oculto y tu capacidad de superar obstáculos.',
      advice: 'Actúa sin dudar. Ahora no es momento de dudas — la fuerza está de tu lado.',
      past: 'La prueba que superaste te ha endurecido más de lo que crees.',
      future: 'Un acontecimiento exigirá firmeza — no te doblegues, resistirás.',
    ),
    'fr': RuneL10n(
      name: 'Uruz',
      title: 'Rune de la force',
      description:
          'Uruz est la rune de la force primordiale, de l’aurochs. Elle éveille ton pouvoir caché et ta capacité à surmonter.',
      advice: 'Agis sans hésiter. Ce n’est pas le moment de douter — la force est de ton côté.',
      past: 'L’épreuve que tu as traversée t’a trempée plus que tu ne le penses.',
      future: 'Un événement exigera de la fermeté — ne plie pas, tu tiendras.',
    ),
  },
  'thurisaz': {
    'ru': RuneL10n(
      name: 'Турисаз',
      title: 'Руна защиты',
      description:
          'Турисаз — руна шипов и молота. Она защищает, но и предупреждает: не руби с плеча.',
      advice: 'Держи оборону, но не нападай первой. Защищай то, что тебе дорого.',
      past: 'Конфликт или опасность обошла тебя стороной — защита сработала.',
      future: 'Возможна встреча с агрессией — держи щит наготове.',
    ),
    'en': RuneL10n(
      name: 'Thurisaz',
      title: 'Rune of Defense',
      description:
          'Thurisaz is the rune of thorns and hammer. It protects, but also warns: do not strike recklessly.',
      advice: 'Hold your ground, but do not strike first. Defend what is dear to you.',
      past: 'A conflict or danger passed you by — the protection worked.',
      future: 'An encounter with aggression is possible — keep your shield ready.',
    ),
    'de': RuneL10n(
      name: 'Thurisaz',
      title: 'Runen des Schutzes',
      description:
          'Thurisaz ist die Rune der Dornen und des Hammers. Sie schützt, warnt aber auch: schlage nicht wahllos um dich.',
      advice: 'Halte die Stellung, aber greife nicht zuerst an. Verteidige, was dir teuer ist.',
      past: 'Ein Konflikt oder eine Gefahr ist an dir vorbeigegangen — der Schutz hat gewirkt.',
      future: 'Eine Begegnung mit Aggression ist möglich — halte den Schild bereit.',
    ),
    'es': RuneL10n(
      name: 'Thurisaz',
      title: 'Runa de la defensa',
      description:
          'Thurisaz es la runa de las espinas y el martillo. Protege, pero también advierte: no golpees a ciegas.',
      advice: 'Mantén tu posición, pero no ataques primero. Defiende lo que te importa.',
      past: 'Un conflicto o un peligro te pasó de largo — la protección funcionó.',
      future: 'Es posible un encuentro con agresión — mantén el escudo listo.',
    ),
    'fr': RuneL10n(
      name: 'Thurisaz',
      title: 'Rune de la protection',
      description:
          'Thurisaz est la rune des épines et du marteau. Elle protège, mais avertit aussi : ne frappe pas aveuglément.',
      advice: 'Tiens ta position, mais n’attaque pas en première. Défends ce qui te tient à cœur.',
      past: 'Un conflit ou un danger t’a contournée — la protection a fonctionné.',
      future: 'Une rencontre avec l’agressivité est possible — garde le bouclier prêt.',
    ),
  },
  'ansuz': {
    'ru': RuneL10n(
      name: 'Ансуз',
      title: 'Руна мудрости',
      description:
          'Ансуз — руна Одина, бога мудрости и поэзии. Она приносит вдохновение, ясность мысли и дар речи.',
      advice: 'Прислушайся к совету мудрой женщины. Слова сегодня имеют особую силу.',
      past: 'Важные слова были сказаны — они изменили твой путь.',
      future: 'Совет или известие придёт не оттуда, откуда ждёшь — прими его.',
    ),
    'en': RuneL10n(
      name: 'Ansuz',
      title: 'Rune of Wisdom',
      description:
          'Ansuz is the rune of Odin, god of wisdom and poetry. It brings inspiration, clarity of thought and the gift of speech.',
      advice: 'Listen to the counsel of a wise woman. Words carry special power today.',
      past: 'Important words were spoken — they changed your path.',
      future: 'Advice or news will come from where you least expect it — accept it.',
    ),
    'de': RuneL10n(
      name: 'Ansuz',
      title: 'Runen der Weisheit',
      description:
          'Ansuz ist die Rune Odins, des Gottes der Weisheit und Poesie. Sie bringt Inspiration, klare Gedanken und das Geschenk der Rede.',
      advice: 'Höre auf den Rat einer weisen Frau. Worte haben heute besondere Kraft.',
      past: 'Wichtige Worte wurden gesprochen — sie haben deinen Weg verändert.',
      future: 'Ein Rat oder eine Nachricht kommt von dort, wo du sie nicht erwartest — nimm sie an.',
    ),
    'es': RuneL10n(
      name: 'Ansuz',
      title: 'Runa de la sabiduría',
      description:
          'Ansuz es la runa de Odín, dios de la sabiduría y la poesía. Trae inspiración, claridad mental y el don de la palabra.',
      advice: 'Escucha el consejo de una mujer sabia. Las palabras tienen hoy un poder especial.',
      past: 'Se dijeron palabras importantes — cambiaron tu camino.',
      future: 'Un consejo o una noticia llegará de donde menos lo esperas — acéptalo.',
    ),
    'fr': RuneL10n(
      name: 'Ansuz',
      title: 'Rune de la sagesse',
      description:
          'Ansuz est la rune d’Odin, dieu de la sagesse et de la poésie. Elle apporte l’inspiration, la clarté d’esprit et le don de la parole.',
      advice: 'Écoute le conseil d’une femme sage. Les mots ont un pouvoir spécial aujourd’hui.',
      past: 'Des paroles importantes ont été dites — elles ont changé ton chemin.',
      future: 'Un conseil ou une nouvelle viendra d’où tu ne l’attends pas — accueille-le.',
    ),
  },
  'raido': {
    'ru': RuneL10n(
      name: 'Райдо',
      title: 'Руна пути',
      description:
          'Райдо — руна дороги, путешествий и ритма жизни. Всё движется своим чередом.',
      advice: 'Отправляйся в путь. Движение принесёт тебе ответы, которых ты ждёшь.',
      past: 'Поездка или переход уже открыл тебе глаза на что-то важное.',
      future: 'Дорога зовёт — даже короткая поездка изменит перспективу.',
    ),
    'en': RuneL10n(
      name: 'Raidho',
      title: 'Rune of the Road',
      description:
          'Raidho is the rune of roads, journeys and the rhythm of life. Everything moves in its own time.',
      advice: 'Set out on the road. Movement will bring the answers you are waiting for.',
      past: 'A trip or a transition has already opened your eyes to something important.',
      future: 'The road is calling — even a short journey will change your perspective.',
    ),
    'de': RuneL10n(
      name: 'Raidho',
      title: 'Runen des Weges',
      description:
          'Raidho ist die Rune des Weges, der Reisen und des Lebensrhythmus. Alles bewegt sich zu seiner Zeit.',
      advice: 'Mach dich auf den Weg. Die Bewegung bringt die Antworten, auf die du wartest.',
      past: 'Eine Reise oder ein Übergang hat dir bereits die Augen für etwas Wichtiges geöffnet.',
      future: 'Der Weg ruft — selbst eine kurze Reise verändert die Perspektive.',
    ),
    'es': RuneL10n(
      name: 'Raidho',
      title: 'Runa del camino',
      description:
          'Raidho es la runa de los caminos, los viajes y el ritmo de la vida. Todo se mueve a su debido tiempo.',
      advice: 'Emprende el camino. El movimiento te traerá las respuestas que esperas.',
      past: 'Un viaje o una transición ya te abrieron los ojos ante algo importante.',
      future: 'El camino te llama — incluso un viaje corto cambiará tu perspectiva.',
    ),
    'fr': RuneL10n(
      name: 'Raidho',
      title: 'Rune du chemin',
      description:
          'Raidho est la rune des routes, des voyages et du rythme de la vie. Tout bouge en son temps.',
      advice: 'Pars en route. Le mouvement t’apportera les réponses que tu attends.',
      past: 'Un voyage ou un passage t’a déjà ouvert les yeux sur quelque chose d’important.',
      future: 'La route t’appelle — même un court voyage changera ta perspective.',
    ),
  },
  'kenaz': {
    'ru': RuneL10n(
      name: 'Кеназ',
      title: 'Руна огня знаний',
      description:
          'Кеназ — руна факела, озарения и творческого огня. Она освещает тёмные углы и дарит ясность.',
      advice: 'Зажги свой внутренний свет. Твоё творчество и интуиция — главные союзницы.',
      past: 'Прозрение пришло — ты увидела то, что скрывалось в тени.',
      future: 'Знание или идея вспыхнет внезапно — будь готова записать.',
    ),
    'en': RuneL10n(
      name: 'Kenaz',
      title: 'Rune of the Torch',
      description:
          'Kenaz is the rune of the torch, revelation and creative fire. It lights the dark corners and grants clarity.',
      advice: 'Light your inner fire. Your creativity and intuition are your closest allies.',
      past: 'Insight came — you saw what was hiding in the shadow.',
      future: 'Knowledge or an idea will flare up suddenly — be ready to write it down.',
    ),
    'de': RuneL10n(
      name: 'Kenaz',
      title: 'Runen des Wissensfeuers',
      description:
          'Kenaz ist die Rune der Fackel, der Erleuchtung und des schöpferischen Feuers. Sie erhellt dunkle Ecken und schenkt Klarheit.',
      advice: 'Entzünde dein inneres Licht. Deine Kreativität und Intuition sind deine wichtigsten Verbündeten.',
      past: 'Erleuchtung kam — du hast gesehen, was sich im Schatten verbarg.',
      future: 'Wissen oder eine Idee wird plötzlich aufflammen — sei bereit, sie aufzuschreiben.',
    ),
    'es': RuneL10n(
      name: 'Kenaz',
      title: 'Runa del fuego del saber',
      description:
          'Kenaz es la runa de la antorcha, la revelación y el fuego creativo. Ilumina los rincones oscuros y da claridad.',
      advice: 'Enciende tu luz interior. Tu creatividad y tu intuición son tus mejores aliadas.',
      past: 'Llegó la revelación — viste lo que se escondía en la sombra.',
      future: 'Un saber o una idea estallará de repente — estate lista para anotarla.',
    ),
    'fr': RuneL10n(
      name: 'Kenaz',
      title: 'Rune du feu du savoir',
      description:
          'Kenaz est la rune de la torche, de la révélation et du feu créateur. Elle éclaire les coins sombres et donne la clarté.',
      advice: 'Allume ta lumière intérieure. Ta créativité et ton intuition sont tes meilleures alliées.',
      past: 'La révélation est venue — tu as vu ce qui se cachait dans l’ombre.',
      future: 'Un savoir ou une idée s’embrasera soudain — sois prête à la noter.',
    ),
  },
  'gebo': {
    'ru': RuneL10n(
      name: 'Гебо',
      title: 'Руна дара',
      description:
          'Гебо — руна партнёрства, равного обмена и щедрости. Дар требует ответного дара.',
      advice: 'Прими то, что тебе предлагают, но не забудь отблагодарить. Равновесие — твой ключ.',
      past: 'Обмен или дар уже состоялся — он изменил баланс в твоей жизни.',
      future: 'Предложение о сотрудничестве поступит — взвесь, но не отказывай сразу.',
    ),
    'en': RuneL10n(
      name: 'Gebo',
      title: 'Rune of the Gift',
      description:
          'Gebo is the rune of partnership, fair exchange and generosity. A gift asks for a gift in return.',
      advice: 'Accept what is offered, but do not forget to give thanks. Balance is your key.',
      past: 'An exchange or a gift has already taken place — it shifted the balance of your life.',
      future: 'A partnership offer will arrive — weigh it, but do not refuse at once.',
    ),
    'de': RuneL10n(
      name: 'Gebo',
      title: 'Runen der Gabe',
      description:
          'Gebo ist die Rune der Partnerschaft, des fairen Austauschs und der Großzügigkeit. Eine Gabe verlangt eine Gabe im Gegenzug.',
      advice: 'Nimm an, was dir geboten wird, aber vergiss nicht, Dank zu sagen. Ausgleich ist dein Schlüssel.',
      past: 'Ein Austausch oder eine Gabe hat bereits stattgefunden — er hat das Gleichgewicht deines Lebens verschoben.',
      future: 'Ein Partnerschaftsangebot wird eintreffen — wäge es ab, lehne aber nicht sofort ab.',
    ),
    'es': RuneL10n(
      name: 'Gebo',
      title: 'Runa del don',
      description:
          'Gebo es la runa de la colaboración, el intercambio justo y la generosidad. Un don pide un don a cambio.',
      advice: 'Acepta lo que te ofrecen, pero no olvides agradecer. El equilibrio es tu clave.',
      past: 'Un intercambio o un don ya tuvo lugar — cambió el equilibrio de tu vida.',
      future: 'Recibirás una oferta de colaboración — valórala, pero no rechaces de entrada.',
    ),
    'fr': RuneL10n(
      name: 'Gebo',
      title: 'Rune du don',
      description:
          'Gebo est la rune du partenariat, de l’échange équitable et de la générosité. Un don appelle un don en retour.',
      advice: 'Accepte ce qu’on t’offre, mais n’oublie pas de remercier. L’équilibre est ta clé.',
      past: 'Un échange ou un don a déjà eu lieu — il a fait basculer l’équilibre de ta vie.',
      future: 'Une offre de collaboration arrivera — pèse-la, mais ne refuse pas sur-le-champ.',
    ),
  },
  'wunjo': {
    'ru': RuneL10n(
      name: 'Вуньо',
      title: 'Руна радости',
      description:
          'Вуньо — руна счастья, гармонии и завершения. Тёмная полоса заканчивается.',
      advice: 'Позволь себе радоваться. Ты заслужила этот миг покоя и удовлетворения.',
      past: 'Счастливый момент уже случился — он был знаком, ты это чувствовала.',
      future: 'Радость придёт оттуда, откуда не ждёшь — прими её с распростёртыми объятиями.',
    ),
    'en': RuneL10n(
      name: 'Wunjo',
      title: 'Rune of Joy',
      description:
          'Wunjo is the rune of happiness, harmony and completion. The dark streak is ending.',
      advice: 'Allow yourself to rejoice. You have earned this moment of peace and contentment.',
      past: 'A happy moment has already happened — it was a sign, and you felt it.',
      future: 'Joy will come from where you least expect it — receive it with open arms.',
    ),
    'de': RuneL10n(
      name: 'Wunjo',
      title: 'Runen der Freude',
      description:
          'Wunjo ist die Rune des Glücks, der Harmonie und des Abschlusses. Die dunkle Zeit geht zu Ende.',
      advice: 'Gönn dir die Freude. Du hast diesen Moment des Friedens und der Zufriedenheit verdient.',
      past: 'Ein glücklicher Moment ist schon geschehen — er war ein Zeichen, du hast es gespürt.',
      future: 'Freude kommt von dort, wo du sie nicht erwartest — nimm sie mit offenen Armen an.',
    ),
    'es': RuneL10n(
      name: 'Wunjo',
      title: 'Runa de la alegría',
      description:
          'Wunjo es la runa de la felicidad, la armonía y la consumación. La racha oscura está terminando.',
      advice: 'Permítete alegrarte. Te has ganado este instante de calma y satisfacción.',
      past: 'Un momento feliz ya ocurrió — fue una señal, y lo sentiste.',
      future: 'La alegría llegará de donde no la esperas — recíbela con los brazos abiertos.',
    ),
    'fr': RuneL10n(
      name: 'Wunjo',
      title: 'Rune de la joie',
      description:
          'Wunjo est la rune du bonheur, de l’harmonie et de l’accomplissement. La passe sombre se termine.',
      advice: 'Permets-toi de te réjouir. Tu as mérité cet instant de paix et de satisfaction.',
      past: 'Un moment heureux a déjà eu lieu — c’était un signe, tu l’as senti.',
      future: 'La joie viendra d’où tu ne l’attends pas — accueille-la à bras ouverts.',
    ),
  },
  'hagalaz': {
    'ru': RuneL10n(
      name: 'Хагалаз',
      title: 'Руна разрушения',
      description:
          'Хагалаз — руна града, внезапных перемен и крушения старого. Но после бури всегда ясно.',
      advice: 'Не сопротивляйся переменам. То, что рушится, должно было уйти — отпусти.',
      past: 'Разрушение уже случилось — и освободило место для нового.',
      future: 'Внезапный удар судьбы грядёт — но он лишь сметает то, что не держалось.',
    ),
    'en': RuneL10n(
      name: 'Hagalaz',
      title: 'Rune of Disruption',
      description:
          'Hagalaz is the rune of hail, sudden change and the collapse of the old. But after the storm, clarity always comes.',
      advice: 'Do not resist change. What is falling apart was meant to go — let it.',
      past: 'The collapse has already happened — and it made room for the new.',
      future: 'A sudden blow of fate is coming — but it only sweeps away what could not hold.',
    ),
    'de': RuneL10n(
      name: 'Hagalaz',
      title: 'Runen der Zerstörung',
      description:
          'Hagalaz ist die Rune des Hagels, plötzlicher Veränderungen und des Zusammenbruchs des Alten. Aber nach dem Sturm kommt immer Klarheit.',
      advice: 'Widerstehe den Veränderungen nicht. Was zerfällt, sollte gehen — lass es los.',
      past: 'Der Zusammenbruch ist bereits geschehen — und hat Platz für Neues geschaffen.',
      future: 'Ein plötzlicher Schicksalsschlag kommt — aber er fegt nur weg, was nicht hielt.',
    ),
    'es': RuneL10n(
      name: 'Hagalaz',
      title: 'Runa de la ruptura',
      description:
          'Hagalaz es la runa del granizo, el cambio repentino y la caída de lo viejo. Pero después de la tormenta siempre llega la claridad.',
      advice: 'No te resistas al cambio. Lo que se desmorona tenía que irse — suéltalo.',
      past: 'La ruptura ya ocurrió — y dejó sitio para lo nuevo.',
      future: 'Un golpe repentino del destino se acerca — pero solo barre lo que no resistía.',
    ),
    'fr': RuneL10n(
      name: 'Hagalaz',
      title: 'Rune de la rupture',
      description:
          'Hagalaz est la rune de la grêle, du changement soudain et de l’effondrement de l’ancien. Mais après la tempête vient toujours la clarté.',
      advice: 'Ne résiste pas au changement. Ce qui s’effondre devait partir — laisse-le.',
      past: 'L’effondrement a déjà eu lieu — il a libéré la place pour le nouveau.',
      future: 'Un coup du destin soudain approche — mais il ne balaie que ce qui ne tenait plus.',
    ),
  },
  'nauthiz': {
    'ru': RuneL10n(
      name: 'Наутиз',
      title: 'Руна нужды',
      description:
          'Наутиз — руна ограничений и терпения. Она учит: нужда — мать изобретательности.',
      advice: 'Прими ограничения как урок. Именно в стеснённых обстоятельствах рождается твоя сила.',
      past: 'Нехватка или задержка уже научила тебя терпению — урок усвоен.',
      future: 'Ограничение встретится на пути — обойди его, а не ломай головой.',
    ),
    'en': RuneL10n(
      name: 'Nauthiz',
      title: 'Rune of Need',
      description:
          'Nauthiz is the rune of limitations and patience. It teaches: need is the mother of invention.',
      advice: 'Accept the limits as a lesson. Your strength is born in tight circumstances.',
      past: 'A shortage or a delay has already taught you patience — the lesson is learned.',
      future: 'A limitation will appear on your path — go around it instead of ramming it.',
    ),
    'de': RuneL10n(
      name: 'Nauthiz',
      title: 'Runen der Not',
      description:
          'Nauthiz ist die Rune der Begrenzungen und der Geduld. Sie lehrt: Not ist die Mutter der Erfindung.',
      advice: 'Nimm die Grenzen als Lektion an. Deine Kraft entsteht in beengten Verhältnissen.',
      past: 'Mangel oder Verzögerung haben dir bereits Geduld gelehrt — die Lektion ist gelernt.',
      future: 'Eine Begrenzung wird dir begegnen — umgehe sie, statt mit dem Kopf dagegenzurennen.',
    ),
    'es': RuneL10n(
      name: 'Nauthiz',
      title: 'Runa de la necesidad',
      description:
          'Nauthiz es la runa de las limitaciones y la paciencia. Enseña: la necesidad es la madre del ingenio.',
      advice: 'Acepta los límites como lección. Tu fuerza nace en las circunstancias estrechas.',
      past: 'La escasez o la demora ya te enseñaron paciencia — lección aprendida.',
      future: 'Una limitación aparecerá en tu camino — rodéala en vez de estrellarte contra ella.',
    ),
    'fr': RuneL10n(
      name: 'Nauthiz',
      title: 'Rune du besoin',
      description:
          'Nauthiz est la rune des limites et de la patience. Elle enseigne : le besoin est la mère de l’invention.',
      advice: 'Accepte les limites comme une leçon. Ta force naît dans l’étroit.',
      past: 'Le manque ou le délai t’a déjà appris la patience — la leçon est apprise.',
      future: 'Une limite croisera ton chemin — contourne-la au lieu de te cogner la tête.',
    ),
  },
  'isa': {
    'ru': RuneL10n(
      name: 'Иса',
      title: 'Руна льда',
      description:
          'Иса — руна остановки, заморозки и кристальной ясности. Время замереть и осмотреться.',
      advice: 'Не торопись. Пауза — не поражение, а твоя подготовка к новому рывку.',
      past: 'Застой, который ты пережила, дал время подумать — и это спасло.',
      future: 'Ситуация замрёт — не пытайся тронуть лёд руками, жди весны.',
    ),
    'en': RuneL10n(
      name: 'Isa',
      title: 'Rune of Ice',
      description:
          'Isa is the rune of stillness, freezing and crystal clarity. A time to stand still and look around.',
      advice: 'Do not hurry. A pause is not defeat — it is your preparation for the next surge.',
      past: 'The standstill you lived through gave you time to think — and it saved you.',
      future: 'The situation will freeze — do not touch the ice with bare hands; wait for spring.',
    ),
    'de': RuneL10n(
      name: 'Isa',
      title: 'Runen des Eises',
      description:
          'Isa ist die Rune der Stille, des Gefrierens und der klaren Kristallheit. Zeit, stillzustehen und umzusehen.',
      advice: 'Beeil dich nicht. Eine Pause ist keine Niederlage, sondern deine Vorbereitung auf den nächsten Sprint.',
      past: 'Der Stillstand, den du durchlebt hast, gab dir Zeit zum Nachdenken — und das hat gerettet.',
      future: 'Die Situation wird erstarren — fass das Eis nicht mit bloßen Händen an, warte auf den Frühling.',
    ),
    'es': RuneL10n(
      name: 'Isa',
      title: 'Runa del hielo',
      description:
          'Isa es la runa de la detención, la congelación y la claridad cristalina. Es hora de quedarse quieta y mirar.',
      advice: 'No te apresures. La pausa no es una derrota, es tu preparación para el próximo impulso.',
      past: 'El estancamiento que viviste te dio tiempo para pensar — y eso te salvó.',
      future: 'La situación se congelará — no toques el hielo con las manos desnudas, espera la primavera.',
    ),
    'fr': RuneL10n(
      name: 'Isa',
      title: 'Rune de la glace',
      description:
          'Isa est la rune de l’arrêt, du gel et de la clarté cristalline. Le moment de s’immobiliser et de regarder.',
      advice: 'Ne te presse pas. La pause n’est pas une défaite — c’est ta préparation au prochain élan.',
      past: 'L’immobilisme que tu as traversé t’a donné le temps de réfléchir — et cela t’a sauvée.',
      future: 'La situation va geler — ne touche pas la glace à mains nues, attends le printemps.',
    ),
  },
  'jera': {
    'ru': RuneL10n(
      name: 'Йера',
      title: 'Руна урожая',
      description:
          'Йера — руна цикла, урожая и заслуженной награды. Что посеяла — то и пожнёшь.',
      advice: 'Твои усилия не напрасны. Урожай близок — продолжай в том же духе.',
      past: 'Ты уже пожала плоды прошлых трудов — они были сладкими или горькими?',
      future: 'Жатва близка — готовься собирать то, что сеяла.',
    ),
    'en': RuneL10n(
      name: 'Jera',
      title: 'Rune of Harvest',
      description:
          'Jera is the rune of cycles, harvest and earned reward. You reap what you sow.',
      advice: 'Your efforts are not in vain. The harvest is near — keep going as you are.',
      past: 'You have already reaped the fruit of past labors — was it sweet or bitter?',
      future: 'The harvest is near — get ready to gather what you sowed.',
    ),
    'de': RuneL10n(
      name: 'Jera',
      title: 'Runen der Ernte',
      description:
          'Jera ist die Rune des Zyklus, der Ernte und des verdienten Lohns. Was du säst, das erntest du.',
      advice: 'Deine Mühen sind nicht umsonst. Die Ernte ist nah — mach weiter so.',
      past: 'Du hast bereits die Früchte vergangener Arbeit geerntet — waren sie süß oder bitter?',
      future: 'Die Ernte ist nah — bereite dich darauf vor, einzusammeln, was du gesät hast.',
    ),
    'es': RuneL10n(
      name: 'Jera',
      title: 'Runa de la cosecha',
      description:
          'Jera es la runa del ciclo, la cosecha y la recompensa merecida. Cosechas lo que siembras.',
      advice: 'Tus esfuerzos no son en vano. La cosecha está cerca — sigue así.',
      past: 'Ya cosechaste los frutos de tus trabajos pasados — ¿eran dulces o amargos?',
      future: 'La cosecha se acerca — prepárate para recoger lo que sembraste.',
    ),
    'fr': RuneL10n(
      name: 'Jera',
      title: 'Rune de la moisson',
      description:
          'Jera est la rune du cycle, de la moisson et de la récompense méritée. Tu récoltes ce que tu sèmes.',
      advice: 'Tes efforts ne sont pas vains. La moisson est proche — continue ainsi.',
      past: 'Tu as déjà récolté les fruits de tes labeurs passés — étaient-ils doux ou amers ?',
      future: 'La moisson approche — prépare-toi à rassembler ce que tu as semé.',
    ),
  },
  'eihwaz': {
    'ru': RuneL10n(
      name: 'Эйваз',
      title: 'Руна тиса',
      description:
          'Эйваз — руна мирового древа, связи миров и внутренней трансформации.',
      advice: 'Доверься процессу. Ты проходишь важную внутреннюю трансформацию — не мешай себе.',
      past: 'Трансформация уже произошла — ты уже не та, что была вчера.',
      future: 'Переломный момент наступит — доверься, он ведёт к лучшему.',
    ),
    'en': RuneL10n(
      name: 'Eihwaz',
      title: 'Rune of the Yew',
      description:
          'Eihwaz is the rune of the world tree, the link between worlds and inner transformation.',
      advice: 'Trust the process. You are going through an important inner transformation — do not hinder yourself.',
      past: 'The transformation has already happened — you are no longer who you were yesterday.',
      future: 'A turning point will come — trust it, it leads to something better.',
    ),
    'de': RuneL10n(
      name: 'Eihwaz',
      title: 'Runen der Eibe',
      description:
          'Eihwaz ist die Rune der Weltesche, der Verbindung der Welten und der inneren Transformation.',
      advice: 'Vertraue dem Prozess. Du durchläufst eine wichtige innere Transformation — steh dir nicht im Weg.',
      past: 'Die Transformation ist bereits geschehen — du bist nicht mehr die von gestern.',
      future: 'Ein Wendepunkt wird kommen — vertraue, er führt zu Besserem.',
    ),
    'es': RuneL10n(
      name: 'Eihwaz',
      title: 'Runa del tejo',
      description:
          'Eihwaz es la runa del árbol del mundo, el vínculo entre mundos y la transformación interior.',
      advice: 'Confía en el proceso. Estás atravesando una transformación interior importante — no te estorbes.',
      past: 'La transformación ya ocurrió — ya no eres la de ayer.',
      future: 'Llegará un punto de inflexión — confía, conduce a algo mejor.',
    ),
    'fr': RuneL10n(
      name: 'Eihwaz',
      title: 'Rune de l’if',
      description:
          'Eihwaz est la rune de l’arbre du monde, du lien entre les mondes et de la transformation intérieure.',
      advice: 'Fais confiance au processus. Tu traverses une transformation intérieure importante — ne te gêne pas.',
      past: 'La transformation a déjà eu lieu — tu n’es plus celle d’hier.',
      future: 'Un tournant viendra — fais-lui confiance, il mène vers le mieux.',
    ),
  },
  'perthro': {
    'ru': RuneL10n(
      name: 'Перт',
      title: 'Руна тайны',
      description:
          'Перт — руна игральных костей, судьбы и скрытого знания. Тайное скоро станет явным.',
      advice: 'Доверься судьбе. Не всё нужно контролировать — иногда лучший выбор отпустить.',
      past: 'Случайность, которая с тобой случилась, была не случайна — судьба подмигнула.',
      future: 'Сюрприз ждёт за поворотом — откройся неизвестному.',
    ),
    'en': RuneL10n(
      name: 'Perthro',
      title: 'Rune of Mystery',
      description:
          'Perthro is the rune of dice, fate and hidden knowledge. The secret will soon become clear.',
      advice: 'Trust fate. Not everything needs to be controlled — sometimes the best choice is to let go.',
      past: 'The coincidence that happened to you was no coincidence — fate winked at you.',
      future: 'A surprise waits around the corner — open yourself to the unknown.',
    ),
    'de': RuneL10n(
      name: 'Perthro',
      title: 'Runen des Geheimnisses',
      description:
          'Perthro ist die Rune des Würfels, des Schicksals und des verborgenen Wissens. Das Geheime wird bald offenbar.',
      advice: 'Vertraue dem Schicksal. Nicht alles muss kontrolliert werden — manchmal ist Loslassen die beste Wahl.',
      past: 'Der Zufall, der dir widerfuhr, war kein Zufall — das Schicksal hat zugezwinkert.',
      future: 'Eine Überraschung wartet hinter der Ecke — öffne dich dem Unbekannten.',
    ),
    'es': RuneL10n(
      name: 'Perthro',
      title: 'Runa del misterio',
      description:
          'Perthro es la runa de los dados, el destino y el conocimiento oculto. Lo secreto pronto se revelará.',
      advice: 'Confía en el destino. No todo hay que controlarlo — a veces la mejor opción es soltar.',
      past: 'La casualidad que te ocurrió no fue casualidad — el destino te guiñó un ojo.',
      future: 'Te espera una sorpresa a la vuelta — ábrete a lo desconocido.',
    ),
    'fr': RuneL10n(
      name: 'Perthro',
      title: 'Rune du mystère',
      description:
          'Perthro est la rune des dés, du destin et du savoir caché. Le secret deviendra bientôt évident.',
      advice: 'Fais confiance au destin. Tout n’a pas besoin d’être contrôlé — parfois le meilleur choix est de lâcher prise.',
      past: 'Le hasard qui t’est arrivé n’en était pas — le destin t’a fait un clin d’œil.',
      future: 'Une surprise t’attend au tournant — ouvre-toi à l’inconnu.',
    ),
  },
  'algiz': {
    'ru': RuneL10n(
      name: 'Альгиз',
      title: 'Руна защиты',
      description:
          'Альгиз — руна лося, защиты высших сил и связи с духовным миром.',
      advice: 'Ты под защитой. Доверься своей интуиции — она не подведёт.',
      past: 'Опасность прошла мимо — защитный знак сработал, даже если ты его не видела.',
      future: 'Угроза на горизонте — но щит уже поднят, ты в безопасности.',
    ),
    'en': RuneL10n(
      name: 'Algiz',
      title: 'Rune of Protection',
      description:
          'Algiz is the rune of the elk, protection by higher powers and connection with the spirit world.',
      advice: 'You are protected. Trust your intuition — it will not fail you.',
      past: 'Danger passed you by — the protective sign worked, even if you never saw it.',
      future: 'A threat is on the horizon — but the shield is already raised, you are safe.',
    ),
    'de': RuneL10n(
      name: 'Algiz',
      title: 'Runen des Schutzes',
      description:
          'Algiz ist die Rune des Elchs, des Schutzes durch höhere Mächte und der Verbindung mit der Geisterwelt.',
      advice: 'Du stehst unter Schutz. Vertraue deiner Intuition — sie wird dich nicht im Stich lassen.',
      past: 'Eine Gefahr ist an dir vorbeigegangen — das Schutzzeichen wirkte, auch wenn du es nicht gesehen hast.',
      future: 'Eine Drohung liegt am Horizont — aber das Schild ist erhoben, du bist sicher.',
    ),
    'es': RuneL10n(
      name: 'Algiz',
      title: 'Runa de la protección',
      description:
          'Algiz es la runa del alce, la protección de los poderes superiores y la conexión con el mundo espiritual.',
      advice: 'Estás protegida. Confía en tu intuición — no te fallará.',
      past: 'El peligro pasó de largo — el signo protector funcionó, aunque no lo vieras.',
      future: 'Hay una amenaza en el horizonte — pero el escudo ya está en alto, estás a salvo.',
    ),
    'fr': RuneL10n(
      name: 'Algiz',
      title: 'Rune de la protection',
      description:
          'Algiz est la rune de l’élan, de la protection des forces supérieures et du lien avec le monde spirituel.',
      advice: 'Tu es protégée. Fais confiance à ton intuition — elle ne te lâchera pas.',
      past: 'Le danger t’a contournée — le signe protecteur a fonctionné, même si tu ne l’as pas vu.',
      future: 'Une menace est à l’horizon — mais le bouclier est levé, tu es en sécurité.',
    ),
  },
  'sowilo': {
    'ru': RuneL10n(
      name: 'Совило',
      title: 'Руна солнца',
      description:
          'Совило — руна победы, солнечного света и неудержимой энергии жизни.',
      advice: 'Действуй смело. Солнце освещает твой путь — сомнения отступают.',
      past: 'Победа уже одержана — даже если ты ещё не заметила.',
      future: 'Успех неизбежен — двигайся к цели, светит солнце.',
    ),
    'en': RuneL10n(
      name: 'Sowilo',
      title: 'Rune of the Sun',
      description:
          'Sowilo is the rune of victory, sunlight and unstoppable life energy.',
      advice: 'Act boldly. The sun lights your path — doubts fall back.',
      past: 'Victory has already been won — even if you have not noticed yet.',
      future: 'Success is inevitable — move toward your goal, the sun is shining.',
    ),
    'de': RuneL10n(
      name: 'Sowilo',
      title: 'Runen der Sonne',
      description:
          'Sowilo ist die Rune des Sieges, des Sonnenlichts und der unaufhaltsamen Lebenskraft.',
      advice: 'Handle mutig. Die Sonne erhellt deinen Weg — Zweifel weichen zurück.',
      past: 'Der Sieg ist bereits errungen — auch wenn du es noch nicht bemerkt hast.',
      future: 'Der Erfolg ist unvermeidlich — beweg dich auf dein Ziel zu, die Sonne scheint.',
    ),
    'es': RuneL10n(
      name: 'Sowilo',
      title: 'Runa del sol',
      description:
          'Sowilo es la runa de la victoria, la luz del sol y la energía imparable de la vida.',
      advice: 'Actúa con audacia. El sol ilumina tu camino — las dudas retroceden.',
      past: 'La victoria ya está ganada — aunque aún no lo hayas notado.',
      future: 'El éxito es inevitable — avanza hacia tu meta, brilla el sol.',
    ),
    'fr': RuneL10n(
      name: 'Sowilo',
      title: 'Rune du soleil',
      description:
          'Sowilo est la rune de la victoire, de la lumière du soleil et de l’énergie de vie irrésistible.',
      advice: 'Agis avec audace. Le soleil éclaire ton chemin — les doutes reculent.',
      past: 'La victoire est déjà remportée — même si tu ne l’as pas encore remarqué.',
      future: 'Le succès est inévitable — avance vers ton but, le soleil brille.',
    ),
  },
  'tiwaz': {
    'ru': RuneL10n(
      name: 'Тейваз',
      title: 'Руна воина',
      description:
          'Тейваз — руна Тюра, бога справедливости и воинской чести. Она требует правды и мужества.',
      advice: 'Будь честна — прежде всего с собой. Справедливость восторжествует.',
      past: 'Ты уже совершила жертву ради правды — и не ошиблась.',
      future: 'Выбор между лёгким и правильным предстоит — выбери честь.',
    ),
    'en': RuneL10n(
      name: 'Tiwaz',
      title: 'Rune of the Warrior',
      description:
          'Tiwaz is the rune of Tyr, god of justice and warrior honor. It demands truth and courage.',
      advice: 'Be honest — above all with yourself. Justice will prevail.',
      past: 'You already made a sacrifice for the truth — and you were right.',
      future: 'A choice between the easy and the right awaits — choose honor.',
    ),
    'de': RuneL10n(
      name: 'Tiwaz',
      title: 'Runen des Kriegers',
      description:
          'Tiwaz ist die Rune Tyrs, des Gottes der Gerechtigkeit und der Kriegerehre. Sie verlangt Wahrheit und Mut.',
      advice: 'Sei ehrlich — vor allem dir selbst gegenüber. Die Gerechtigkeit wird siegen.',
      past: 'Du hast bereits ein Opfer für die Wahrheit gebracht — und hast nicht geirrt.',
      future: 'Eine Wahl zwischen dem Leichten und dem Richtigen steht bevor — wähle die Ehre.',
    ),
    'es': RuneL10n(
      name: 'Tiwaz',
      title: 'Runa de la guerrera',
      description:
          'Tiwaz es la runa de Tyr, dios de la justicia y el honor guerrero. Exige verdad y coraje.',
      advice: 'Sé honesta — ante todo contigo misma. La justicia prevalecerá.',
      past: 'Ya hiciste un sacrificio por la verdad — y no te equivocaste.',
      future: 'Te espera una elección entre lo fácil y lo correcto — elige el honor.',
    ),
    'fr': RuneL10n(
      name: 'Tiwaz',
      title: 'Rune de la guerrière',
      description:
          'Tiwaz est la rune de Tyr, dieu de la justice et de l’honneur du guerrier. Elle exige la vérité et le courage.',
      advice: 'Sois honnête — avant tout avec toi-même. La justice triomphera.',
      past: 'Tu as déjà fait un sacrifice pour la vérité — et tu n’as pas eu tort.',
      future: 'Un choix entre le facile et le juste t’attend — choisis l’honneur.',
    ),
  },
  'berkana': {
    'ru': RuneL10n(
      name: 'Беркана',
      title: 'Руна роста',
      description:
          'Беркана — руна берёзы, женской силы, плодородия и нового начала.',
      advice: 'Позволь себе расти. Новые начинания сейчас особенно благоприятны для тебя.',
      past: 'Начало, которое ты запустила, уже дало первые ростки.',
      future: 'Новое начинание принесёт плоды — сейчас благоприятное время.',
    ),
    'en': RuneL10n(
      name: 'Berkana',
      title: 'Rune of Growth',
      description:
          'Berkana is the rune of the birch, feminine power, fertility and new beginnings.',
      advice: 'Allow yourself to grow. New beginnings are especially favorable for you now.',
      past: 'The beginning you set in motion has already sprouted.',
      future: 'A new beginning will bear fruit — the time is favorable.',
    ),
    'de': RuneL10n(
      name: 'Berkana',
      title: 'Runen des Wachstums',
      description:
          'Berkana ist die Rune der Birke, der weiblichen Kraft, der Fruchtbarkeit und des Neubeginns.',
      advice: 'Erlaube dir zu wachsen. Neuanfänge sind jetzt besonders günstig für dich.',
      past: 'Der Anfang, den du in Gang gesetzt hast, hat bereits erste Triebe gebracht.',
      future: 'Ein Neuanfang wird Früchte tragen — die Zeit ist günstig.',
    ),
    'es': RuneL10n(
      name: 'Berkana',
      title: 'Runa del crecimiento',
      description:
          'Berkana es la runa del abedul, el poder femenino, la fertilidad y el nuevo comienzo.',
      advice: 'Permítete crecer. Los nuevos comienzos te son especialmente favorables ahora.',
      past: 'El comienzo que pusiste en marcha ya echó sus primeros brotes.',
      future: 'Un nuevo comienzo dará frutos — el momento es propicio.',
    ),
    'fr': RuneL10n(
      name: 'Berkana',
      title: 'Rune de la croissance',
      description:
          'Berkana est la rune du bouleau, du pouvoir féminin, de la fécondité et du nouveau départ.',
      advice: 'Permets-toi de grandir. Les nouveaux départs te sont particulièrement favorables.',
      past: 'Le départ que tu as lancé a déjà donné ses premières pousses.',
      future: 'Un nouveau départ portera ses fruits — le moment est propice.',
    ),
  },
  'ehwaz': {
    'ru': RuneL10n(
      name: 'Эваз',
      title: 'Руна движения',
      description:
          'Эваз — руна коня, прогресса и партнёрства. Движение вперёд неизбежно.',
      advice: 'Найди союзницу. Вместе вы добьётесь большего, чем поодиночке.',
      past: 'Союз или партнёрство уже дало результат — он укрепил тебя.',
      future: 'Встреча с важным человеком приближается — не упусти её.',
    ),
    'en': RuneL10n(
      name: 'Ehwaz',
      title: 'Rune of Movement',
      description:
          'Ehwaz is the rune of the horse, progress and partnership. Forward movement is inevitable.',
      advice: 'Find an ally. Together you will achieve more than alone.',
      past: 'An alliance or partnership has already paid off — it strengthened you.',
      future: 'A meeting with an important person is approaching — do not miss it.',
    ),
    'de': RuneL10n(
      name: 'Ehwaz',
      title: 'Runen der Bewegung',
      description:
          'Ehwaz ist die Rune des Pferdes, des Fortschritts und der Partnerschaft. Die Bewegung nach vorn ist unvermeidlich.',
      advice: 'Finde eine Verbündete. Gemeinsam erreicht ihr mehr als allein.',
      past: 'Ein Bündnis oder eine Partnerschaft hat sich bereits bezahlt gemacht — es hat dich gestärkt.',
      future: 'Ein Treffen mit einem wichtigen Menschen naht — verpass es nicht.',
    ),
    'es': RuneL10n(
      name: 'Ehwaz',
      title: 'Runa del movimiento',
      description:
          'Ehwaz es la runa del caballo, el progreso y la colaboración. El avance es inevitable.',
      advice: 'Busca una aliada. Juntas lograréis más que solas.',
      past: 'Una alianza o colaboración ya dio resultado — te fortaleció.',
      future: 'Se acerca un encuentro con una persona importante — no lo dejes pasar.',
    ),
    'fr': RuneL10n(
      name: 'Ehwaz',
      title: 'Rune du mouvement',
      description:
          'Ehwaz est la rune du cheval, du progrès et du partenariat. L’avancée est inévitable.',
      advice: 'Trouve une alliée. Ensemble vous arriverez plus loin que chacune de son côté.',
      past: 'Une alliance ou un partenariat a déjà porté ses fruits — il t’a renforcée.',
      future: 'Une rencontre avec une personne importante approche — ne la manque pas.',
    ),
  },
  'mannaz': {
    'ru': RuneL10n(
      name: 'Манназ',
      title: 'Руна человека',
      description:
          'Манназ — руна человечества, самопознания и социальных связей.',
      advice: 'Посмотри на себя со стороны. Кто ты без масок и ролей?',
      past: 'Отношения или социальная ситуация уже показали тебе истинное лицо.',
      future: 'Коллектив или команда сыграет ключевую роль — не изолировайся.',
    ),
    'en': RuneL10n(
      name: 'Mannaz',
      title: 'Rune of Humanity',
      description:
          'Mannaz is the rune of humankind, self-knowledge and social bonds.',
      advice: 'Look at yourself from the outside. Who are you without masks and roles?',
      past: 'A relationship or social situation has already shown you the true face.',
      future: 'A group or team will play a key role — do not isolate yourself.',
    ),
    'de': RuneL10n(
      name: 'Mannaz',
      title: 'Runen des Menschen',
      description:
          'Mannaz ist die Rune der Menschheit, der Selbsterkenntnis und der sozialen Bindungen.',
      advice: 'Sieh dich von außen an. Wer bist du ohne Masken und Rollen?',
      past: 'Eine Beziehung oder soziale Situation hat dir bereits das wahre Gesicht gezeigt.',
      future: 'Eine Gruppe oder ein Team wird eine Schlüsselrolle spielen — isoliere dich nicht.',
    ),
    'es': RuneL10n(
      name: 'Mannaz',
      title: 'Runa del ser humano',
      description:
          'Mannaz es la runa de la humanidad, el autoconocimiento y los vínculos sociales.',
      advice: 'Mírate desde fuera. ¿Quién eres sin máscaras ni papeles?',
      past: 'Una relación o situación social ya te mostró la verdadera cara.',
      future: 'Un colectivo o equipo jugará un papel clave — no te aísles.',
    ),
    'fr': RuneL10n(
      name: 'Mannaz',
      title: 'Rune de l’humain',
      description:
          'Mannaz est la rune de l’humanité, de la connaissance de soi et des liens sociaux.',
      advice: 'Regarde-toi de l’extérieur. Qui es-tu sans masques ni rôles ?',
      past: 'Une relation ou une situation sociale t’a déjà montré le vrai visage.',
      future: 'Un collectif ou une équipe jouera un rôle clé — ne t’isole pas.',
    ),
  },
  'laguz': {
    'ru': RuneL10n(
      name: 'Лагуз',
      title: 'Руна воды',
      description:
          'Лагуз — руна потока, интуиции и подсознания. Плыви по течению.',
      advice: 'Доверься потоку жизни. Не борись с течением — используй его силу.',
      past: 'Течение жизни уже унесло тебя туда, куда нужно — даже если не понимала.',
      future: 'События понесут тебя вперёд — не греби против течения, поверни руль.',
    ),
    'en': RuneL10n(
      name: 'Laguz',
      title: 'Rune of Water',
      description:
          'Laguz is the rune of flow, intuition and the subconscious. Drift with the current.',
      advice: 'Trust the flow of life. Do not fight the current — use its power.',
      past: 'The current of life has already carried you where you needed to go — even if you did not understand it.',
      future: 'Events will carry you forward — do not row against the current, turn the rudder.',
    ),
    'de': RuneL10n(
      name: 'Laguz',
      title: 'Runen des Wassers',
      description:
          'Laguz ist die Rune des Flusses, der Intuition und des Unterbewusstseins. Schwimme mit dem Strom.',
      advice: 'Vertraue dem Fluss des Lebens. Kämpfe nicht gegen die Strömung — nutze ihre Kraft.',
      past: 'Der Strom des Lebens hat dich bereits dorthin getragen, wo du hingehst — auch wenn du es nicht verstanden hast.',
      future: 'Die Ereignisse werden dich vorwärts tragen — rudere nicht gegen den Strom, drehe das Ruder.',
    ),
    'es': RuneL10n(
      name: 'Laguz',
      title: 'Runa del agua',
      description:
          'Laguz es la runa de la corriente, la intuición y el subconsciente. Fluye con la corriente.',
      advice: 'Confía en la corriente de la vida. No luches contra ella — usa su fuerza.',
      past: 'La corriente de la vida ya te llevó adonde debías ir — aunque no lo entendieras.',
      future: 'Los acontecimientos te llevarán adelante — no remes contra la corriente, gira el timón.',
    ),
    'fr': RuneL10n(
      name: 'Laguz',
      title: 'Rune de l’eau',
      description:
          'Laguz est la rune du courant, de l’intuition et de l’inconscient. Laisse-toi porter.',
      advice: 'Fais confiance au courant de la vie. Ne lutte pas contre lui — utilise sa force.',
      past: 'Le courant de la vie t’a déjà portée là où tu devais aller — même sans que tu le comprennes.',
      future: 'Les événements te porteront en avant — ne rame pas contre le courant, tourne le gouvernail.',
    ),
  },
  'inguz': {
    'ru': RuneL10n(
      name: 'Ингуз',
      title: 'Руна плодородия',
      description:
          'Ингуз — руна семени, потенциала и завершения цикла. Старое уходит — новое рождается.',
      advice: 'Заверши начатое. Освободи место для нового в своей жизни.',
      past: 'Цикл завершился — ты уже отпустила старое, даже если не заметила.',
      future: 'Новый цикл начнётся — подготовь почву, сейчас время сеять.',
    ),
    'en': RuneL10n(
      name: 'Ingwaz',
      title: 'Rune of Fertility',
      description:
          'Ingwaz is the rune of the seed, potential and the end of a cycle. The old departs — the new is born.',
      advice: 'Finish what you started. Make room for the new in your life.',
      past: 'The cycle has ended — you have already let go of the old, even if you did not notice.',
      future: 'A new cycle will begin — prepare the soil, it is time to sow.',
    ),
    'de': RuneL10n(
      name: 'Ingwaz',
      title: 'Runen der Fruchtbarkeit',
      description:
          'Ingwaz ist die Rune des Samens, des Potenzials und des Zyklusendes. Das Alte geht — Neues wird geboren.',
      advice: 'Vollende, was du begonnen hast. Schaffe Platz für Neues in deinem Leben.',
      past: 'Der Zyklus ist vollendet — du hast das Alte bereits losgelassen, auch wenn du es nicht bemerkt hast.',
      future: 'Ein neuer Zyklus beginnt — bereite den Boden vor, jetzt ist die Zeit zu säen.',
    ),
    'es': RuneL10n(
      name: 'Ingwaz',
      title: 'Runa de la fecundidad',
      description:
          'Ingwaz es la runa de la semilla, el potencial y el fin del ciclo. Lo viejo se va — lo nuevo nace.',
      advice: 'Termina lo que empezaste. Libera espacio para lo nuevo en tu vida.',
      past: 'El ciclo se cerró — ya soltaste lo viejo, aunque no lo notaras.',
      future: 'Un nuevo ciclo comenzará — prepara el suelo, es tiempo de sembrar.',
    ),
    'fr': RuneL10n(
      name: 'Ingwaz',
      title: 'Rune de la fécondité',
      description:
          'Ingwaz est la rune de la graine, du potentiel et de la fin d’un cycle. Le vieux s’en va — le nouveau naît.',
      advice: 'Achève ce que tu as commencé. Fais de la place pour le nouveau dans ta vie.',
      past: 'Le cycle s’est achevé — tu as déjà lâché le vieux, même si tu ne l’as pas remarqué.',
      future: 'Un nouveau cycle commencera — prépare le sol, c’est le moment de semer.',
    ),
  },
  'othala': {
    'ru': RuneL10n(
      name: 'Отала',
      title: 'Руна наследия',
      description:
          'Отала — руна рода, дома и наследства. Твои корни — твоя сила.',
      advice: 'Обратись к семейным ценностям. То, что построено предками, — твой фундамент.',
      past: 'Наследие или решение семьи уже повлияло на твой путь — осознай это.',
      future: 'Вопрос дома, семьи или наследства встанет остро — реши его мудро.',
    ),
    'en': RuneL10n(
      name: 'Othala',
      title: 'Rune of Heritage',
      description:
          'Othala is the rune of kin, home and inheritance. Your roots are your strength.',
      advice: 'Turn to family values. What your ancestors built is your foundation.',
      past: 'A legacy or a family decision has already shaped your path — realize it.',
      future: 'The question of home, family or inheritance will become pressing — resolve it wisely.',
    ),
    'de': RuneL10n(
      name: 'Othala',
      title: 'Runen des Erbes',
      description:
          'Othala ist die Rune der Sippe, des Heims und des Erbes. Deine Wurzeln sind deine Kraft.',
      advice: 'Wende dich den Familienwerten zu. Was die Ahnen gebaut haben, ist dein Fundament.',
      past: 'Ein Erbe oder eine Familienentscheidung hat deinen Weg bereits geprägt — erkenne es.',
      future: 'Die Frage von Heim, Familie oder Erbe wird drängend — löse sie weise.',
    ),
    'es': RuneL10n(
      name: 'Othala',
      title: 'Runa de la herencia',
      description:
          'Othala es la runa de la estirpe, el hogar y la herencia. Tus raíces son tu fuerza.',
      advice: 'Acude a los valores familiares. Lo que construyeron tus antepasados es tu fundamento.',
      past: 'Una herencia o decisión familiar ya marcó tu camino — tómalo en cuenta.',
      future: 'La cuestión del hogar, la familia o la herencia se volverá apremiante — resuélvela con sabiduría.',
    ),
    'fr': RuneL10n(
      name: 'Othala',
      title: 'Rune de l’héritage',
      description:
          'Othala est la rune de la lignée, du foyer et de l’héritage. Tes racines sont ta force.',
      advice: 'Tourne-toi vers les valeurs familiales. Ce que tes ancêtres ont construit est ton fondement.',
      past: 'Un héritage ou une décision de famille a déjà façonné ton chemin — prends-en conscience.',
      future: 'La question du foyer, de la famille ou de l’héritage deviendra pressante — résous-la avec sagesse.',
    ),
  },
  'dagaz': {
    'ru': RuneL10n(
      name: 'Дагаз',
      title: 'Руна дня',
      description:
          'Дагаз — руна рассвета, прорыва и трансформации. Ночь закончилась.',
      advice: 'Проснись! Новый день несёт новые возможности. Действуй.',
      past: 'Прорыв уже случился — рассвет наступил, даже если ты ещё не открыла глаза.',
      future: 'Кардинальная перемена близка — ночь закончится внезапно и ярко.',
    ),
    'en': RuneL10n(
      name: 'Dagaz',
      title: 'Rune of Day',
      description:
          'Dagaz is the rune of dawn, breakthrough and transformation. The night is over.',
      advice: 'Wake up! A new day brings new opportunities. Act.',
      past: 'The breakthrough has already happened — dawn has come, even if you have not opened your eyes yet.',
      future: 'A radical change is near — the night will end suddenly and brightly.',
    ),
    'de': RuneL10n(
      name: 'Dagaz',
      title: 'Runen des Tages',
      description:
          'Dagaz ist die Rune der Dämmerung, des Durchbruchs und der Transformation. Die Nacht ist vorbei.',
      advice: 'Wach auf! Der neue Tag bringt neue Möglichkeiten. Handle.',
      past: 'Der Durchbruch ist bereits geschehen — die Dämmerung ist gekommen, auch wenn du die Augen noch nicht geöffnet hast.',
      future: 'Ein radikaler Wandel ist nah — die Nacht wird plötzlich und hell enden.',
    ),
    'es': RuneL10n(
      name: 'Dagaz',
      title: 'Runa del día',
      description:
          'Dagaz es la runa del alba, el avance y la transformación. La noche ha terminado.',
      advice: '¡Despierta! El nuevo día trae nuevas oportunidades. Actúa.',
      past: 'El avance ya ocurrió — el alba llegó, aunque aún no hayas abierto los ojos.',
      future: 'Un cambio radical se acerca — la noche terminará de repente y con luz.',
    ),
    'fr': RuneL10n(
      name: 'Dagaz',
      title: 'Rune du jour',
      description:
          'Dagaz est la rune de l’aube, de la percée et de la transformation. La nuit est finie.',
      advice: 'Réveille-toi ! Le nouveau jour apporte de nouvelles chances. Agis.',
      past: 'La percée a déjà eu lieu — l’aube est venue, même si tu n’as pas encore ouvert les yeux.',
      future: 'Un changement radical est proche — la nuit se terminera soudainement et dans la lumière.',
    ),
  },
};
