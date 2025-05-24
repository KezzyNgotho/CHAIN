import 'package:flutter/material.dart';
import '../components/curation/content_card.dart';
import '../models/content.dart';

class CurationScreen extends StatefulWidget {
  const CurationScreen({Key? key}) : super(key: key);

  @override
  State<CurationScreen> createState() => _CurationScreenState();
}

class _CurationScreenState extends State<CurationScreen> {
  final List<Content> _contents = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'News', 'Analysis', 'Discussion'];

  @override
  void initState() {
    super.initState();
    _loadContents();
  }

  Future<void> _loadContents() async {
    // TODO: Implement content loading from backend
    setState(() {
      _isLoading = false;
    });
  }

  void _handleUpvote(Content content) {
    // TODO: Implement upvote functionality
  }

  void _handleDownvote(Content content) {
    // TODO: Implement downvote functionality
  }

  void _handleReport(Content content) {
    // TODO: Implement report functionality
  }

  void _handleShare(Content content) {
    // TODO: Implement share functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Content Curation'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ListView.builder(
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_categories[index]),
                        selected: _categories[index] == _selectedCategory,
                        onTap: () {
                          setState(() {
                            _selectedCategory = _categories[index];
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _contents.length,
              itemBuilder: (context, index) {
                final content = _contents[index];
                return ContentCard(
                  content: content,
                  onUpvote: () => _handleUpvote(content),
                  onDownvote: () => _handleDownvote(content),
                  onReport: () => _handleReport(content),
                  onShare: () => _handleShare(content),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to content creation screen
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
