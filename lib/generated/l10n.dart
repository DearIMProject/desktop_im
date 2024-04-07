// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `IM App`
  String get title {
    return Intl.message(
      'IM App',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `login`
  String get login {
    return Intl.message(
      'login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Welcome!`
  String get welcome {
    return Intl.message(
      'Welcome!',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `send log`
  String get send_log {
    return Intl.message(
      'send log',
      name: 'send_log',
      desc: '',
      args: [],
    );
  }

  /// `Address Book`
  String get address_book {
    return Intl.message(
      'Address Book',
      name: 'address_book',
      desc: '',
      args: [],
    );
  }

  /// `logout`
  String get logout {
    return Intl.message(
      'logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `success`
  String get success {
    return Intl.message(
      'success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `failure`
  String get failure {
    return Intl.message(
      'failure',
      name: 'failure',
      desc: '',
      args: [],
    );
  }

  /// `please input account or email address`
  String get username_tip {
    return Intl.message(
      'please input account or email address',
      name: 'username_tip',
      desc: '',
      args: [],
    );
  }

  /// `please input password`
  String get password_tip {
    return Intl.message(
      'please input password',
      name: 'password_tip',
      desc: '',
      args: [],
    );
  }

  /// `chat`
  String get chat {
    return Intl.message(
      'chat',
      name: 'chat',
      desc: '',
      args: [],
    );
  }

  /// `addressbook`
  String get addressbook {
    return Intl.message(
      'addressbook',
      name: 'addressbook',
      desc: '',
      args: [],
    );
  }

  /// `account`
  String get account {
    return Intl.message(
      'account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `test`
  String get test {
    return Intl.message(
      'test',
      name: 'test',
      desc: '',
      args: [],
    );
  }

  /// `last year`
  String get last_year {
    return Intl.message(
      'last year',
      name: 'last_year',
      desc: '',
      args: [],
    );
  }

  /// `processing`
  String get processing {
    return Intl.message(
      'processing',
      name: 'processing',
      desc: '',
      args: [],
    );
  }

  /// `failed to load image`
  String get fail_to_load_image {
    return Intl.message(
      'failed to load image',
      name: 'fail_to_load_image',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get message_item_title {
    return Intl.message(
      'Menu',
      name: 'message_item_title',
      desc: '',
      args: [],
    );
  }

  /// `delete`
  String get delete {
    return Intl.message(
      'delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `cancel`
  String get cancel {
    return Intl.message(
      'cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `sure delete current messge?`
  String get delete_content {
    return Intl.message(
      'sure delete current messge?',
      name: 'delete_content',
      desc: '',
      args: [],
    );
  }

  /// `preview`
  String get preview {
    return Intl.message(
      'preview',
      name: 'preview',
      desc: '',
      args: [],
    );
  }

  /// `writting...`
  String get writting {
    return Intl.message(
      'writting...',
      name: 'writting',
      desc: '',
      args: [],
    );
  }

  /// `retry connecting...`
  String get retry_connecting {
    return Intl.message(
      'retry connecting...',
      name: 'retry_connecting',
      desc: '',
      args: [],
    );
  }

  /// `[image]`
  String get chat_user_image {
    return Intl.message(
      '[image]',
      name: 'chat_user_image',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(
          languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
