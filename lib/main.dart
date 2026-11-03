
import 'package:flutter/material.dart';
import 'news_service.dart';
import 'model/news_model.dart';

void main() {
  runApp(const NewsFlowApp());
}

class NewsFlowApp extends StatelessWidget {
  const NewsFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    
    


      title: 'NewsFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: HomeScreen(newsService: NewsService()),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final NewsService newsService;


  const HomeScreen({
    super.key,
    required this.newsService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<NewsModel>> newsFuture;


  void selectCategory(String category) {
  setState(() {
    selectedCategory = category;

    newsFuture = widget.newsService.fetchNews(
      category: category == 'All'
          ? null
          : category.toLowerCase(),
    );
  });
}
  final List<String> categories = [
  'All',
  'Technology',
  'Business',
  'Sports',
  'Health',
];

String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    newsFuture = widget.newsService.fetchNews();
  }

  void refreshNews() {
    setState(() {
      newsFuture = widget.newsService.fetchNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(
        child: FutureBuilder<List<NewsModel>>(
          future: newsFuture,
          builder: (context, snapshot) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NewsFlow',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Stay informed, stay ahead.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: refreshNews,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Top Headlines',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                 
                SizedBox(
  height: 42,
  child: ListView(
    scrollDirection: Axis.horizontal,
    children: categories.map((category) {
      final isSelected = selectedCategory == category;

      return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: ChoiceChip(
          label: Text(category),
          selected: isSelected,
          onSelected: (_) => selectCategory(category),
          selectedColor: Colors.black,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
          backgroundColor: Colors.white,
          showCheckmark: false,
        ),
      );
    }).toList(),
  ),
),

const SizedBox(height: 20),


                  // Loading state
                  if (snapshot.connectionState == ConnectionState.waiting)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(),
                      ),
                    )

                  // Error state
                  else if (snapshot.hasError)
                    Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 45,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Could not load news.\n${snapshot.error}',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: refreshNews,
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    )

                  // Empty state
                  else if (!snapshot.hasData || snapshot.data!.isEmpty)
                    const Center(
                      child: Text('No news articles found.'),
                    )

                  // News articles
                  else ...[
                    _featuredNews(snapshot.data!.first),

                    const SizedBox(height: 30),

                    const Text(
                      'Latest News',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    ...snapshot.data!.map(
                      (article) => _newsCard(article),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _featuredNews(NewsModel article) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          _newsImage(
            article.imageUrl,
            height: 230,
            width: double.infinity,
          ),
          Container(
            height: 230,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.85),
                ],
              ),
            ),
          ),
          Positioned(
            left: 15,
            right: 15,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FEATURED',
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  article.source,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _newsCard(NewsModel article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _newsImage(
              article.imageUrl,
              height: 105,
              width: 105,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.source,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  article.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _newsImage(
    String imageUrl, {
    required double height,
    required double width,
  }) {
    if (imageUrl.isEmpty) {
      return Container(
        height: height,
        width: width,
        color: Colors.grey.shade300,
        child: const Icon(Icons.image_not_supported),
      );
    }

    return Image.network(
      imageUrl,
      height: height,
      width: width,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: height,
          width: width,
          color: Colors.grey.shade300,
          child: const Icon(Icons.image_not_supported),
        );
      },
    );
  }
}
