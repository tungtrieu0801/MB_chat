import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract class CallEvent {}

class CallMakeEvent extends CallEvent {
  final String peerId;
  final String peerName;
  final String? peerAvatar;
  final RTCSessionDescription sdpOffer;

  CallMakeEvent({
    required this.peerId,
    required this.peerName,
    this.peerAvatar,
    required this.sdpOffer,
  });
}

class CallIncomingEvent extends CallEvent {
  final String peerId;
  final dynamic sdpOffer;
  final String peerName;
  final String? peerAvatar;

  CallIncomingEvent(this.peerId, this.sdpOffer, this.peerName, {this.peerAvatar});
}

class CallAnswerEvent extends CallEvent {
  final String peerId;
  final dynamic sdpAnswer;

  CallAnswerEvent(this.peerId, this.sdpAnswer);
}

class CallHangupEvent extends CallEvent {
  final String peerId;
  CallHangupEvent(this.peerId);
}

class CallCandidateEvent extends CallEvent {
  final String peerId;
  final dynamic candidate;

  CallCandidateEvent(this.peerId, this.candidate);
}
