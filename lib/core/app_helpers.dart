class AppHelpers {
  static String getYouTubeThumbnail(String videoUrl) {
    final uri = Uri.tryParse(videoUrl);

    String? videoId;
    if (uri != null) {
      if (uri.host.contains('youtube.com')) {
        videoId = uri.queryParameters['v'];
      } else if (uri.host.contains('youtu.be')) {
        videoId = uri.pathSegments.first;
      }
    }

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
