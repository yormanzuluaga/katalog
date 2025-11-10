abstract class Failure implements Exception {}

class GeneralFailure extends Failure {
  final String msg;

  GeneralFailure(this.msg);
}
