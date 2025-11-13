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