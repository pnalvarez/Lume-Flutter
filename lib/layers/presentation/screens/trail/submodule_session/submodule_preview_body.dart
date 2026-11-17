import 'package:flutter/material.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_chrome.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/loaders/circular_loader.dart';
import 'package:lume_design_system/molecules/progress/slide_dots_indicator.dart';

/// Preview step UI. No Bloc, router, or GetIt — safe for Widgetbook.
///
/// With [slides] (introduction, elaboration, conclusion) it shows one slide at
/// a time with a dots indicator. With no slides it falls back to the single
/// [preview] block.
class SubmodulePreviewBody extends StatelessWidget {
  const SubmodulePreviewBody({
    super.key,
    required this.isLoading,
    required this.onBack,
    required this.onContinue,
    required this.onRetry,
    this.onSlideChanged,
    this.progressValue = 0,
    this.title = '',
    this.preview = '',
    this.slides = const [],
    this.currentSlideIndex = 0,
    this.showSlideIndicator = false,
    this.imageUrl,
    this.errorMessage,
  });

  final bool isLoading;
  final double progressValue;
  final String title;
  final String preview;

  /// Slide texts in display order. Empty means "use [preview]".
  final List<String> slides;
  final int currentSlideIndex;
  final bool showSlideIndicator;
  final String? imageUrl;
  final String? errorMessage;
  final VoidCallback onBack;
  final VoidCallback onContinue;
  final VoidCallback onRetry;

  /// Called with the new index when the user swipes to another slide.
  final ValueChanged<int>? onSlideChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SubmoduleSessionChrome(
      progressValue: progressValue,
      onBack: onBack,
      child: switch ((isLoading, errorMessage)) {
        (true, _) => const Center(child: CircularLoader()),
        (_, final String message) => Padding(
          padding: const EdgeInsets.all(AppSpacings.xl2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: typ.body3Light.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacings.l),
              LumeButton(
                label: trailSessionRetry,
                type: LumeButtonType.outlined,
                onPressed: onRetry,
              ),
            ],
          ),
        ),
        _ when slides.isEmpty => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _SlidePage(
                title: title,
                text: preview,
                imageUrl: imageUrl,
              ),
            ),
            _ContinueBar(onContinue: onContinue),
          ],
        ),
        _ => _SlidesPreview(
          slides: slides,
          currentSlideIndex: currentSlideIndex,
          showIndicator: showSlideIndicator,
          title: title,
          imageUrl: imageUrl,
          onSlideChanged: onSlideChanged,
          onContinue: onContinue,
        ),
      },
    );
  }
}

/// Swipeable slides + dots + Continue. Owns only the [PageController], kept in
/// sync with [currentSlideIndex] (which lives on the session state).
class _SlidesPreview extends StatefulWidget {
  const _SlidesPreview({
    required this.slides,
    required this.currentSlideIndex,
    required this.showIndicator,
    required this.title,
    required this.onContinue,
    this.imageUrl,
    this.onSlideChanged,
  });

  final List<String> slides;
  final int currentSlideIndex;
  final bool showIndicator;
  final String title;
  final String? imageUrl;
  final ValueChanged<int>? onSlideChanged;
  final VoidCallback onContinue;

  @override
  State<_SlidesPreview> createState() => _SlidesPreviewState();
}

class _SlidesPreviewState extends State<_SlidesPreview> {
  static const _pageDuration = Duration(milliseconds: 300);

  late final PageController _controller = PageController(initialPage: _index);

  int get _index => widget.currentSlideIndex.clamp(0, widget.slides.length - 1);

  @override
  void didUpdateWidget(covariant _SlidesPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Continue / back changed the state index: bring the pager along. A swipe
    // already sits on the right page, so nothing animates in that case.
    final page = _controller.hasClients ? _controller.page?.round() : null;
    if (page != null && page != _index) {
      _controller.animateToPage(
        _index,
        duration: _pageDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.slides.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: total,
            onPageChanged: widget.onSlideChanged,
            itemBuilder: (context, i) => _SlidePage(
              title: widget.title,
              text: widget.slides[i],
              // The image belongs to the introduction only.
              imageUrl: i == 0 ? widget.imageUrl : null,
            ),
          ),
        ),
        if (widget.showIndicator)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacings.s),
            child: Center(
              child: SlideDotsIndicator(
                count: total,
                currentIndex: _index,
                semanticsLabel: trailPreviewSlideLabel(
                  current: _index + 1,
                  total: total,
                ),
              ),
            ),
          ),
        _ContinueBar(onContinue: widget.onContinue),
      ],
    );
  }
}

class _SlidePage extends StatelessWidget {
  const _SlidePage({required this.text, this.imageUrl, this.title = ''});

  final String text;
  final String? imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final image = imageUrl?.trim();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacings.xl2,
        AppSpacings.m,
        AppSpacings.xl2,
        AppSpacings.l,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (image != null && image.isNotEmpty) ...[
            _PreviewImage(url: image),
            const SizedBox(height: AppSpacings.l),
          ],
          if (title.isNotEmpty) ...[
            Text(title, style: typ.headingH5.copyWith(color: cs.secondary)),
            const SizedBox(height: AppSpacings.l),
          ],
          Text(
            text,
            style: typ.body3Light.copyWith(color: cs.onSurface, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _PreviewImage extends StatelessWidget {
  const _PreviewImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xl2),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return ColoredBox(
              color: cs.surfaceContainerHighest,
              child: const Center(child: CircularLoader()),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            assert(() {
              debugPrint('Submodule preview image failed: $url → $error');
              return true;
            }());
            return ColoredBox(
              color: cs.surfaceContainerHighest,
              child: Icon(
                Icons.broken_image_outlined,
                color: cs.onSurfaceVariant,
                size: 40,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ContinueBar extends StatelessWidget {
  const _ContinueBar({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacings.xl2,
        AppSpacings.s,
        AppSpacings.xl2,
        AppSpacings.l,
      ),
      child: LumeButton(
        label: trailPreviewContinue,
        size: LumeButtonSize.lg,
        isExpanded: true,
        onPressed: onContinue,
      ),
    );
  }
}
