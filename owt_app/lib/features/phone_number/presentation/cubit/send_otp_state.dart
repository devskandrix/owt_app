import 'package:equatable/equatable.dart';

enum SendOtpStatus { idle, loading, success, failure }

class SendOtpState extends Equatable {
  final SendOtpStatus status;
  final String? errorMessage;

  const SendOtpState({this.status = SendOtpStatus.idle, this.errorMessage});

  SendOtpState copyWith({SendOtpStatus? status, String? errorMessage}) {
    return SendOtpState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
