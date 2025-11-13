enum CallStatus { idle, calling, incoming, inCall }

class CallState {
  final CallStatus status;
  final String? peerId;
  final String? peerName;
  final String? peerAvatar;
  final dynamic sdp; // offer/answer
  final dynamic candidate; // ICE candidate

  const CallState({
    this.status = CallStatus.idle,
    this.peerId,
    this.peerName,
    this.peerAvatar,
    this.sdp,
    this.candidate,
  });

  CallState copyWith({
    CallStatus? status,
    String? peerId,
    String? peerName,
    String? peerAvatar,
    dynamic sdp,
    dynamic candidate,
  }) {
    return CallState(
      status: status ?? this.status,
      peerId: peerId ?? this.peerId,
      peerName: peerName ?? this.peerName,
      peerAvatar: peerAvatar ?? this.peerAvatar,
      sdp: sdp ?? this.sdp,
      candidate: candidate ?? this.candidate,
    );
  }
}
