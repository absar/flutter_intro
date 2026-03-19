part of flutter_intro;

/// Delayed rendering class, used to achieve [Intro] animation effect
/// For internal use of classes, developers don’t need to care
///
class _DelayRenderedWidget extends StatefulWidget {
  /// Sub-elements that need to fade in and out
  final Widget? child;

  /// [child] Whether to continue rendering, that is, the animation will only be once
  final bool childPersist;

  /// Animation duration
  final Duration duration;

  /// [child] need to be removed (hidden)
  final bool removed;

  const _DelayRenderedWidget({
    Key? key,
    this.removed = false,
    required this.duration,
    this.child,
    this.childPersist = false,
  }) : super(key: key);

  @override
  _DelayRenderedWidgetState createState() => _DelayRenderedWidgetState();
}

class _DelayRenderedWidgetState extends State<_DelayRenderedWidget> {
  double opacity = 0;
  Widget? child;
  late Timer timer;

  /// Time interval between animations
  final Duration durationInterval = Duration(milliseconds: 100);

  @override
  void initState() {
    super.initState();
    child = widget.child;
    timer = Timer(durationInterval, () {
      opacity = 1;
      _setStateIfMounted();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  void didUpdateWidget(_DelayRenderedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    var duration = widget.duration;
    if (widget.removed) {
      opacity = 0;
      _setStateIfMounted();
      return;
    }

    if (!identical(oldWidget.child, widget.child)) {
      if (widget.childPersist) {
        child = widget.child;
        _setStateIfMounted();
      } else {
        opacity = 0;
        _setStateIfMounted();
        Timer(
          Duration(
            milliseconds:
                duration.inMilliseconds + durationInterval.inMilliseconds,
          ),
          () {
            child = widget.child;
            opacity = 1;
            _setStateIfMounted();
          },
        );
      }
    }
  }

  void _setStateIfMounted() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: widget.duration,
      child: child,
    );
  }
}
