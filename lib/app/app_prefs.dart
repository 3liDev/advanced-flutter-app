import 'package:advanced_flutter_app/presentation/resources/language_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String prefsKeyLang = "PREFS_KEY_LANG";
const String prefsKeyOnBoardingScreenViewd =
    "PREFS_KEY_ONBOARDING_SCREEN_VIEWD";
const String prefsKeyIsUserLoggedIn = "PREFS_KEY_IS_USER_LOGGED_IN";

class AppPreferences {
  final SharedPreferences _sharedPreferences;
  AppPreferences(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(prefsKeyLang);

    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      // return default language
      return LanguageType.english.getValue();
    }
  }

  Future<void> changeLanguage() async {
    String currrentLang = await getAppLanguage();

    if (currrentLang == LanguageType.arabic.getValue()) {
      // set english
      _sharedPreferences.setString(
          prefsKeyLang, LanguageType.english.getValue());
    } else {
      // set arabic
      _sharedPreferences.setString(
          prefsKeyLang, LanguageType.arabic.getValue());
    }
  }

  Future<Locale> getLocale() async {
    String currrentLang = await getAppLanguage();

    if (currrentLang == LanguageType.arabic.getValue()) {
      return arabicLocale;
    } else {
      return englishLocale;
    }
  }

  // on boarding
  Future<void> setOnBoardingScreenViewed() async {
    _sharedPreferences.setBool(prefsKeyOnBoardingScreenViewd, true);
  }

  Future<bool> isOnBoardingScreenViewed() async {
    return _sharedPreferences.getBool(prefsKeyOnBoardingScreenViewd) ?? false;
  }

  // login
  Future<void> setUserLoggedIn() async {
    _sharedPreferences.setBool(prefsKeyIsUserLoggedIn, true);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(prefsKeyIsUserLoggedIn) ?? false;
  }

  Future<void> logout() async {
    _sharedPreferences.remove(prefsKeyIsUserLoggedIn);
  }
}
