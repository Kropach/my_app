import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_app/models/booknote.dart';
import 'package:my_app/models/booknote_list.dart';
import 'package:my_app/parallax.dart';

class BooknoteParalax extends StatelessWidget {
  const BooknoteParalax({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (final booknote in booknotes)
            BooknoteList(
              text: booknote.text,
              author: booknote.author,
              title: booknote.title,
            ),
        ],
      ),
    );
  }
}


class ParallaxParentData extends ContainerBoxParentData<RenderBox> {}

class RenderParallax extends RenderBox
    with RenderObjectWithChildMixin<RenderBox>, RenderProxyBoxMixin {
  RenderParallax({
    required ScrollableState scrollable,
  }) : _scrollable = scrollable;

  ScrollableState _scrollable;

  ScrollableState get scrollable => _scrollable;

  set scrollable(ScrollableState value) {
    if (value != _scrollable) {
      if (attached) {
        _scrollable.position.removeListener(markNeedsLayout);
      }
      _scrollable = value;
      if (attached) {
        _scrollable.position.addListener(markNeedsLayout);
      }
    }
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    _scrollable.position.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    _scrollable.position.removeListener(markNeedsLayout);
    super.detach();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! ParallaxParentData) {
      child.parentData = ParallaxParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    // Force the background to take up all available width
    // and then scale its height based on the image's aspect ratio.
    final background = child!;
    final backgroundImageConstraints =
    BoxConstraints.tightFor(width: size.width);
    background.layout(backgroundImageConstraints, parentUsesSize: true);

    // Set the background's local offset, which is zero.
    (background.parentData as ParallaxParentData).offset = Offset.zero;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Get the size of the scrollable area.
    final viewportDimension = scrollable.position.viewportDimension;

    // Calculate the global position of this list item.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final backgroundOffset =
    localToGlobal(size.centerLeft(Offset.zero), ancestor: scrollableBox);

    // Determine the percent position of this list item within the
    // scrollable area.
    final scrollFraction =
    (backgroundOffset.dy / viewportDimension).clamp(0.0, 1.0);

    // Calculate the vertical alignment of the background
    // based on the scroll percent.
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    // Convert the background alignment into a pixel offset for
    // painting purposes.
    final background = child!;
    final backgroundSize = background.size;
    final listItemSize = size;
    final childRect =
    verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    // Paint the background.
    context.paintChild(
        background,
        (background.parentData as ParallaxParentData).offset +
            offset +
            Offset(0.0, childRect.top));
  }
}

const urlPrefix =
    'https://docs.flutter.dev/cookbook/img-files/effects/parallax';
const booknotes = [
  Booknote(
    title: 'Mount Rushmore',
    author: 'U.S.A',
    text: '$urlPrefix/05-ba$urlPrefix/05-bali.jpgfsdhgfkjhdsbckaslvdcjhvasdlc ksdjc skdjabc;shadv c;haskbvcks;adbc;khsad;vcb;jhsadvc;jhasdvc;hsavcas;kbca;sdbc;kasdc;jksabc hjsd vcjhsaldvchsavcdisa;li.jpgfsdhgfkjhdsbckaslvdcjhvasdlc ksdjc skdjabc;shadv c;haskbvcks;adbc;khsad;vcb;jhsadvc;jhasdvc;hsavcas;kbca;sdbc;kasdc;jksabc hjsd vcjhsaldvchsavcdisa;',
  ),
  Booknote(
    title: 'Gardens By The Bay',
    author: 'Singapore',
    text: '$urlPrefix/05-bali.jpgf$urlPrefix/05-bali.jpgfsdhgfkjhdsbckaslvdcjhvasdlc ksdjc skdjabc;shadv c;haskbvcks;adbc;khsad;vcb;jhsadvc;jhasdvc;hsavcas;kbca;sdbc;kasdc;jksabc hjsd vcjhsaldvchsavcdisa;sdhgfkjhdsbckaslvdcjhvasdlc ksdjc skdjabc;shadv c;haskbvcks;adbc;khsad;vcb;jhsadvc;jhasdvc;hsavcas;kbca;sdbc;kasdc;jksabc hjsd vcjhsaldvchsavcdisa;',
  ),
  Booknote(
    title: 'Machu Picchu',
    author: 'Peru',
    text: '$urlPrefix/05-bali.jpgfsdhgfkjhdsbckaslvdcjhvasdlc ksdjc skdjabc;shadv c;haskbvcks;adbc;khsad;vcb;jhsadvc;jhasdvc;hsavcas;kbca;sdbc;kasdc;jksabc hjsd vcjhsaldvchsavcdisa;$urlPrefix/05-bali.jpgfsdhgfkjhdsbckaslvdcjhvasdlc ksdjc skdjabc;shadv c;haskbvcks;adbc;khsad;vcb;jhsadvc;jhasdvc;hsavcas;kbca;sdbc;kasdc;jksabc hjsd vcjhsaldvchsavcdisa;',
  ),
  Booknote(
    title: 'Vitznau',
    author: 'Switzerland',
    text: '$urlPrefix/04-vitznau.jpg',
  ),
  Booknote(
    title: 'Bali',
    author: 'Indonesia',
    text: '$urlPrefix/05-bali.jpgfsdhgfkjhdsbckaslvdcjhvasdlc ksdjc skdjabc;shadv c;haskbvcks;adbc;khsad;vcb;jhsadvc;jhasdvc;hsavcas;kbca;sdbc;kasdc;jksabc hjsd vcjhsaldvchsavcdisa;',
  ),
  Booknote(
    title: 'Mexico City',
    author: 'Mexico',
    text: '$urlPrefix/06-mexico-city.jpg',
  ),
  Booknote(
    title: 'Cairo',
    author: 'Egypt',
    text: '$urlPrefix/07-cairo.jpg',
  ),
  Booknote(
    title: 'Cairo',
    author: 'Egypt',
    text: '$urlPrefix/07-cairo.jpg',
  ),
  Booknote(
    title: 'Cairo',
    author: 'Egypt',
    text: '$urlPrefix/07-cairo.jpg',
  ),
  Booknote(
    title: 'Cairo',
    author: 'Egypt',
    text: '$urlPrefix/07-cairo.jpg',
  ),
  Booknote(
    title: 'Cairo',
    author: 'Egypt',
    text: '$urlPrefix/07-cairo.jpg',
  ),
  Booknote(
    title: 'Cairo',
    author: 'Egypt',
    text: '$urlPrefix/07-cairo.jpg',
  ),
  Booknote(
    title: 'Cairo',
    author: 'Egypt',
    text: '$urlPrefix/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg/07-cairo.jpg',
  ),
];