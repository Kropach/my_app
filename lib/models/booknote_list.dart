import 'package:flutter/material.dart';
import 'package:my_app/common/paralax_flow_delegate.dart';
import 'package:my_app/pages/create_bookmark.dart';


class BooknoteList extends StatelessWidget {
  BooknoteList({
    super.key,
    required this.id,
    required this.title,
    required this.author,
    required this.text
  });

  final String id;
  final String title;
  final String author;
  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color(-7840182),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: Colors.black, width: 1.0),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateBookmark(id: id, author: author,
                  title: title, text: text),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: AspectRatio(
            aspectRatio: 16 / 4,
            child: Stack(
                children: [
                  _buildParallaxBackground(context),
                  _buildGradient(),
                  _buildTitleAndSubtitle(),
                ],
              ),
            )
        ),
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context),
        listItemContext: context,
        text: text,
      ),
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Text(text)
        )
      ],
    );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Colors.transparent,
              Colors.black.withOpacity(0.15),
              Colors.black.withOpacity(0.25),
              Colors.black.withOpacity(0.35),
              Colors.black.withOpacity(0.45),
              Colors.black.withOpacity(0.55),
              Colors.black.withOpacity(0.65),
              Colors.black.withOpacity(0.75)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.4, 0.5, 0.55, 0.6, 0.7, 0.8, 0.9, 1],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle() {
    return Positioned(
      left: 13,
      bottom: 7,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            author,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
