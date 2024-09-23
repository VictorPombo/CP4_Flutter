import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/widgets/custom_card_thumbnail.dart';
import 'package:movie_app/pages/movie_detail/movie_detail_page.dart'; 

class NowPlayingList extends StatefulWidget {
  final Result result;
  const NowPlayingList({super.key, required this.result});

  @override
  State<NowPlayingList> createState() => _NowPlayingListState();
}

class _NowPlayingListState extends State<NowPlayingList> {
  final PageController _pageController = PageController(viewportFraction: 0.9);

  int currentPage = 0;
  final maxItems = 5;

  @override
  Widget build(BuildContext context) {
    final totalItems = widget.result.movies.length;

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Stack(
            children: [
              PageView.builder(
                physics: const ClampingScrollPhysics(),
                controller: _pageController,
                itemCount: totalItems > maxItems ? maxItems : totalItems,
                itemBuilder: (context, index) {
                  final movie = widget.result.movies[index]; 
                  final imgUrl = movie.posterPath;

                  return GestureDetector(
                    onTap: () {
                      // Redireciona para a página de detalhes ao clicar no item
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailPage(movieId: movie.id),
                        ),
                      );
                    },
                    child: CustomCardThumbnail(
                      imageAsset: imgUrl,
                    ),
                  );
                },
                onPageChanged: (int page) {
                  setState(() {
                    currentPage = page;
                  });
                },
              ),
              
              Positioned(
                left: 10,
                top: MediaQuery.of(context).size.height * 0.2,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: currentPage > 0
                      ? () {
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                ),
              ),
              Positioned(
                right: 10,
                top: MediaQuery.of(context).size.height * 0.2,
                child: IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  color: Colors.white,
                  onPressed: currentPage < totalItems - 1
                      ? () {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildPageIndicators(),
        ),
      ],
    );
  }

  List<Widget> _buildPageIndicators() {
    final totalItems = widget.result.movies.length;
    final int to = totalItems > maxItems ? maxItems : totalItems;

    List<Widget> list = [];
    for (int i = 0; i < to; i++) {
      list.add(
          i == currentPage ? _buildIndicator(true) : _buildIndicator(false));
    }
    return list;
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
