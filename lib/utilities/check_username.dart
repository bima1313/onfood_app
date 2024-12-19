import 'package:onfood/services/cloud/constructor/users.dart';

/// To check if the `username` has already exists
List<String> checkUsername(Iterable<Users> usernames) {
  List<String> usernameData = [];
  for (int i = 0; i < usernames.length; i++) {
    final data = usernames.elementAt(i);
    usernameData.add(data.username);
  }

  return usernameData;
}
