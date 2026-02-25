import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../data/api_service/api_service.dart';
import '../model/news.dart';




class NewsTabView extends StatefulWidget {
  @override
  _NewsTabViewState createState() => _NewsTabViewState();
}

class _NewsTabViewState extends State<NewsTabView> {
  late Future<List<NewArticleModel>> futureArticles;

  @override
  void initState() {
    futureArticles = fetchNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFFFBE4E6),
        appBar: AppBar(
          backgroundColor: Color(0xFFFBE4E6),
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF2B2B2B)),
          title: Text(
            'News & Reports',
            style: TextStyle(
              color: Color(0xFF2B2B2B),
              fontWeight: FontWeight.w600,
              fontSize: 22,
              fontFamily: 'Poppins',
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Color(0xFFFFF7EE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: Color(0xFFE85C6A),
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Color(0xFF6F6F6F),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),
                tabs: [
                  Tab(text: 'News'),
                  Tab(text: 'Reports'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              color: Color(0xFFFBE4E6),
              child: FutureBuilder<List<NewArticleModel>>(
                future: futureArticles,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFE85C6A),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Color(0xFFE85C6A).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.error_outline_rounded,
                                color: Color(0xFFE85C6A),
                                size: 32,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Failed to load news',
                              style: TextStyle(
                                color: Color(0xFF2B2B2B),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              snapshot.error.toString().replaceAll('Exception: ', ''),
                              style: TextStyle(
                                color: Color(0xFF6F6F6F),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    final articles = snapshot.data!;
                    if (articles.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Color(0xFF6F6F6F).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.newspaper_outlined,
                                color: Color(0xFF6F6F6F),
                                size: 32,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No news articles available',
                              style: TextStyle(
                                color: Color(0xFF2B2B2B),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Check back later for safety-related news',
                              style: TextStyle(
                                color: Color(0xFF6F6F6F),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return _buildModernNewsCard(context, article);
                      },
                    );
                  }
                },
              ),
            ),
            Container(
              color: Color(0xFFFBE4E6),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('ReportIncidents').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFE85C6A),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Color(0xFFE85C6A).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.error_outline,
                              color: Color(0xFFE85C6A),
                              size: 32,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Failed to load reports',
                            style: TextStyle(
                              color: Color(0xFF2B2B2B),
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${snapshot.error}',
                            style: TextStyle(
                              color: Color(0xFF6F6F6F),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Color(0xFFF6A6B2).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.report_outlined,
                                color: Color(0xFFF6A6B2),
                                size: 32,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No reports found',
                              style: TextStyle(
                                color: Color(0xFF2B2B2B),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Be the first to report an incident',
                              style: TextStyle(
                                color: Color(0xFF6F6F6F),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    final reports = snapshot.data!.docs;
                    return ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        final report = reports[index];
                        return _buildModernReportCard(
                          context,
                          city: report['IncidentCity'],
                          description: report['IncidentDescription'],
                          fullName: report['FullName'],
                          phoneNo: report['PhoneNo'],
                          time: report['IncidentDate'].toDate(),
                          type: report['TitleIncident'],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernNewsCard(BuildContext context, NewArticleModel article) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFFF6A6B2).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'News',
                      style: TextStyle(
                        color: Color(0xFFE85C6A),
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(0xFFF6A6B2).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.newspaper_rounded,
                      color: Color(0xFFE85C6A),
                      size: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                article.title,
                style: TextStyle(
                  color: Color(0xFF2B2B2B),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12),
              Text(
                article.description ?? 'No description available',
                style: TextStyle(
                  color: Color(0xFF6F6F6F),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildModernReportCard(BuildContext context, {
    required String city,
    required String description,
    required String fullName,
    required String phoneNo,
    required DateTime time,
    required String type,
  }) {
    Color categoryColor = _getCategoryColor(type);
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        color: categoryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(0xFFD96C7C).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.location_on_rounded,
                      color: Color(0xFFD96C7C),
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    city,
                    style: TextStyle(
                      color: Color(0xFF6F6F6F),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                description,
                style: TextStyle(
                  color: Color(0xFF2B2B2B),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Color(0xFFF6A6B2).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: Color(0xFFE85C6A),
                      size: 14,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    fullName,
                    style: TextStyle(
                      color: Color(0xFF6F6F6F),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Color(0xFF6F6F6F).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.access_time_rounded,
                      color: Color(0xFF6F6F6F),
                      size: 14,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    _formatTime(time),
                    style: TextStyle(
                      color: Color(0xFF6F6F6F),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }

  Color _getCategoryColor(String type) {
    String lowerType = type.toLowerCase();
    if (lowerType.contains('domestic') || lowerType.contains('violence')) {
      return Color(0xFFE85C6A);
    } else if (lowerType.contains('online') || lowerType.contains('harassment')) {
      return Color(0xFFD96C7C);
    } else if (lowerType.contains('safety') || lowerType.contains('tip')) {
      return Color(0xFFF6A6B2);
    } else {
      return Color(0xFFE85C6A);
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
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
