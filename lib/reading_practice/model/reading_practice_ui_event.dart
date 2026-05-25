sealed class ReadingPracticeUiEvent {
  const ReadingPracticeUiEvent();
}

final class ReadingPracticeSnackRequested extends ReadingPracticeUiEvent {
  const ReadingPracticeSnackRequested(this.message);
  final String message;
}
