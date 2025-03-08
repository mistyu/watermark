import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CustomCupertinoLocalizations extends CupertinoLocalizations {
  CustomCupertinoLocalizations();

  static const List<String> _months = <String>[
    '01月',
    '02月',
    '03月',
    '04月',
    '05月',
    '06月',
    '07月',
    '08月',
    '09月',
    '10月',
    '11月',
    '12月',
  ];

  @override
  String get shareButtonLabel => '分享';
  @override
  String datePickerYear(int yearIndex) => yearIndex.toString() + '年';

  @override
  String datePickerMonth(int monthIndex) => _months[monthIndex - 1];

  @override
  String datePickerDayOfMonth(int dayIndex, [int? of]) {
    return dayIndex < 10 ? '0$dayIndex日' : '$dayIndex日';
  }

  @override
  String datePickerHour(int hour) => hour < 10 ? '0$hour' : '$hour';

  @override
  String datePickerMinute(int minute) => minute < 10 ? '0$minute' : '$minute';

  @override
  String datePickerMediumDate(DateTime date) {
    return '${date.year}年${_months[date.month - 1]}${date.day}日';
  }

  @override
  String get clearButtonLabel => '清除';

  @override
  String datePickerStandaloneMonth(int month) => _months[month - 1];

  @override
  String datePickerHourSemanticsLabel(int hour) => '$hour时';

  @override
  String datePickerMinuteSemanticsLabel(int minute) => '$minute分';

  @override
  String get datePickerDateOrderString => 'ymd';

  @override
  String get datePickerDateTimeOrderString => 'date_time_dayPeriod';

  @override
  String get datePickerHourSemanticsLabelOne => '1时';

  @override
  String get datePickerHourSemanticsLabelOther => '小时';

  @override
  String get datePickerMinuteSemanticsLabelOne => '1分';

  @override
  String get datePickerMinuteSemanticsLabelOther => '分钟';

  @override
  DatePickerDateOrder get datePickerDateOrder => DatePickerDateOrder.ymd;

  @override
  DatePickerDateTimeOrder get datePickerDateTimeOrder =>
      DatePickerDateTimeOrder.date_time_dayPeriod;

  @override
  String get alertDialogLabel => '提示';

  @override
  String get anteMeridiemAbbreviation => '上午';

  @override
  String get postMeridiemAbbreviation => '下午';

  @override
  String get copyButtonLabel => '复制';

  @override
  String get cutButtonLabel => '剪切';

  @override
  String get pasteButtonLabel => '粘贴';

  @override
  String get selectAllButtonLabel => '全选';

  @override
  String get todayLabel => '今天';

  @override
  String timerPickerHour(int hour) => hour.toString();

  @override
  String timerPickerMinute(int minute) => minute.toString();

  @override
  String timerPickerSecond(int second) => second.toString();

  @override
  String timerPickerHourLabel(int hour) => '时';

  @override
  String timerPickerMinuteLabel(int minute) => '分';

  @override
  String timerPickerSecondLabel(int second) => '秒';

  @override
  String get modalBarrierDismissLabel => '关闭';

  @override
  String tabSemanticsLabel({required int tabIndex, required int tabCount}) {
    return '$tabIndex of $tabCount';
  }

  @override
  String get searchTextFieldPlaceholderLabel => '搜索';

  @override
  List<String> get timerPickerHourLabels => const ['时'];

  @override
  List<String> get timerPickerMinuteLabels => const ['分'];

  @override
  List<String> get timerPickerSecondLabels => const ['秒'];

  @override
  String get lookUpButtonLabel => '查找';

  @override
  String get menuDismissLabel => '关闭菜单';

  @override
  String get noSpellCheckReplacementsLabel => '无替换建议';

  @override
  String get searchWebButtonLabel => '搜索网页';

  static const LocalizationsDelegate<CupertinoLocalizations> delegate =
      _CustomCupertinoLocalizationsDelegate();
}

class _CustomCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _CustomCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'zh';

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    return SynchronousFuture<CupertinoLocalizations>(
        CustomCupertinoLocalizations());
  }

  @override
  bool shouldReload(_CustomCupertinoLocalizationsDelegate old) => false;
}
