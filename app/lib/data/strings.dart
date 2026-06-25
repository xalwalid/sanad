import 'catalog.dart';

/// Bilingual UI copy (AR primary, EN secondary). Numerals stay Western digits.
class S {
  // welcome
  static const welcomeTitle = L('أهلاً بك في سند', 'Welcome to Sanad');
  static const welcomeSub =
      L('رفيقك الهادئ في رحلة التعافي.', 'Your calm companion on the road to recovery.');
  static const privacy =
      L('كل شيء يبقى على جهازك. بلا حساب، بلا تتبّع.', 'Everything stays on your phone. No account, no tracking.');
  static const begin = L('لنبدأ', "Let's begin");

  // onboarding chrome
  static const cont = L('متابعة', 'Continue');
  static const back = L('رجوع', 'Back');

  static const habitTitle = L('ما الذي تريد الإقلاع عنه؟', 'What do you want to quit?');
  static const dateTitle = L('متى بدأت رحلتك؟', 'When did your journey begin?');
  static const dateToday = L('أبدأ اليوم', 'I start today');
  static const datePast = L('أقلعت منذ مدة', 'I quit a while ago');
  static const daysUntilToday = L('يومًا حتى اليوم', 'days until today');

  static const spendTitle = L('كم كان يكلّفك؟', 'How much did it cost you?');
  static const finishSetup = L('إنهاء الإعداد', 'Finish setup');
  static const skipStep = L('تخطّ هذه الخطوة', 'Skip this step');
  static const moneyHeader = L('المال', 'Money');
  static const timeHeader = L('الوقت', 'Time');
  static const usageHeader = L('الاستخدام', 'Usage');
  static const offMoney = L('لن نعرض المال الموفّر.', "We won't show money saved.");
  static const perDay = L('مرّات/يوم', 'times/day');
  static const minutes = L('دقيقة', 'min');
  static const monthlyEst = L('ستوفّر نحو {x} {cur} شهريًا', "You'll save about {x} {cur} monthly");

  // cost periods
  static const pDaily = L('يومي', 'Daily');
  static const pWeekly = L('أسبوعي', 'Weekly');
  static const pHourly = L('بالساعة', 'Hourly');
  static const pPerUse = L('لكل مرّة', 'Per use');

  // home
  static const greeting = L('مساؤك طيّب', 'Good evening');
  static const quittingFrom = L('إقلاعك عن {habit}', 'Quitting {habit}');
  static const daysClean = L('يومًا نظيفًا', 'days clean');
  static const nextMilestone = L('المعلم القادم', 'Next milestone');
  static const remains = L('باقٍ {n} يومًا لـ {m}', '{n} days to {m}');
  static const pledge = L('أتعهّد بالبقاء نظيفًا اليوم', 'I pledge to stay clean today');
  static const pledged = L('تعهّدت اليوم', 'Pledged today');
  static const checkinCta = L('تسجيل اليوم', 'Daily check-in');
  static const checkinSub = L('سجّل مزاجك ورغبتك', 'Log your mood and craving');
  static const mMoney = L('المال الموفّر', 'Money saved');
  static const mTime = L('الوقت المستعاد', 'Time reclaimed');
  static const mLongest = L('أطول سلسلة', 'Longest streak');
  static const mAvoided = L('مرّات تجنّبتها', 'Times avoided');
  static const recoveryPath = L('مسار تعافيك', 'Your recovery');
  static const recoveryPathSub = L('ما الذي يتعافى في جسمك الآن', "What's healing in your body now");
  static const shareMilestone = L('شارك إنجازك', 'Share your milestone');

  static const unitDay = L('يوم', 'd');
  static const unitHour = L('ساعة', 'h');
  static const settings = L('الإعدادات', 'Settings');

  // check-in
  static const checkinTitle = L('تسجيل اليوم', 'Daily check-in');
  static const moodQ = L('كيف هو مزاجك؟', "How's your mood?");
  static const cravingQ = L('مستوى الرغبة', 'Craving level');
  static const noCraving = L('لا رغبة', 'None');
  static const strongCraving = L('رغبة شديدة', 'Strong');
  static const noteHint = L('أيّ شيء تودّ تدوينه (اختياري)', 'Anything to note (optional)');
  static const save = L('حفظ', 'Save');

  // health
  static const healthTitle = L('مسار تعافيك', 'Your recovery');
  static const healedSummary = L('{x} من {y} مؤشّرات تعافت بالكامل', '{x} of {y} indicators fully healed');
  static const remainingDays = L('متبقٍ {n} يومًا', '{n} days left');
  static const completeMark = L('اكتمل', 'Complete');
  static const readMore = L('اقرأ المزيد', 'Read more');
  static const healingNow = L('ما الذي يتعافى الآن', 'Healing now');
  static const alreadyHealed = L('ما الذي تعافى', 'Already healed');
  static const whatsComing = L('ما هو قادم', "What's coming");

  // share
  static const shareTitle = L('بطاقة الإنجاز', 'Achievement card');
  static const cleanFrom = L('يومًا نظيفًا من {habit}', 'days clean from {habit}');
  static const cleanPlain = L('يومًا نظيفًا', 'days clean');
  static const chHabit = L('نوع الإدمان', 'Habit type');
  static const chMass = L('الكمية المتجنَّبة', 'Amount avoided');
  static const saveImage = L('حفظ الصورة', 'Save image');
  static const shareBtn = L('مشاركة', 'Share');
  static const saved = L('تم الحفظ', 'Saved');

  // relapse
  static const relapseTitle = L('بداية جديدة', 'A new start');
  static const relapseLine1 = L('التعافي ليس خطًّا مستقيمًا.', "Recovery isn't a straight line.");
  static const relapseLine2 = L('لم تعد إلى الصفر — عدت بكل ما تعلّمته.',
      "You're not back to zero — you're back with everything you learned.");
  static const longestKept = L('أطول سلسلة محفوظة', 'Longest streak kept');
  static const historyKept = L('سجلّك محفوظ', 'History preserved');
  static const startAgain = L('ابدأ من جديد', 'Start again');
  static const logRelapse = L('سجّل انتكاسة', 'Log a relapse');
  static const needSupport = L('تحتاج دعمًا الآن؟', 'Need support now?');

  // crisis
  static const crisisTitle = L('لستَ وحدك', "You're not alone");
  static const crisisBody = L(
      'لحظة صعبة لا تمحو تقدّمك. إن كنت في أزمة، تواصل مع شخص تثق به الآن.',
      "A hard moment doesn't erase your progress. If you're in crisis, reach out to someone you trust now.");
  static const notMedical = L('سند ليس خدمة طبّية أو طارئة.', 'Sanad is not a medical or emergency service.');
}
