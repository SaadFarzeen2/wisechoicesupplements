import 'package:cirilla/extension/strings.dart';
import 'package:flutter/material.dart';

const int limitedViewingDescription = 94;

class InformationVideoShop extends StatefulWidget {
  const InformationVideoShop({
    Key? key,
    this.videoTitle,
    this.videoDescription,
    required this.maxHeight,
  }) : super(key: key);
  final String? videoTitle;
  final String? videoDescription;
  final double maxHeight;

  @override
  State<InformationVideoShop> createState() => _InformationVideoShopState();
}

class _InformationVideoShopState extends State<InformationVideoShop> {
  bool _showReadMore = false;
  bool _expandDescription = false;
  double height = 0;
  int maxLineDescription = 0;

  @override
  void initState() {
    if (widget.videoDescription != null && widget.videoDescription!.removeHtmlTag.length > limitedViewingDescription) {
      _showReadMore = true;
    }
    height = widget.maxHeight * 0.9;
    maxLineDescription = ((height - 150) / 19).round();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (widget.videoTitle != null && widget.videoTitle!.removeHtmlTag.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Text(
                    widget.videoTitle!.removeHtmlTag,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (widget.videoDescription != null && widget.videoDescription!.removeHtmlTag.isNotEmpty)
                (_showReadMore)
                    ? (_expandDescription)
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                _expandDescription = false;
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  widget.videoDescription!.removeHtmlTag,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                  ),
                                  maxLines: maxLineDescription,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Text(
                                  "Hide",
                                  style: TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                _expandDescription = true;
                              });
                            },
                            child: RichText(
                              text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                  ),
                                  text:
                                      "${widget.videoDescription!.removeHtmlTag.substring(0, limitedViewingDescription - 18)}...",
                                  children: const [
                                    TextSpan(
                                      text: "  Read more",
                                      style:
                                          TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
                                    )
                                  ]),
                            ),
                          )
                    : Text(
                        widget.videoDescription!.removeHtmlTag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                        maxLines: 8,
                        overflow: TextOverflow.ellipsis,
                      ),
              const SizedBox(
                height: 10,
              ),
            ]));
  }
}
