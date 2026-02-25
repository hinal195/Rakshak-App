import 'package:flutter/material.dart';
import '../models/chat_models.dart';

class GroupCard extends StatelessWidget {
  final ChatGroup group;
  final VoidCallback onJoin;

  const GroupCard({
    super.key,
    required this.group,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onJoin,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(0xFFD96C7C).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.group_rounded,
                        color: Color(0xFFD96C7C),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            group.name,
                            style: TextStyle(
                              color: Color(0xFF2B2B2B),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.people_rounded,
                                size: 14,
                                color: Color(0xFF6F6F6F),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${group.memberCount} members',
                                style: TextStyle(
                                  color: Color(0xFF6F6F6F),
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFE85C6A).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Active',
                        style: TextStyle(
                          color: Color(0xFFE85C6A),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Text(
                  group.description,
                  style: TextStyle(
                    color: Color(0xFF6F6F6F),
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 14,
                      color: Color(0xFF6F6F6F),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${group.radius.toInt()}m radius',
                      style: TextStyle(
                        color: Color(0xFF6F6F6F),
                        fontFamily: 'Poppins',
                        fontSize: 12,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Color(0xFF6F6F6F),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatLastActivity(group.lastMessageAt),
                      style: TextStyle(
                        color: Color(0xFF6F6F6F),
                        fontFamily: 'Poppins',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFE85C6A),
                        Color(0xFFF6A6B2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFE85C6A).withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: onJoin,
                    icon: const Icon(Icons.login_rounded, size: 18),
                    label: const Text(
                      'Join Group',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatLastActivity(DateTime lastMessageAt) {
    final now = DateTime.now();
    final difference = now.difference(lastMessageAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
