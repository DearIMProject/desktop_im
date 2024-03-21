// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account": MessageLookupByLibrary.simpleMessage("account"),
        "address_book": MessageLookupByLibrary.simpleMessage("Address Book"),
        "addressbook": MessageLookupByLibrary.simpleMessage("addressbook"),
        "chat": MessageLookupByLibrary.simpleMessage("chat"),
        "chat_user_image": MessageLookupByLibrary.simpleMessage("[image]"),
        "fail_to_load_image":
            MessageLookupByLibrary.simpleMessage("failed to load image"),
        "failure": MessageLookupByLibrary.simpleMessage("failure"),
        "last_year": MessageLookupByLibrary.simpleMessage("last year"),
        "login": MessageLookupByLibrary.simpleMessage("login"),
        "logout": MessageLookupByLibrary.simpleMessage("logout"),
        "password_tip":
            MessageLookupByLibrary.simpleMessage("please input password"),
        "send_log": MessageLookupByLibrary.simpleMessage("send log"),
        "success": MessageLookupByLibrary.simpleMessage("success"),
        "test": MessageLookupByLibrary.simpleMessage("test"),
        "title": MessageLookupByLibrary.simpleMessage("IM App"),
        "username_tip": MessageLookupByLibrary.simpleMessage(
            "please input account or email address"),
        "welcome": MessageLookupByLibrary.simpleMessage("Welcome!")
      };
}
