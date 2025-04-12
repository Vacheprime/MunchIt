/// Utils class is used to store commonly used methods across many classes.
class Utils {
  /// Determines whether a string has invalid header or trailer space characters.
  ///
  /// Returns a boolean indication whether [str] has space characters at its
  /// beginning or end.
  static bool hasInvalidSpaces(String str) {
    RegExp invalidSpaceRegex = RegExp(r"(^\s|\s$)");
    return invalidSpaceRegex.hasMatch(str);
  }
}