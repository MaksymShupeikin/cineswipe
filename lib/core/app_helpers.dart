class AppHelpers {
  static String? extractVideoId(String videoUrl) {
    final uri = Uri.tryParse(videoUrl);
    if (uri == null) return null;

    if (uri.host.contains('youtube.com')) {
      return uri.queryParameters['v'];
    } else if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    }
    return null;
  }

  static String getYouTubeThumbnail(String videoUrl) {
    final videoId = extractVideoId(videoUrl);
    if (videoId == null || videoId.isEmpty) return '';

    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }

  static String formatCountryName(String country) {
    if (country == 'United States of America') {
      return 'USA';
    }

    if (country == 'United Arab Emirates') {
      return 'UAE';
    }
    
    return country;
  }
}
