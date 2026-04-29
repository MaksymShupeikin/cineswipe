import 'package:cineswipe/core/app_exports.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerPlayerModal extends StatefulWidget {
  final String videoId;

  const TrailerPlayerModal({super.key, required this.videoId});

  @override
  State<TrailerPlayerModal> createState() => _TrailerPlayerModalState();

  static void show(BuildContext context, String videoId) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Trailer',
      barrierColor: Colors.black.withValues(alpha: 0.85),
      pageBuilder: (context, anim1, anim2) => TrailerPlayerModal(videoId: videoId),
    );
  }
}

class _TrailerPlayerModalState extends State<TrailerPlayerModal> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Close gesture for background
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Player with glass border
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LiquidGlass.withOwnLayer(
                    settings: const LiquidGlassSettings(
                      thickness: 12,
                      blur: 20,
                      glassColor: Color(0x0CFFFFFF),
                    ),
                    shape: LiquidRoundedSuperellipse(borderRadius: 24),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: YoutubePlayer(
                          controller: _controller,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: AppColors.white,
                          onEnded: (_) => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Close button
                CupertinoButton(
                  onPressed: () => Navigator.pop(context),
                  child: LiquidGlass.withOwnLayer(
                    settings: const LiquidGlassSettings(
                      thickness: 12,
                      blur: 16,
                      glassColor: Color(0x33000000),
                    ),
                    shape: LiquidRoundedSuperellipse(borderRadius: 60),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Icon(
                        Icons.close_rounded,
                        color: AppColors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
