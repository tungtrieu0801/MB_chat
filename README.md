# Clean architecture
- Mục tiêu: áp dụng Nguyên lý đảo ngược phụ thuộc (DIP). Các lớp cấp cao như Usecase phải phụ thuộc
- vào abstraction, không phải Implement/Data source.
# DI (Service Locator như Getit)
- Giúp đảm bảo Usecase nhận được interface chuẩn mà nó cần, không cần biết interface được triển khai
- bởi lớp nào.
- Giúp quản lý vòng đời của các đối tượng ở một nơi duy nhất init().
- Mọi thứ cần được đăng kí ở một nơi tập trung.