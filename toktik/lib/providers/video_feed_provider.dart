import 'package:flutter/foundation.dart';
import '../models/video_post.dart';

class VideoFeedProvider extends ChangeNotifier {
  final List<VideoPost> _posts = [];
  int _currentIndex = 0;

  List<VideoPost> get posts => List.unmodifiable(_posts);
  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    if (index == _currentIndex) return;
    _currentIndex = index;
    notifyListeners();
  }

  void loadMockData() {
    _posts.clear();
    _posts.addAll([
      VideoPost(
        id: 'v1',
        assetPath: 'assets/videos/v1.mp4',
        userName: '@profe',
        caption: '¡Primer video! #flutter #tiktokui',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        likes: 1234,
        views: 500,
      ),
      VideoPost(
        id: 'v2',
        assetPath: 'assets/videos/v2.mp4',
        userName: '@alumno1',
        caption: 'Animaciones con animate_do 😎',
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        likes: 8900,
        views: 3200,
      ),
      VideoPost(
        id: 'v3',
        assetPath: 'assets/videos/v3.mp4',
        userName: '@alumno2',
        caption: 'Provider para manejar estado',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        likes: 20100,
        views: 15000,
      ),
      VideoPost(
        id: 'v4',
        assetPath: 'assets/videos/v4.mp4',
        userName: '@alumno3',
        caption: 'Provider para manejar estado',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        likes: 2100,
        views: 800,
      ),
      VideoPost(
        id: 'v5',
        assetPath: 'assets/videos/v5.mp4',
        userName: '@alumno4',
        caption: 'Provider para manejar estado',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        likes: 9900,
        views: 4500,
      ),
      VideoPost(
        id: 'v6',
        assetPath: 'assets/videos/v6.mp4',
        userName: '@profe',
        caption: 'Provider para manejar estado',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        likes: 777,
        views: 200,
      ),
    ]);
    notifyListeners();
  }

  void incrementLike(String id) {
    final idx = _posts.indexWhere((p) => p.id == id);
    if (idx != -1) {
      _posts[idx].likes++;
      notifyListeners();
    }
  }

  /// Incrementa el contador de reproducciones (views) del video.
  void incrementViews(String id) {
    final idx = _posts.indexWhere((p) => p.id == id);
    if (idx != -1) {
      _posts[idx].views++;
      notifyListeners();
    }
  }
}
