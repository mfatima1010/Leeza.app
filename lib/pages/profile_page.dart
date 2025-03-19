// import 'package:flutter/material.dart';
// import '../utils/app_colors.dart';
// import '../utils/app_text_styles.dart';

// class ProfilePage extends StatelessWidget {
//   // Dummy data - will be replaced with actual data later
//   final Map<String, dynamic> userData = {
//     'name': 'John Doe',
//     'lastAssessment': {
//       'date': '15 March 2024',
//       'score': '85/100',
//       'status': 'Completed',
//     },
//     'service': 'Premium Consultation Package',
//     'consultation': {
//       'date': '20 March 2024',
//       'time': '10:30 AM',
//     },
//     'stories': [
//       {
//         'title': 'My Journey to Recovery',
//         'date': '12 March 2024',
//         'likes': 24,
//       },
//       {
//         'title': 'Finding Inner Peace',
//         'date': '5 March 2024',
//         'likes': 18,
//       },
//       {
//         'title': 'A New Beginning',
//         'date': '28 Feb 2024',
//         'likes': 31,
//       },
//     ],
//   };

//   @override
//   Widget build(BuildContext context) {
//     final Color pinkishColor = const Color(0xFFE5A0FF);
//     final Color yellowishColor = const Color(0xFFFFD27A);

//     return Scaffold(
//       backgroundColor: yellowishColor.withOpacity(0.1),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Gradient header with profile info
//             Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [pinkishColor, yellowishColor],
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                 ),
//               ),
//               child: SafeArea(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
//                   child: Column(
//                     children: [
//                       // Profile Avatar
//                       Container(
//                         padding: const EdgeInsets.all(4),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: Colors.white.withOpacity(0.5),
//                             width: 2,
//                           ),
//                         ),
//                         child: CircleAvatar(
//                           radius: 50,
//                           backgroundColor: Colors.white.withOpacity(0.3),
//                           child: Text(
//                             userData['name'].substring(0, 1),
//                             style: const TextStyle(
//                               fontSize: 36,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         userData['name'],
//                         style: const TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             // Content with negative margin for overlap effect
//             Transform.translate(
//               offset: const Offset(0, -24),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Column(
//                   children: [
//                     _buildInfoSection(pinkishColor),
//                     const SizedBox(height: 24),
//                     _buildStoriesSection(pinkishColor),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoSection(Color accentColor) {
//     return Column(
//       children: [
//         _buildInfoCard(
//           'Latest Assessment',
//           Icons.assessment,
//           accentColor,
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildInfoRow('Date', userData['lastAssessment']['date']),
//               const SizedBox(height: 8),
//               _buildInfoRow('Score', userData['lastAssessment']['score']),
//               const SizedBox(height: 8),
//               _buildInfoRow('Status', userData['lastAssessment']['status']),
//             ],
//           ),
//         ),
//         const SizedBox(height: 16),
//         _buildInfoCard(
//           'Service Details',
//           Icons.medical_services,
//           accentColor,
//           Text(
//             userData['service'],
//             style: const TextStyle(
//               fontSize: 16,
//               color: Colors.black87,
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         _buildInfoCard(
//           'Next Consultation',
//           Icons.calendar_today,
//           accentColor,
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildInfoRow('Date', userData['consultation']['date']),
//               const SizedBox(height: 8),
//               _buildInfoRow('Time', userData['consultation']['time']),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             color: Colors.grey,
//           ),
//         ),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 14,
//             color: Colors.black87,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoCard(
//       String title, IconData icon, Color accentColor, Widget content) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, color: accentColor),
//                 const SizedBox(width: 12),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: accentColor,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             content,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStoriesSection(Color accentColor) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.book, color: accentColor),
//                 const SizedBox(width: 12),
//                 Text(
//                   'Your Stories',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: accentColor,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             ...userData['stories']
//                 .map<Widget>((story) => _buildStoryCard(story, accentColor))
//                 .toList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStoryCard(Map<String, dynamic> story, Color accentColor) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         border: Border.all(color: accentColor.withOpacity(0.2)),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ListTile(
//         title: Text(
//           story['title'],
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         subtitle: Text(
//           'Posted on ${story["date"]}',
//           style: TextStyle(
//             color: Colors.grey[600],
//           ),
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               Icons.favorite,
//               color: accentColor,
//               size: 20,
//             ),
//             const SizedBox(width: 4),
//             Text(
//               '${story["likes"]}',
//               style: const TextStyle(
//                 color: Colors.black87,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:assessment_leeza_app/core/auth_service.dart';
import 'package:assessment_leeza_app/pages/login_page.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class ProfilePage extends StatelessWidget {
  // Dummy data - will be replaced with actual data later
  final Map<String, dynamic> userData = {
    'name': 'John Doe',
    'lastAssessment': {
      'date': '15 March 2024',
      'score': '85/100',
      'status': 'Completed',
    },
    'service': 'Premium Consultation Package',
    'consultation': {
      'date': '20 March 2024',
      'time': '10:30 AM',
    },
    'stories': [
      {
        'title': 'My Journey to Recovery',
        'date': '12 March 2024',
        'likes': 24,
      },
      {
        'title': 'Finding Inner Peace',
        'date': '5 March 2024',
        'likes': 18,
      },
      {
        'title': 'A New Beginning',
        'date': '28 Feb 2024',
        'likes': 31,
      },
    ],
  };

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final Color pinkishColor = const Color(0xFFE5A0FF);
    final Color yellowishColor = const Color(0xFFFFD27A);

    return Scaffold(
      backgroundColor: yellowishColor.withOpacity(0.1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Gradient header with profile info
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [pinkishColor, yellowishColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
                  child: Column(
                    children: [
                      // Profile Avatar
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          child: Text(
                            userData['name'].substring(0, 1),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userData['name'],
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Content with negative margin for overlap effect
              Transform.translate(
                offset: const Offset(0, -24),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildInfoSection(pinkishColor),
                      const SizedBox(height: 24),
                      _buildStoriesSection(pinkishColor),
                      const SizedBox(height: 24), // Spacer before logout
                      _buildLogoutButton(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(Color accentColor) {
    return Column(
      children: [
        _buildInfoCard(
          'Latest Assessment',
          Icons.assessment,
          accentColor,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Date', userData['lastAssessment']['date']),
              const SizedBox(height: 8),
              _buildInfoRow('Score', userData['lastAssessment']['score']),
              const SizedBox(height: 8),
              _buildInfoRow('Status', userData['lastAssessment']['status']),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          'Service Details',
          Icons.medical_services,
          accentColor,
          Text(
            userData['service'],
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          'Next Consultation',
          Icons.calendar_today,
          accentColor,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Date', userData['consultation']['date']),
              const SizedBox(height: 8),
              _buildInfoRow('Time', userData['consultation']['time']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      String title, IconData icon, Color accentColor, Widget content) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: accentColor),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildStoriesSection(Color accentColor) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.book, color: accentColor),
                const SizedBox(width: 12),
                Text(
                  'Your Stories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...userData['stories']
                .map<Widget>((story) => _buildStoryCard(story, accentColor))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryCard(Map<String, dynamic> story, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: accentColor.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          story['title'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          'Posted on ${story["date"]}',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite,
              color: accentColor,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              '${story["likes"]}',
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ElevatedButton(
        onPressed: () async {
          final error = await _authService.signOut();
          if (error == null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error)),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE5A0FF), Color(0xFFFFD27A)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.logout, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
