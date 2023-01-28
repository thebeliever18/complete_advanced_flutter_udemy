import 'dart:ui';

enum LanguageType{english,nepali}

const String nepali = 'ne';
const String english = 'en';
const String assetPathLocalization = 'assets/translations';
const Locale nepaliLocale = Locale('ne',null);
const Locale englishLocale = Locale('en','US');

extension LangugaeTypeExtension on LanguageType{
  String getValue(){
    switch(this){
      case LanguageType.english:
        return english;
      case LanguageType.nepali:
        return nepali;
    }
  }
}