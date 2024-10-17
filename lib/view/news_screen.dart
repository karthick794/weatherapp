import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/view/webview_screen.dart';
import 'package:weatherapp/view_model/weather_news_viewmodel.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    List<String> categoriesList = [
      'General',
      'Entertainment',
      'Health',
      'Sports',
      'Business',
      'Technology'
    ];
    String categoryName = 'General';
    return Scaffold(
      body: Container(
        child: Consumer<WeatherNewsViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (viewModel.newsArticles.isEmpty) {
              return Center(child: Text('No news available'));
            }
            return Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                const Text(
                  "Top Headlines",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoriesList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            categoryName = categoriesList[index];
                            viewModel.fetchNewscategory(categoryName);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: categoryName == categoriesList[index]
                                      ? Colors.blue
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Center(
                                    child: Text(
                                        categoriesList[index].toString(),
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white))),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                // Wrap the ListView.builder with Expanded
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.newsArticles.length,
                    itemBuilder: (context, index) {
                      final article = viewModel.newsArticles[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              // Leading widget with a fixed size
                              Container(
                                width: 80, // Fixed width
                                height: 80, // Fixed height
                                child: article.urlToImage.isNotEmpty
                                    ? Image.network(
                                        article.urlToImage,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.image),
                              ),
                              // Title and subtitle in an expanded widget
                              Expanded(
                                child: ListTile(
                                  title: Text(article.title),
                                  subtitle: Text(article.author),
                                  onTap: () {
                                    _openArticle(context, article.url);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _openArticle(BuildContext context, String url) {
    if (url.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebviewScreen(newsurl: url),
        ),
      );
    }
  }
}
