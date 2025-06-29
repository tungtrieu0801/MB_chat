class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FetchMessagesUseCase fetchMessages;
  final SendMessageUseCase sendMessage;

  ChatBloc(this.fetchMessages, this.sendMessage) : super(ChatInitial()) {
    on<LoadChat>((event, emit) async {
      emit(ChatLoading());
      try {
        final messages = await fetchMessages(event.roomId);
        emit(ChatLoaded(messages));
      } catch (e) {
        emit(ChatError('Không tải được tin nhắn'));
      }
    });

    on<SendMessage>((event, emit) async {
      try {
        await sendMessage(event.roomId, event.content);
        add(LoadChat(event.roomId)); // Tải lại sau khi gửi
      } catch (e) {
        emit(ChatError('Không gửi được tin nhắn'));
      }
    });
  }
}
