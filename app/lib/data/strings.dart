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
  static const customHabitPrompt = L('اكتب ما تحاول الإقلاع عنه', "Name what you're quitting");
  static const customHabitHint = L('مثال: السكّر، الألعاب، التسوّق…', 'e.g. sugar, gaming, shopping…');
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

  // bottom nav
  static const navHome = L('الرئيسية', 'Home');
  static const navProgress = L('تقدّمك', 'Progress');
  static const navRecovery = L('تعافيك', 'Recovery');
  static const navCommunity = L('المجتمع', 'Community');
  static const navMe = L('حسابي', 'Me');

  // progress tab
  static const progressTitle = L('تقدّمك', 'Your progress');
  static const moodLast = L('المزاج آخر ٧ أيام', 'Mood, last 7 days');
  static const cravingLast = L('الرغبة تضعف', 'Cravings easing');
  static const checkinHistory = L('سجلّ تسجيلاتك', 'Your check-ins');
  static const noCheckins = L('لا تسجيلات بعد. سجّل يومك من الرئيسية.', 'No check-ins yet. Log your day from Home.');
  static const milestonesTitle = L('المعالم', 'Milestones');
  static const moodLabel = L('المزاج', 'Mood');
  static const cravingLabel = L('الرغبة', 'Craving');

  // me tab
  static const meTitle = L('حسابي', 'Me');
  static const anonName = L('مجهول · مسافر', 'Anonymous · Traveler');
  static const myReasons = L('لماذا أفعل هذا', 'Why I am doing this');
  static const tracking = L('ما أتتبّعه', 'What I track');
  static const editQuitDate = L('تعديل تاريخ البداية', 'Edit quit date');
  static const editQuitDateSub = L('صحّح اليوم الذي بدأت فيه', 'Correct the day you started');
  static const relapseReset = L('سجّل انتكاسة', 'Log a relapse');
  static const relapseResetSub = L('بداية جديدة — مع حفظ سجلّك', 'A fresh start — your history is kept');
  static const deleteJourney = L('حذف الرحلة', 'Delete journey');
  static const deleteJourneySub = L('يمسح كل بياناتك ويبدأ من جديد', 'Erases all your data and starts over');
  static const deleteConfirmTitle = L('حذف رحلتك؟', 'Delete your journey?');
  static const deleteConfirmBody = L('سيُمسح تاريخ بدايتك وتسجيلاتك وكل تقدّمك نهائيًا. لا يمكن التراجع.',
      'Your quit date, check-ins and all progress will be permanently erased. This cannot be undone.');
  static const cancel = L('إلغاء', 'Cancel');
  static const deleteConfirmYes = L('نعم، احذف', 'Yes, delete');
  static const onDevice = L('كل شيء على هذا الجهاز', 'Everything is on this phone');
  static const onDeviceSub = L('بلا حساب. لا شيء يُرفع.', 'No account. Nothing uploaded.');
  static const backupTitle = L('نسخة احتياطية برمز', 'Back up with a code');
  static const backupSub = L('استعد على هاتف جديد، بلا تسجيل دخول', 'Restore on a new phone, no sign-in');
  static const languageLabel = L('اللغة', 'Language');

  // recovery / health
  static const youAreIn = L('أنت في مرحلة', 'You are in');
  static const phaseStart = L('البداية', 'Start');
  static const phaseWeek1 = L('الأسبوع الأول', 'First week');
  static const phaseClarity = L('مرحلة الصفاء', 'Clarity');
  static const phaseStabilize = L('الاستقرار', 'Stabilizing');
  static const phaseDeep = L('التعافي العميق', 'Deep recovery');
  static const curveRecovery = L('التعافي', 'Recovery');
  static const curveSymptoms = L('شدّة الأعراض', 'Symptoms');
  static const youAreHere = L('أنت هنا', 'You are here');
  static const expectThisWeek = L('ماذا تتوقّع هذا الأسبوع', 'What to expect this week');
  static const peopleFeel = L('ما يشعر به كثيرون', 'What people commonly feel');
  static const aWord = L('كلمة دعم', 'A word of support');
  static const indicatorsTitle = L('مؤشّرات التعافي', 'Recovery indicators');
  static const fullJourney = L('رحلة التعافي كاملة', 'The full recovery journey');
  static const nowTag = L('الآن', 'Now');
  static const sourcesTitle = L('المصادر', 'Sources');

  // SOS breathing
  static const sosCue = L('أشعر برغبة الآن', 'Feeling a craving?');
  static const sosButton = L('تنفّس — تجاوز الرغبة', 'Breathe — ride the wave');
  static const sosTitle = L('تجاوز الموجة', 'Ride the wave');
  static const sosSub = L('الرغبة موجة تمرّ خلال دقائق. تنفّس معنا حتى تهدأ.', 'A craving is a wave that passes in minutes. Breathe with us until it eases.');
  static const breatheIn = L('شهيق…', 'Breathe in…');
  static const breatheHold = L('احبس…', 'Hold…');
  static const breatheOut = L('زفير…', 'Breathe out…');
  static const imOkay = L('أنا بخير الآن', "I'm okay now");
  static const sosReassure = L('أنت أقوى من هذه اللحظة.', "You're stronger than this moment.");
  static const axisStart = L('البداية', 'Start');
  static const axisTwoWeeks = L('أسبوعان', '2 wks');
  static const axisMonth = L('شهر', '1 mo');
  static const axisSixWeeks = L('٦ أسابيع', '6 wks');
  static const axisTwoMonths = L('شهران', '2 mo');

  // community
  static const communityTitle = L('المجتمع', 'Community');
  static const communitySoon = L('مجتمع مجهول — قريبًا', 'Anonymous community — coming soon');
  static const communitySoonSub = L('بلا أسماء، بلا وجوه. فقط ناس يفهمونك.', 'No names, no faces. Just people who get it.');
}
