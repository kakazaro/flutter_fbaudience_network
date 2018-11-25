import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FBNativeBannerAd extends StatefulWidget {

  final String placementID;
  final bool testing;
  final Function onCreate;

  FBNativeBannerAd({
    Key key,
    @required this.placementID,
    this.testing = false,
    this.onCreate
  }) : super(key: key);

  @override
  _FBNativeBannerAdState createState() => _FBNativeBannerAdState();
}

class _FBNativeBannerAdState extends State<FBNativeBannerAd> {

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'fb_native_ad_view',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParamsCodec: StandardMessageCodec(),
        creationParams: {
          "placementID": widget.placementID,
          "testing": widget.testing,
        },
      );
    }

    return Text('$defaultTargetPlatform is not yet supported by the text_view plugin');
  }

  _onPlatformViewCreated(int id) {
    if (widget.onCreate != null)
      widget.onCreate(NativeAdController._(id));
  }
}


class NativeAdController {

  final MethodChannel _channel;

  NativeAdController._(int id)
      : _channel = new MethodChannel("fb_native_ad_view_$id");

  Future<Null> setTitleColor(String colorString) {
    _channel.invokeMethod("setTitleColor", {"color": colorString});
  }

  Future<Null> setSocialTextColor(String colorString) {
    _channel.invokeMethod("setSocialTextColor", {"color": colorString});
  }

  Future<Null> setBackgroundColor(String colorString) {
    _channel.invokeMethod("setBackgroundColor", {"color": colorString});
  }

  Future<Null> setContentPadding({int top = 0, int left = 0, int bottom = 0, int right = 0}) {
    _channel.invokeMethod("setContentPadding", {
      "top": top,
      "left": left,
      "bottom": bottom,
      "right": right
    });
  }
}

