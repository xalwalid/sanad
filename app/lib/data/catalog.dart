import 'package:flutter/material.dart';
import '../models/models.dart';

/// Bilingual string pair. Numerals are always rendered as Western digits
/// elsewhere — never Arabic-Indic (firm design rule from the hand-off).
class L {
  final String ar;
  final String en;
  const L(this.ar, this.en);
  String t(String code) => code == 'ar' ? ar : en;
}

/// Per-habit display info and "units avoided" maths.
class HabitInfo {
  const HabitInfo({
    required this.habit,
    required this.name,
    required this.unitWord,
    required this.massPer,
    required this.massLabel,
    this.massRound = 0,
  });
  final Habit habit;
  final L name;
  final L unitWord; // a single use ("joint", "drink"…)
  final double massPer; // mass avoided per unit; 0 = none
  final L massLabel;
  final int massRound; // decimals for mass value
}

const milestones = [7, 30, 100, 365];

/// Display name for a profile's habit — the user's typed name for 'other'.
String habitTitle(RecoveryProfile p, String code) {
  if (p.habit == Habit.other && (p.customName?.trim().isNotEmpty ?? false)) {
    return p.customName!.trim();
  }
  return habitCatalog[p.habit]!.name.t(code);
}

const Map<Habit, HabitInfo> habitCatalog = {
  Habit.cannabis: HabitInfo(
    habit: Habit.cannabis,
    name: L('القنّب', 'Cannabis'),
    unitWord: L('لفافة', 'joint'),
    massPer: 0.5,
    massLabel: L('غرام قنّب لم يُدخَّن', 'g of cannabis not smoked'),
  ),
  Habit.alcohol: HabitInfo(
    habit: Habit.alcohol,
    name: L('الكحول', 'Alcohol'),
    unitWord: L('مشروب', 'drink'),
    massPer: 0.33,
    massLabel: L('لتر كحول لم يُشرَب', 'L of alcohol not drunk'),
    massRound: 1,
  ),
  Habit.cigarettes: HabitInfo(
    habit: Habit.cigarettes,
    name: L('التدخين', 'Smoking'),
    unitWord: L('سيجارة', 'cigarette'),
    massPer: 0.05,
    massLabel: L('علبة لم تُفتَح', 'packs not opened'),
  ),
  Habit.vaping: HabitInfo(
    habit: Habit.vaping,
    name: L('التدخين الإلكتروني', 'Vaping'),
    unitWord: L('جلسة', 'session'),
    massPer: 0.0333,
    massLabel: L('عبوة سائل وُفِّرت', 'pods saved'),
  ),
  Habit.gambling: HabitInfo(
    habit: Habit.gambling,
    name: L('القمار', 'Gambling'),
    unitWord: L('رهان', 'bet'),
    massPer: 0,
    massLabel: L('', ''),
  ),
  Habit.porn: HabitInfo(
    habit: Habit.porn,
    name: L('الإباحية', 'Pornography'),
    unitWord: L('مرّة', 'time'),
    massPer: 0,
    massLabel: L('', ''),
  ),
  Habit.other: HabitInfo(
    habit: Habit.other,
    name: L('عادة أخرى', 'Other habit'),
    unitWord: L('مرّة', 'time'),
    massPer: 0,
    massLabel: L('', ''),
  ),
};

/// One body/mind recovery indicator. `full` = days to full recovery.
class MetricDef {
  const MetricDef({
    required this.key,
    required this.name,
    required this.color,
    required this.tint,
    required this.full,
    required this.done,
    required this.now,
    required this.coming,
  });
  final String key;
  final L name;
  final Color color;
  final Color tint;
  final int full;
  final L done; // what has healed
  final L now; // what is healing
  final L coming; // what is to come
}

/// 13 metrics, ported from the hand-off (Arabic copy verbatim; English added).
const List<MetricDef> metricsDef = [
  MetricDef(
    key: 'appetite',
    name: L('الشهية', 'Appetite'),
    color: Color(0xFF6E9577),
    tint: Color(0xFFE9F0E9),
    full: 14,
    done: L('عادت إليك الرغبة في الطعام بعد فترة الاضطراب الأولى التي تلت التوقّف.',
        'Your appetite has returned after the early unsettled days.'),
    now: L('تنتظم مواعيد جوعك وتعود حاسّة التذوّق إليك تدريجيًا.',
        'Hunger is becoming regular and taste is slowly returning.'),
    coming: L('علاقة صحّية ومتّزنة مع الطعام، دون إفراطٍ ولا فقدان شهية.',
        'A healthy, balanced relationship with food.'),
  ),
  MetricDef(
    key: 'heart',
    name: L('القلب', 'Heart'),
    color: Color(0xFFC28A3E),
    tint: Color(0xFFF4EBDC),
    full: 20,
    done: L('انخفض معدّل نبضك المتسارع وبدأ ضغط دمك يقترب من معدّله الطبيعي.',
        'Your racing pulse has eased and blood pressure is settling.'),
    now: L('يستقرّ نبض قلبك ويتحسّن تدفّق الدم والأكسجين في جسمك.',
        'Your heartbeat is steadying and circulation is improving.'),
    coming: L('قلب أقوى وأقلّ إجهادًا، وانخفاضٌ ملموس في مخاطر أمراض القلب.',
        'A stronger heart and lower cardiovascular risk.'),
  ),
  MetricDef(
    key: 'mood',
    name: L('المزاج', 'Mood'),
    color: Color(0xFF4E8C7A),
    tint: Color(0xFFE7F0ED),
    full: 21,
    done: L('هدأت موجات التهيّج والغضب الحادّة التي تظهر في الأيام الأولى.',
        'The sharp early waves of irritability have calmed.'),
    now: L('تصبح مشاعرك أكثر استقرارًا وتقلّ نوبات القلق المفاجئة.',
        'Your emotions are steadier and anxiety spikes are fewer.'),
    coming: L('مزاجٌ متّزن وقدرة أكبر على مواجهة ضغوط يومك بهدوء.',
        'A balanced mood and calmer days.'),
  ),
  MetricDef(
    key: 'energy',
    name: L('الطاقة', 'Energy'),
    color: Color(0xFF8FAF98),
    tint: Color(0xFFEBF1EC),
    full: 25,
    done: L('زال الخمول والكسل اللذان رافقا أيامك الأولى من التعافي.',
        'The sluggishness of the early days has lifted.'),
    now: L('تشعر بنشاطٍ أكبر وصحوٍ أسهل وأخفّ في الصباح.',
        'You feel more energetic and wake more easily.'),
    coming: L('طاقة ثابتة تمتدّ طوال اليوم بلا تقلّبات أو هبوطٍ مفاجئ.',
        'Steady energy that lasts all day.'),
  ),
  MetricDef(
    key: 'detox',
    name: L('التطهّر', 'Detox'),
    color: Color(0xFF1B4D3E),
    tint: Color(0xFFE6EEE6),
    full: 30,
    done: L('بدأ جسمك بطرد آثار المادة المتبقّية من دمك وأنسجتك.',
        'Your body has begun clearing the substance from your system.'),
    now: L('تتنظّم الهرمونات ويستعيد جسمك توازنه الكيميائي يومًا بعد يوم.',
        'Hormones are rebalancing and your chemistry is steadying.'),
    coming: L('اتزانٌ داخلي كامل وصفاءٌ يلمسه جسمك خلال أسابيع قليلة.',
        'Full internal balance within a few weeks.'),
  ),
  MetricDef(
    key: 'focus',
    name: L('التركيز', 'Focus'),
    color: Color(0xFF2E6B53),
    tint: Color(0xFFE7EFE9),
    full: 40,
    done: L('بدأ الضباب الذهني ينقشع وعادت إليك القدرة على الانتباه.',
        'The mental fog is clearing and attention is returning.'),
    now: L('يطول مدى تركيزك وتُنجز مهامك بصفاءٍ أكبر من قبل.',
        'Your focus lasts longer and tasks feel clearer.'),
    coming: L('حدّةٌ ذهنية وإنتاجية عالية في عملك ودراستك.',
        'Sharp thinking and high productivity.'),
  ),
  MetricDef(
    key: 'sleep',
    name: L('النوم', 'Sleep'),
    color: Color(0xFF3E7C6A),
    tint: Color(0xFFE6F0EC),
    full: 45,
    done: L('انقضت أصعب ليالي الأرق والأحلام المزعجة الحيّة.',
        'The hardest nights of insomnia and vivid dreams have passed.'),
    now: L('تتحسّن جودة نومك ومدّته ليلةً بعد ليلة.',
        'Your sleep quality and length improve night by night.'),
    coming: L('نومٌ عميق ومنتظم تستيقظ بعده مرتاحًا كما كنت من قبل.',
        'Deep, regular sleep you wake rested from.'),
  ),
  MetricDef(
    key: 'skin',
    name: L('البشرة', 'Skin'),
    color: Color(0xFFB58A4E),
    tint: Color(0xFFF2EEE3),
    full: 50,
    done: L('بدأت علامات الإرهاق والشحوب تختفي عن وجهك.',
        'Signs of fatigue and dullness are fading from your face.'),
    now: L('تتحسّن نضارة بشرتك وترطيبها مع عودة الدورة الدموية.',
        'Your skin looks fresher as circulation returns.'),
    coming: L('بشرةٌ أكثر صحّةً وإشراقًا ولونٌ متجانس وحيوي.',
        'Healthier, brighter, more even skin.'),
  ),
  MetricDef(
    key: 'body',
    name: L('اللياقة', 'Fitness'),
    color: Color(0xFF517F5C),
    tint: Color(0xFFE9F0EB),
    full: 60,
    done: L('عادت إليك القدرة على الحركة والمجهود دون تعبٍ سريع.',
        'You can move and exert yourself without tiring quickly.'),
    now: L('يرتفع مستوى لياقتك ونشاطك البدني في يومك.',
        'Your fitness and daily activity are rising.'),
    coming: L('لياقةٌ وحيوية ملحوظة وقوّة أكبر في جسمك كلّه.',
        'Noticeable fitness and strength throughout your body.'),
  ),
  MetricDef(
    key: 'memory',
    name: L('الذاكرة', 'Memory'),
    color: Color(0xFF5B8C7B),
    tint: Color(0xFFE7F0EC),
    full: 75,
    done: L('بدأت تتذكّر تفاصيل يومك بسهولةٍ أكبر وأقلّ نسيان.',
        'You recall your day more easily, with less forgetfulness.'),
    now: L('تتقوّى ذاكرتك قصيرة المدى وتثبت المعلومات أطول.',
        'Your short-term memory is strengthening.'),
    coming: L('ذاكرةٌ حادّة وقدرة أعلى على الاستيعاب والتعلّم.',
        'A sharp memory and stronger learning.'),
  ),
  MetricDef(
    key: 'breath',
    name: L('التنفّس', 'Breathing'),
    color: Color(0xFF2E6B53),
    tint: Color(0xFFE7EFE9),
    full: 90,
    done: L('بدأت رئتاك رحلة التعافي وطرد ما علق بهما.',
        'Your lungs have begun healing and clearing.'),
    now: L('يتحسّن تنفّسك وتقلّ ضيقة الصدر والسعال تدريجيًا.',
        'Breathing is easing and chest tightness is fading.'),
    coming: L('سعةٌ رئوية أكبر ونفَسٌ أعمق وأهدأ في حركتك.',
        'Greater lung capacity and deeper, calmer breath.'),
  ),
  MetricDef(
    key: 'balance',
    name: L('التوازن العصبي', 'Neural balance'),
    color: Color(0xFF1B4D3E),
    tint: Color(0xFFE6EEE6),
    full: 100,
    done: L('بدأ دماغك يستعيد توازن مستقبلات المتعة الطبيعية.',
        'Your brain is restoring its natural reward balance.'),
    now: L('تعود الأشياء البسيطة تمنحك متعةً حقيقية من جديد.',
        'Simple things bring real pleasure again.'),
    coming: L('توازنٌ عصبي كامل وقدرة على الاستمتاع بالحياة دون أيّ مادة.',
        'Full neural balance and joy without any substance.'),
  ),
  MetricDef(
    key: 'immunity',
    name: L('المناعة', 'Immunity'),
    color: Color(0xFF517F5C),
    tint: Color(0xFFE9F0EB),
    full: 120,
    done: L('بدأ جهازك المناعي يستردّ قوّته بعد إجهادٍ طويل.',
        'Your immune system is regaining strength.'),
    now: L('تقاوم العدوى البسيطة بشكلٍ أفضل وتتعافى منها أسرع.',
        'You fight off minor infections better and recover faster.'),
    coming: L('مناعةٌ قويّة تحميك وتقلّل من تكرار المرض والإرهاق.',
        'Strong immunity that protects you and cuts illness.'),
  ),
];
