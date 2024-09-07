// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

// 明星八卦页面部件
class MingxingBaguaPage extends StatefulWidget {
  @override
  _MingxingBaguaPageState createState() => _MingxingBaguaPageState();
}

class _MingxingBaguaPageState extends State<MingxingBaguaPage> {
  late Future<String> _futureImageUrl;
  bool isDownloading = false;

  @override
  void initState() {
    super.initState();
    _futureImageUrl = fetchMingxingBaguaImageUrl();
  }

  // 刷新图片
  void _refreshImage() {
    setState(() {
      _futureImageUrl = fetchMingxingBaguaImageUrl();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('明星八卦'),
        actions: [
          // 刷新按钮
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshImage,
          ),
          // 下载按钮
          IconButton(
            icon: isDownloading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 229, 166, 209),
                      semanticsLabel: '下载中',
                      semanticsValue: 'Downloading...',
                    ),
                  )
                : Icon(Icons.download),
            onPressed: isDownloading
                ? null
                : () async {
                    setState(() {
                      isDownloading = true;
                    });

                    final imageUrl = await _futureImageUrl;

                    if (await Permission.storage.request().isGranted) {
                      final success = await _saveImage(imageUrl);
                      if (success) {
                        Fluttertoast.showToast(msg: '图片保存成功！');
                      } else {
                        Fluttertoast.showToast(msg: '图片保存失败。');
                      }
                    } else {
                      Fluttertoast.showToast(msg: '存储权限被拒绝。');
                    }

                    setState(() {
                      isDownloading = false;
                    });
                  },
          ),
          SizedBox(width: 16),
        ],
      ),
      body: FutureBuilder<String>(
        future: _futureImageUrl,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No image found'));
          } else {
            final imageUrl = snapshot.data!;
            return Center(
              child: InteractiveViewer(
                minScale: 1.0,
                maxScale: 4.0,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(child: Text('图片加载失败'));
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // 下载图片并保存到图库
  Future<bool> _saveImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final result = await ImageGallerySaver.saveImage(
          response.bodyBytes,
          quality: 100,
        );
        return result != null && result['isSuccess'] == true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}

// 获取明星八卦图片 URL
Future<String> fetchMingxingBaguaImageUrl() async {
  final response = await http.get(Uri.parse('https://dayu.qqsuu.cn/mingxingbagua/apis.php?type=json'));

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    if (jsonResponse['code'] == 200) {
      return jsonResponse['data'];
    } else {
      throw Exception('Failed to load image URL');
    }
  } else {
    throw Exception('Failed to load image URL');
  }
}
