import 'package:flutter/material.dart';
import '../theme/sanad_theme.dart';

/// Month-grid calendar matching the hand-off mock. Lets the user pick a past
/// (or today) quit date. RTL-aware via the ambient Directionality; numerals
/// stay Western. Future days are disabled.
class SanadCalendar extends StatefulWidget {
  const SanadCalendar({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.lang,
  });

  final DateTime selected;
  final ValueChanged<DateTime> onSelect;
  final String lang;

  @override
  State<SanadCalendar> createState() => _SanadCalendarState();
}

class _SanadCalendarState extends State<SanadCalendar> {
  late DateTime _month; // first of displayed month

  @override
  void initState() {
    super.initState();
    _month = DateTime(widget.selected.year, widget.selected.month);
  }

  static const _monthsAr = [
    'يناير','فبراير','مارس','أبريل','مايو','يونيو',
    'يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر'
  ];
  static const _monthsEn = [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December'
  ];
  static const _dowAr = ['ح','ن','ث','ر','خ','ج','س'];
  static const _dowEn = ['S','M','T','W','T','F','S'];

  bool _sameMonth(DateTime a, DateTime b) => a.year == b.year && a.month == b.month;

  @override
  Widget build(BuildContext context) {
    final ar = widget.lang == 'ar';
    final today = DateTime.now();
    final todayMid = DateTime(today.year, today.month, today.day);
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final leading = DateTime(_month.year, _month.month, 1).weekday % 7; // Sun=0
    final monthName = (ar ? _monthsAr : _monthsEn)[_month.month - 1];
    final canNext = !_sameMonth(_month, todayMid);

    final cells = <Widget>[];
    for (var i = 0; i < leading; i++) {
      cells.add(const SizedBox());
    }
    for (var d = 1; d <= daysInMonth; d++) {
      final date = DateTime(_month.year, _month.month, d);
      final disabled = date.isAfter(todayMid);
      final sel = date.year == widget.selected.year &&
          date.month == widget.selected.month &&
          date.day == widget.selected.day;
      final isToday = date == todayMid;
      cells.add(GestureDetector(
        onTap: disabled ? null : () => widget.onSelect(date),
        child: Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: sel ? SanadColors.primary : Colors.transparent,
            shape: BoxShape.circle,
            border: isToday && !sel ? Border.all(color: SanadColors.ringB) : null,
          ),
          alignment: Alignment.center,
          child: Text(
            '$d',
            style: TextStyle(
              color: disabled
                  ? SanadColors.textMuted
                  : sel
                      ? Colors.white
                      : SanadColors.heading,
              fontWeight: sel ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ),
      ));
    }

    final daysAgo = todayMid
        .difference(DateTime(widget.selected.year, widget.selected.month, widget.selected.day))
        .inDays;
    final footer = ar ? '$daysAgo يومًا حتى اليوم' : '$daysAgo days until today';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SanadColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: SanadColors.primary),
                onPressed: () => setState(() => _month = DateTime(_month.year, _month.month - 1)),
              ),
              Expanded(
                child: Text('$monthName ${_month.year}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w700, color: SanadColors.heading)),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: canNext ? SanadColors.primary : SanadColors.textMuted),
                onPressed: canNext ? () => setState(() => _month = DateTime(_month.year, _month.month + 1)) : null,
              ),
            ],
          ),
          Row(
            children: (ar ? _dowAr : _dowEn)
                .map((d) => Expanded(
                      child: Center(
                        child: Text(d, style: const TextStyle(fontSize: 12, color: SanadColors.textSecondary, fontWeight: FontWeight.w600)),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 6),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: cells,
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: SanadColors.softCardB, borderRadius: BorderRadius.circular(14)),
            child: Text(footer, textAlign: TextAlign.center, style: const TextStyle(color: SanadColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
