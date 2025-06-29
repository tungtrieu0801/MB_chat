import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Các trường nhập liệu và nút Login như trong ảnh
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: Icon(Icons.visibility),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(value: false, onChanged: (bool? value) {}),
                const Text('Remember me'),
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text('Forgot Password?')),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Xử lý Login
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B8E23), // Màu xanh như trong ảnh
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            const SizedBox(height: 24),
            const Text('Or login with'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Image.asset('assets/google_logo.png', height: 24), // Thay bằng icon Google thực tế
                  label: const Text('Google'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Image.asset('assets/facebook_logo.png', height: 24), // Thay bằng icon Facebook thực tế
                  label: const Text('Facebook'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
