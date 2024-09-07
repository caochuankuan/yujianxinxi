import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yifeng_site/bilibili_page.dart';
import 'package:yifeng_site/bing_wallpaper_page.dart';
import 'package:yifeng_site/daily_news_page.dart';
import 'package:yifeng_site/epic_free_games_page.dart';
import 'package:yifeng_site/mingxing_bagua.dart';
import 'package:yifeng_site/moyu_rili.dart';
import 'package:yifeng_site/moyuribao_page.dart';
import 'package:yifeng_site/neihan_duanzi.dart';
import 'package:yifeng_site/today_in_history_page.dart';
import 'package:yifeng_site/weibo_page.dart';
import 'package:yifeng_site/xingzuo_yunshi.dart';
import 'package:yifeng_site/xinwen_jianbao.dart';
import 'package:yifeng_site/zhihu_page.dart';
import 'douyin_page.dart';
import 'news_page.dart';

// 主程序入口
void main() {
  runApp(const MyApp());
}

// 主应用程序的根部件
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // 定义一个布尔变量来控制是否为夜间模式
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '遇见信息',
      theme: _isDarkMode
          ? ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF121212), // 深色背景
              primaryColor: const Color(0xFF1F1F1F), // 主色调
              cardColor: const Color(0xFF1E1E1E), // 卡片颜色
              appBarTheme: AppBarTheme(
                backgroundColor: const Color(0xFF1F1F1F),
                titleTextStyle:
                    const TextStyle(color: Colors.white, fontSize: 20),
                iconTheme:
                    const IconThemeData(color: Colors.white), // AppBar 图标颜色
              ),
              iconTheme:
                  const IconThemeData(color: Color(0xFFBB86FC)), // 全局图标着色（柔和紫色）
              textTheme: const TextTheme(
                titleLarge: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                labelLarge: TextStyle(
                    color: Color(0xFFBB86FC),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: const Color(0xFFBB86FC), // 浮动按钮颜色
              ),
            )
          : ThemeData(
              primarySwatch: Colors.deepPurple,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textTheme: const TextTheme(
                titleLarge:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                labelLarge:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
      home: MyHomePage(
        isDarkMode: _isDarkMode,
        toggleTheme: _toggleTheme,
      ),
    );
  }

  // 切换夜间模式的方法
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }
}

// 主页面部件
class MyHomePage extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  MyHomePage({super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('遇见信息'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            showAboutDialog(
              context: context,
              applicationName: '遇见信息',
              applicationVersion: '1.0.1',
              applicationIcon: const Image(
                image: AssetImage('assets/icon/app.png'),
                width: 50,
                height: 50,
              ),
              children: [
                Text('作者：于逸风'),
                Text('联系方式：2835082172@qq.com'),
                Text('GitHub：https://github.com/caochuankuan/'),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
                isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 1.2,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final item = _listItems[index];
                return _buildCard(
                  context,
                  item['text']!,
                  item['icon']!,
                  item['page']!,
                  isDarkMode ? Colors.grey[800]! : Colors.deepPurpleAccent,
                  isDarkMode ? Colors.white : Colors.white,
                );
              },
              childCount: _listItems.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final item = _imageItems[index];
                return _buildCard(
                  context,
                  item['text']!,
                  item['icon']!,
                  item['page']!,
                  isDarkMode ? Colors.grey[700]! : Colors.orangeAccent,
                  isDarkMode ? Colors.white : Colors.black87,
                  isImageSection: true,
                );
              },
              childCount: _imageItems.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String text,
    IconData icon,
    Widget page,
    Color backgroundColor,
    Color textColor, {
    bool isImageSection = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (page is Text) {
          Fluttertoast.showToast(msg: '该功能正在开发中，敬请期待');
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: isImageSection ? 80 : 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: isImageSection ? 45 : 50,
                  color: isDarkMode
                      ? isImageSection ? Color.fromARGB(255, 175, 208, 219) :  Color.fromARGB(255, 180, 158, 208)
                      : textColor, // 根据模式设置图标颜色
                ),
              ),
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontSize: isImageSection ? 15 : 20,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<Map<String, dynamic>> _listItems = [
    {
      'text': '每日60秒',
      'icon': Icons.access_time,
      'page': DailyNewsPage(futureData: fetchDailyNewsData()),
    },
    {
      'text': '摸鱼日报',
      'icon': Icons.today,
      'page': MoyuRibaoPage(),
    },
    {
      'text': '历史上的今天',
      'icon': Icons.history,
      'page': TodayInHistoryPage(futureData: fetchTodayInHistoryData()),
    },
    {
      'text': '抖音热搜',
      'icon': Icons.trending_up,
      'page': DouyinPage(),
    }
  ];

  final List<Map<String, dynamic>> _imageItems = [
    {
      'text': 'Bilibili热搜',
      'icon': Icons.video_library,
      'page': BilibiliPage(),
    },
    {
      'text': 'Bing 每日壁纸',
      'icon': Icons.image,
      'page': BingWallpaperPage(futureData: fetchBingWallpaperData()),
    },
    {
      'text': 'Epic 免费游戏',
      'icon': Icons.games,
      'page': EpicFreeGamesPage(futureGames: fetchEpicFreeGames()),
    },
    {
      'text': '摸鱼日历',
      'icon': Icons.calendar_today,
      'page': MoyuRiliPage(),
    },
    {
      'text': '内涵段子',
      'icon': Icons.sentiment_satisfied,
      'page': NeihanDuanziPage(),
    },
    {
      'text': '星座运势',
      'icon': Icons.star_border,
      'page': XingzuoYunshiPage(),
    },
    {
      'text': '头条热搜',
      'icon': Icons.dashboard,
      'page': NewsPage(),
    },
    {
      'text': '知乎热搜',
      'icon': Icons.question_answer,
      'page': ZhihuPage(futureData: fetchZhihuData()),
    },
    {
      'text': '微博热搜',
      'icon': Icons.public,
      'page': WeiboPage(futureData: fetchWeiboData()),
    },
    {
      'text': '明星八卦',
      'icon': Icons.star,
      'page': MingxingBaguaPage(),
    },
    {
      'text': '新闻简报',
      'icon': Icons.newspaper,
      'page': XinwenJianbaoPage(),
    },
    {
      'text': '待开发',
      'icon': Icons.hourglass_empty,
      'page': Text('待开发'),
    },
  ];
}
