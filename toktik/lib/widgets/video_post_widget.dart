import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toktik_clone/providers/user_action_provider.dart';
import 'package:video_player/video_player.dart';

import '../models/video_post.dart';
import '../providers/video_feed_provider.dart';
import '../utils/formatters.dart';
import 'video_controls_overlay.dart';

class VideoPostWidget extends StatefulWidget {
  final VideoPost post;
  final bool isActive;

  const VideoPostWidget({
    super.key,
    required this.post,
    required this.isActive,
  });

  @override
  State<VideoPostWidget> createState() => _VideoPostWidgetState();
}

class _VideoPostWidgetState extends State<VideoPostWidget>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _showHeart = false;
  String? _initError;

  // --- Contador de views: solo cuenta tras 2s de isActive ---
  Timer? _viewTimer;
  bool _viewCounted = false;

  // --- Snackbar de "Pulsa para activar sonido" ---
  bool _snackbarShown = false;

  @override
  void initState() {
    super.initState();
    _createAndInitController();
  }

  Future<void> _createAndInitController() async {
    final path = widget.post.assetPath;
    final controller = VideoPlayerController.asset(path)..setLooping(true);
    _controller = controller;

    try {
      await controller.initialize();

      controller.addListener(() {
        final v = controller.value;
        if (v.hasError && mounted) {
          setState(() => _initError = v.errorDescription);
        }
        // Actualizar el indicador de progreso en tiempo real
        if (mounted) setState(() {});
      });

      if (!mounted) return;
      setState(() {
        _initialized = true;
        _initError = null;
      });

      // ===== Mejora: Siempre iniciar muteado =====
      final actions = context.read<UserActionsProvider>();
      await controller.setVolume(0);

      // Asegurar que el provider refleje el estado muteado
      if (!actions.isMuted(widget.post.id)) {
        actions.toggleMute(widget.post.id);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _controller != controller) return;
        _syncPlayState(force: true);

        // Mostrar snackbar al iniciar (solo la primera vez)
        if (widget.isActive && !_snackbarShown) {
          _showMuteSnackbar();
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _initError = e.toString();
        _initialized = false;
      });
    }
  }

  /// Muestra snackbar indicando que el sonido está silenciado.
  void _showMuteSnackbar() {
    if (_snackbarShown) return;
    _snackbarShown = true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.volume_off, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Pulsa para activar sonido'),
          ],
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _syncPlayState({bool force = false}) {
    final c = _controller;
    if (c == null || (!_initialized && !force)) return;
    if (widget.isActive) {
      c.play();
    } else {
      c.pause();
    }
  }

  /// Inicia el timer de 2 segundos para contar la view.
  void _startViewTimer() {
    _viewTimer?.cancel();
    if (_viewCounted) return;
    _viewTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted || !widget.isActive) return;
      _viewCounted = true;
      context.read<VideoFeedProvider>().incrementViews(widget.post.id);
    });
  }

  /// Cancela el timer de views si el usuario cambia de video antes de 2s.
  void _cancelViewTimer() {
    _viewTimer?.cancel();
  }

  @override
  void didUpdateWidget(covariant VideoPostWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isActive != widget.isActive) {
      _syncPlayState();

      if (widget.isActive) {
        _startViewTimer();
        // Mostrar snackbar si no se ha mostrado
        if (!_snackbarShown && _initialized) {
          _showMuteSnackbar();
        }
      } else {
        _cancelViewTimer();
      }
    }

    if (oldWidget.post.assetPath != widget.post.assetPath) {
      _disposeController();
      _initialized = false;
      _initError = null;
      _viewCounted = false;
      _snackbarShown = false;
      _createAndInitController();
    }
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  @override
  void dispose() {
    _cancelViewTimer();
    _disposeController();
    super.dispose();
  }

  void _onDoubleTapLike() {
    context.read<VideoFeedProvider>().incrementLike(widget.post.id);
    setState(() => _showHeart = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _showHeart = false);
    });
  }

  /// Mejora: Compartir usando share_plus
  void _onShare() {
    SharePlus.instance.share(
      ShareParams(text: 'Mira este video: ${widget.post.caption}'),
    );
  }

  /// Calcula el progreso del video (0.0 a 1.0).
  double _videoProgress() {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return 0.0;
    final duration = c.value.duration.inMilliseconds;
    if (duration == 0) return 0.0;
    return c.value.position.inMilliseconds / duration;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final actions = context.watch<UserActionsProvider>();
    final isFav = actions.isFavorite(widget.post.id);
    final isMuted = actions.isMuted(widget.post.id);

    final controller = _controller;

    // Sincroniza volumen por cambios del provider.
    if (_initialized && controller != null) {
      controller.setVolume(isMuted ? 0 : 1);
    }

    return GestureDetector(
      onTap: () async {
        if (!_initialized || controller == null) return;

        // Si está muteado, primer tap activa sonido
        if (isMuted) {
          actions.toggleMute(widget.post.id);
          await controller.setVolume(1);
          if (!controller.value.isPlaying) {
            await controller.play();
          }
          return;
        }

        // Comportamiento normal: play/pause
        controller.value.isPlaying ? controller.pause() : controller.play();
      },
      onDoubleTap: _onDoubleTapLike,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // --- VIDEO ---
          if (_initError != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Error al cargar el video:\n$_initError\nRuta: ${widget.post.assetPath}',
                  style: const TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else if (!_initialized || controller == null)
            const Center(child: CircularProgressIndicator())
          else
            Center(
              child: AspectRatio(
                aspectRatio:
                    controller.value.isInitialized &&
                        controller.value.aspectRatio.isFinite
                    ? controller.value.aspectRatio
                    : (9 / 16),
                child: VideoPlayer(controller),
              ),
            ),
          const _BottomGradient(),

          // --- Mejora: Indicador de progreso del video ---
          if (_initialized && controller != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: LinearProgressIndicator(
                value: _videoProgress(),
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 2.5,
              ),
            ),

          // --- Texto (usuario, caption, fecha) ---
          Positioned(
            left: 16,
            bottom: 24,
            right: 96,
            child: FadeInUp(
              from: 40,
              duration: const Duration(milliseconds: 400),
              child: _CaptionArea(
                userName: widget.post.userName,
                caption: widget.post.caption,
                date: formatDateShort(widget.post.createdAt),
              ),
            ),
          ),

          // --- Controles laterales ---
          Positioned(
            right: 12,
            bottom: 24,
            child: VideoControlsOverlay(
              isFavorite: isFav,
              likesText: formatLikes(widget.post.likes),
              viewsText: formatViews(widget.post.views),
              onToggleFavorite: () => actions.toggleFavorite(widget.post.id),
              onToggleMute: () => actions.toggleMute(widget.post.id),
              onShare: _onShare,
              isMuted: isMuted,
            ),
          ),

          // --- Overlay guía (muteado) ---
          if (isMuted && _initialized)
            Positioned(
              top: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.volume_off, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Pulsa para activar sonido',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // --- Corazón animado al dar doble tap ---
          if (_showHeart)
            Center(
              child: ZoomIn(
                duration: const Duration(milliseconds: 350),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 120,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _CaptionArea extends StatelessWidget {
  final String userName;
  final String caption;
  final String date;
  const _CaptionArea({
    required this.userName,
    required this.caption,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(caption, maxLines: 3, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Text(date, style: const TextStyle(fontSize: 12, color: Colors.white70)),
        ],
      ),
    );
  }
}

class _BottomGradient extends StatelessWidget {
  const _BottomGradient();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0, .6),
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black54, Colors.black87],
          ),
        ),
      ),
    );
  }
}
