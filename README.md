# Clean architecture
- Mục tiêu: áp dụng Nguyên lý đảo ngược phụ thuộc (DIP). Các lớp cấp cao như Usecase phải phụ thuộc
- vào abstraction, không phải Implement/Data source.
# DI (Service Locator như Getit)
- Giúp đảm bảo Usecase nhận được interface chuẩn mà nó cần, không cần biết interface được triển khai
- bởi lớp nào.
- Giúp quản lý vòng đời của các đối tượng ở một nơi duy nhất init().
- Mọi thứ cần được đăng kí ở một nơi tập trung.
# Equatable
- Đây là package giúp định nghĩa cách so sánh 2 object có bằng nhau hay không mà không cần override
- '==' và 'hashcode' thủ công.
- Bloc cần equal vì nó hoạt động dựa trên việc so sánh state/event cũ và mới. Nếu emit 2 state có
- giá trị giống nhau, Bloc sẽ không rebuild UI, Bloc xác định bằng so sánh '==' giữa 2 state/event

# WebRTC: Web real time communication
- Cho phép trực tiếp gửi audio/video/data giữa 2 client(P2P) qua internet.
- Ưu điểm: Realtime, low-latency, không cần server để steam audio/video (chỉ dùng để signaling)
- Signaling là quá trình trao đổi thông tin giữa 2 client (IP, port, codec audio/video)
## Offer/Answer
- Caller A tạo Offer -> mô tả cách kết nối (SDP) -> gửi cho Callee B
- Callee B nhận Offer -> tạo Answer -> gửi lại cho Caller => Success
## ICE candidates
- Để kết nối P2P, WebRTC cần IP+Port thật của 2 client để vượt NAT/Router
- ICE Candidate = một địa chỉ có thể kết nối.
- 2 client gửi ICE Candidates qua signaling để tìm ra đường đi tốt nhất.
## Signaling server
- Là server trung gian chỉ truyền offer/answer + ice candidates
- Không truyền audio/video.