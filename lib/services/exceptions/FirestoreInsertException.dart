/// FirestoreInsertException is an exception that represents errors
/// during the insertion of data into the firestore.
class FirestoreInsertException implements Exception {
  final String message;
  final Object? error;

  FirestoreInsertException(this.message, [this.error]);

  @override
  String toString() {
    return "FirestoreInsertException{message: {$message}, error: {$error}}";
  }
}