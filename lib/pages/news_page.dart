import 'package:flutter/material.dart';
import 'package:marketlens/widgets/news_article.dart';
import 'package:provider/provider.dart';
import 'package:marketlens/market_state.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final market = context.watch<MarketState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Market News "),
        centerTitle: true,
      ),
      body: SafeArea(
        child: market.isLoading
            ? const Center(child: CircularProgressIndicator())
            : market.error != null
                ? Center(
                    child: Text(
                      market.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : market.news.isEmpty
                    ? const Center(
                        child: Text(
                          "No news available",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: market.news.length,
                        separatorBuilder: (_, __) =>
                            const Divider(thickness: 0.4),
                        itemBuilder: (context, index) {
  final article = market.news[index];

  return ListTile(
    leading: const Icon(Icons.article_outlined),
    title: Text(
      article.title,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Text(
          article.source,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        if (article.description != null) ...[
          const SizedBox(height: 6),
          Text(
            article.description!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
        ]
      ],
    ),
    onTap: () {
      _showNewsActions(context, article);
    },
  );
}
,
                      ),
      ),
    );
  }

  void _showNewsActions(BuildContext context, NewsArticle article) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_browser),
              title: const Text("Read full article"),
              onTap: () {
                Navigator.pop(context);
                // TODO: launchUrl(article.url)
              },
            ),
            ListTile(
              leading: const Icon(Icons.smart_toy_outlined),
              title: const Text("Ask AI about this news"),
              onTap: () {
                Navigator.pop(context);
                // Navigate to assistant with prefilled question
                Navigator.pushNamed(
                  context,
                  "/assistant",
                  arguments:
                      "Explain this news and its market impact:\n${article.title}",
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

}
