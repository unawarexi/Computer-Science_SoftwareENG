import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Professional Coding Academy",
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Our Courses",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            // Centered image at the top
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  course['image'] ??
                                      'assets/images/default.jpg',
                                  fit: BoxFit.cover,
                                  width: 120,
                                  height: 120,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Title of the course
                            Text(
                              course['title'] ?? 'Course Title Unavailable',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),

                            // Course description
                            Text(
                              course['description'] ??
                                  'No description available',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),

                            // 'Learn More' button at the bottom of the description
                            ElevatedButton(
                              onPressed: () {
                                // Navigate to course details
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                              ),
                              child: const Text("Learn More"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Sample courses data

const List<Map<String, String>> courses = [
  {
    'title': 'Flutter Development',
    'description': 'Learn how to build beautiful mobile apps using Flutter.',
    'image': 'assets/images/home.jpg',
  },
  {
    'title': 'React Development',
    'description':
        'Master React.js to build fast and scalable web applications.',
    'image': 'assets/images/home.jpg',
  },
  {
    'title': 'Python for Data Science',
    'description':
        'Get hands-on experience with Python for data science and AI.',
    'image': 'assets/images/home.jpg',
  },
  {
    'title': 'JavaScript Essentials',
    'description':
        'Understand the fundamentals of JavaScript, the language of the web.',
    'image': 'assets/images/home.jpg',
  },
  {
    'title': 'Full Stack Development',
    'description': 'Become a full-stack developer with MERN stack knowledge.',
    'image': 'assets/images/home.jpg',
  },
];
