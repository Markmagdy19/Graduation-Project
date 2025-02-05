import 'package:flutter/material.dart';
import 'package:Graduation_Project/api/apis.dart';
import 'package:Graduation_Project/models/article_details.dart';

class ArticleDetailsScreen extends StatelessWidget {
  final ArticleDetails article;

  ArticleDetailsScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Title:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(
                height: 12,
              ),
              Text(
                article.pubmedArticleSet?.pubmedArticle?.medlineCitation != null
                    ? ((article.pubmedArticleSet?.pubmedArticle
                                ?.medlineCitation!.article?.articleTitle ??
                            "No Title available")
                        .replaceAll('[', '')
                        .replaceAll(']', ''))
                    : "No Title available",
              ),
              const SizedBox(
                height: 24,
              ),
              const Text('Abstract:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(
                height: 12,
              ),
              Text(
                article.pubmedArticleSet?.pubmedArticle?.medlineCitation != null
                    ? ((article
                                .pubmedArticleSet
                                ?.pubmedArticle
                                ?.medlineCitation!
                                .article
                                ?.abstract
                                ?.abstractText ??
                            "No Abstract available")
                        .replaceAll('[', '')
                        .replaceAll(']', ''))
                    : "No Abstract available",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArticleDetailsPage extends StatefulWidget {
  final String articleId;

  ArticleDetailsPage({required this.articleId});

  @override
  _ArticleDetailsPageState createState() => _ArticleDetailsPageState();
}

class _ArticleDetailsPageState extends State<ArticleDetailsPage> {
  late Future<ArticleDetails> futureArticle;

  @override
  void initState() {
    super.initState();
    futureArticle = APIs.fetchArticleDetails(widget.articleId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Details'),
      ),
      body: FutureBuilder<ArticleDetails>(
        future: futureArticle,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          } else {
            return ArticleDetailsScreen(article: snapshot.data!);
          }
        },
      ),
    );
  }
}
