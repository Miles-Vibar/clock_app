class Pages {
  static const alarm = 'Alarm';
  static const clock = 'Clock';
  static const stopwatch = 'Stopwatch';
  static const timer = 'Timer';
}

class SqliteStatements {
  static const createTimezones = 'CREATE TABLE ${Tables.timezone}(id INTEGER PRIMARY KEY, location TEXT NOT NULL UNIQUE)';
  static const dropTimezones = 'DROP TABLE ${Tables.timezone}';
}

class Tables {
  static const timezone = 'timezones';
}