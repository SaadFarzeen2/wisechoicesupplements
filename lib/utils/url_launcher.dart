import 'package:url_launcher/url_launcher.dart' as url_launcher;

/// Handling open URL by parsing a URI string.
///
Future<void> launch(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await url_launcher.launchUrl(
    uri,
    mode: url_launcher.LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $uri';
  }
}
