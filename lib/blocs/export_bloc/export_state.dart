part of 'export_cubit.dart';

abstract class ExportState extends Equatable {
  const ExportState();
}

class ExportInitial extends ExportState {
  @override
  List<Object> get props => [];
}

class ExportProcessing extends ExportState {
  final double progress;

  const ExportProcessing(this.progress);

  @override
  List<Object> get props => [progress];
}

class ExportCompleted extends ExportState {
  final String path;
  final Duration duration;

  const ExportCompleted(this.path, this.duration);

  @override
  List<Object> get props => [path, duration];
}

class ExportFailed extends ExportState {
  final String message;

  const ExportFailed(this.message);

  @override
  List<Object> get props => [message];
}
