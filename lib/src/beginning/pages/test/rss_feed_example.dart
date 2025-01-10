import 'package:dart_rss/dart_rss.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RssFeedExample extends StatefulWidget {
  const RssFeedExample({super.key});

  @override
  RssFeedExampleState createState() => RssFeedExampleState();
}

class RssFeedExampleState extends State<RssFeedExample> {
  final String rssUrl =
      'https://anchor.fm/s/ffb9e650/podcast/rss'; // Replace with your RSS feed URL
  RssFeed? _feed;

  @override
  void initState() {
    super.initState();
    _loadFeed();
  }

  Future<void> _loadFeed() async {
    try {
      final response = await http.get(Uri.parse(rssUrl));
      if (response.statusCode == 200) {
        final rssFeed = RssFeed.parse(response.body);
        setState(() {
          _feed = rssFeed;
        });
      } else {
        throw Exception('Failed to load feed');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('RSS Feed Example'),
      ),
      body: _feed == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _feed!.items.length,
              itemBuilder: (context, index) {
                final item = _feed!.items[index];
                return ListTile(
                  title: Text(item.title ?? 'No Title'),
                  subtitle: Text(item.pubDate ?? 'No Date'),
                  onTap: () {
                    // Handle item click
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(item: item),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final RssItem item;

  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text(item.title ?? 'Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title ?? 'No Title',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(item.pubDate ?? 'No Date',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text(item.description ?? 'No Description'),
            const SizedBox(height: 16),
            Text(item.enclosure?.url ?? 'No Description'),
          ],
        ),
      ),
    );
  }
}
