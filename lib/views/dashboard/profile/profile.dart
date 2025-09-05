import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.blueAccent, Colors.lightBlue], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.network(
                        'https://via.placeholder.com/150',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'John Doe',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text('johndoe@example.com', style: TextStyle(fontSize: 16, color: Colors.white70)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'User Details',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(Icons.person, 'Username', 'john doe123'),
                      const Divider(),
                      _buildDetailRow(Icons.phone, 'Phone', '+1 234 567 890'),
                      const Divider(),
                      _buildDetailRow(Icons.location_on, 'Location', 'New York, USA'),
                      const Divider(),
                      _buildDetailRow(Icons.work, 'Occupation', 'Software Developer'),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit Profile Clicked')));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Edit Profile', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
              ),
              Text(value, style: const TextStyle(fontSize: 16, color: Colors.black87)),
            ],
          ),
        ],
      ),
    );
  }
}
