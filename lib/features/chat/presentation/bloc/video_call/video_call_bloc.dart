import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'video_call_event.dart';
import 'video_call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  late RTCPeerConnection _peerConnection;

  CallBloc() : super(const CallState()) {
    // Event handlers
    on<CallMakeEvent>(_onCallMake);
    on<CallIncomingEvent>(_onCallIncoming);
    on<CallAnswerEvent>(_onCallAnswer);
    on<CallHangupEvent>(_onCallHangup);
    on<CallCandidateEvent>(_onCallCandidate);

    _initPeerConnection();
  }

  /// Khởi tạo PeerConnection WebRTC
  Future<void> _initPeerConnection() async {
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ]
    };

    _peerConnection = await createPeerConnection(configuration);

    // Khi có ICE candidate mới
    _peerConnection.onIceCandidate = (RTCIceCandidate candidate) {
      if (state.peerId != null) {
        add(CallCandidateEvent(state.peerId!, candidate));
      }
    };

    // Khi nhận remote track
    _peerConnection.onTrack = (RTCTrackEvent event) {
      // TODO: có thể emit state để UI hiển thị remote stream
    };
  }

  /// Tạo SDP offer khi gọi đi
  Future<RTCSessionDescription> createOffer() async {
    final offer = await _peerConnection.createOffer();
    await _peerConnection.setLocalDescription(offer);
    return offer;
  }

  /// Tạo SDP answer khi nhận cuộc gọi
  Future<RTCSessionDescription> createAnswer() async {
    final answer = await _peerConnection.createAnswer();
    await _peerConnection.setLocalDescription(answer);
    return answer;
  }

  /// --- Event handlers ---
  void _onCallMake(CallMakeEvent event, Emitter<CallState> emit) {
    emit(state.copyWith(
      status: CallStatus.calling,
      peerId: event.peerId,
      peerName: event.peerName,
      peerAvatar: event.peerAvatar,
      sdp: event.sdpOffer,
    ));
    // TODO: gửi offer qua socket đến peer
  }

  void _onCallIncoming(CallIncomingEvent event, Emitter<CallState> emit) {
    emit(state.copyWith(
      status: CallStatus.incoming,
      peerId: event.peerId,
      peerName: event.peerName,
      peerAvatar: event.peerAvatar,
      sdp: event.sdpOffer,
    ));
  }

  void _onCallAnswer(CallAnswerEvent event, Emitter<CallState> emit) async {
    emit(state.copyWith(status: CallStatus.inCall));
    // TODO: gửi answer qua socket
  }

  void _onCallHangup(CallHangupEvent event, Emitter<CallState> emit) {
    emit(state.copyWith(status: CallStatus.idle));
    // TODO: gửi hangup qua socket
  }

  void _onCallCandidate(CallCandidateEvent event, Emitter<CallState> emit) {
    // TODO: gửi ICE candidate qua socket
  }

  /// Getter để UI hoặc service khác lấy peerConnection
  RTCPeerConnection get peerConnection => _peerConnection;
}
