import 'package:flutter/material.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // پکیج آیکون FontAwesome
import 'package:convex_bottom_bar/convex_bottom_bar.dart'; // اضافه کردن پکیج
import 'package:google_fonts/google_fonts.dart';
import 'package:group_grid_view/group_grid_view.dart';



void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'فروشگاه آنلاین',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Vazir',
      ),
      home: StoreHomePage(),
    );
  }
}
class StoreHomePage extends StatefulWidget {
  @override
  _StoreHomePageState createState() => _StoreHomePageState();
}
class _StoreHomePageState extends State<StoreHomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    CategoriesPage(),
    CartPage(),
    ProfilePage(),
    VamPage(),
  ];
  static const Color _backgroundColor = Colors.teal;
  static const Color _inactiveColor = Colors.white;
  static const Color _activeColor = Colors.orange;
  static const Color _iconColor = Colors.white; // رنگ آیکن‌ها

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      //منوی پایینی
      drawer: CustomDrawer(),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: ConvexAppBar(
        items: [
          TabItem(icon: Icon(FontAwesomeIcons.home, color: _iconColor), title: 'صفحه اصلی'),
          TabItem(icon: Icon(FontAwesomeIcons.thLarge, color: _iconColor), title: 'دسته بندی ها'),
          TabItem(icon: Icon(FontAwesomeIcons.shoppingCart, color: _iconColor), title: 'سبد خرید'),
          TabItem(icon: Icon(FontAwesomeIcons.user, color: _iconColor), title: 'پروفایل'),
          TabItem(icon: Icon(FontAwesomeIcons.moneyBillWave, color: _iconColor), title: 'خرید اقساطی'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: _backgroundColor, // رنگ پس‌زمینه
        color: _iconColor, // رنگ آیکن‌ها در حالت غیرفعال
        activeColor: _activeColor, // رنگ آیکن‌ها در حالت فعال
        style: TabStyle.react,
        elevation: 4,
      ),
    );
  }
}
//پایان منوی پایین


//تاپ بار
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({Key? key})
      : preferredSize = Size.fromHeight(65.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          // افزودن سایه به AppBar
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 4), // تغییر مکان سایه
          ),
        ],
      ),
      child: AppBar(
        // استفاده از گرادیانت برای پس‌زمینه AppBar
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade300, Colors.cyan.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0, // حذف سایه داخلی پیش‌فرض
        title: Row(
          children: [
            // استفاده از لوگوی سفارشی
            Image.network(
              'http://app.adamarkeet.com/adalogo.png',
              width: 40, // تنظیم سایز لوگو
              height: 40,
            ),
            SizedBox(width: 10),
            // استفاده از فونت‌های حرفه‌ای برای متن
            Text(
              'آدامارکـــت',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              // عمل مورد نظر برای سبد خرید
            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // عمل مورد نظر برای جستجو
            },
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // عمل مورد نظر برای پروفایل
            },
          ),
        ],
      ),
    );
  }
}
//پایان تاپ بار



//منوی دراور
class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}
class _CustomDrawerState extends State<CustomDrawer> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    // Determine the drawer width based on the expansion state
    double drawerWidth = _isExpanded ? 250 : 80;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: drawerWidth,
      decoration: BoxDecoration(
        color: Colors.teal,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: Offset(0.0, 5.0),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              height: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade300, Colors.cyan.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: 10), // Space from the left
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage('http://app.adamarkeet.com/adalogo.png'),
                  ),
                  SizedBox(width: 10),
                  Expanded( // Use Expanded to fill the remaining space
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      opacity: _isExpanded ? 1.0 : 0.0,
                      child: Text(
                        'فروشگاه آنلاین',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis, // Prevent overflow
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildDrawerItem(Icons.home, 'صفحه اصلی', context),
                  _buildDrawerItem(Icons.category, 'دسته بندی ها', context),
                  _buildDrawerItem(Icons.shopping_cart, 'سبد خرید', context),
                  _buildDrawerItem(Icons.person, 'پروفایل', context),
                  _buildDrawerItem(Icons.settings, 'تنظیمات', context),
                  Divider(color: Colors.white70),
                  _buildDrawerItem(Icons.exit_to_app, 'خروج', context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildDrawerItem(IconData icon, String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: Colors.cyan.withOpacity(0.3),
          highlightColor: Colors.cyan.withOpacity(0.2),
          onTap: () {
            Navigator.pop(context);
            // Add your navigation logic here
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.1),
            ),
            child: Row(
              children: [
                SizedBox(width: 10),
                Icon(icon, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//پایان دراور منو




class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(

        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
//قسمت استوری ها
        _buildCard(
        child: Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
        colors: [Colors.teal.shade300, Colors.cyan[50]!], // گرادینت ملایم از سفید به خاکستری آبی
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15), // گرد کردن گوشه‌ها
        boxShadow: [
          BoxShadow(
            color: Colors.black12, // سایه ملایم‌تر
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'استوری ها',
              style: TextStyle(
                fontSize: 22, // افزایش اندازه متن
                fontWeight: FontWeight.bold,
                color: Colors.teal, // تغییر رنگ متن به رنگ تهی
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: Container(
              height: 100,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    StoryWidget(
                      stories: [
                        Story(
                          thumbnailUrl: 'http://app.adamarkeet.com/adalogo.png?text=Story+1',
                          imageUrl: 'http://app.adamarkeet.com/adalogo.png?text=Story+1+Image',
                          description: 'این اولین استوری است.',
                          isSeen: false,
                        ),
                        Story(
                          thumbnailUrl: 'http://app.adamarkeet.com/adalogo.png?text=Story+2',
                          imageUrl: 'http://app.adamarkeet.com/adalogo.png?text=Story+2+Image',
                          description: 'این دومین استوری است.',
                          isSeen: true,
                        ),
                        Story(
                          thumbnailUrl: 'http://app.adamarkeet.com/adalogo.png?text=Story+3',
                          imageUrl: 'http://app.adamarkeet.com/adalogo.png?text=Story+3+Image',
                          description: 'این سومین استوری است.',
                          isSeen: false,
                        ),
                        Story(
                          thumbnailUrl: 'http://app.adamarkeet.com/adalogo.png?text=Story+4',
                          imageUrl: 'http://app.adamarkeet.com/adalogo.png?text=Story+4+Image',
                          description: 'این چهارمین استوری است.',
                          isSeen: true,
                        ),
                        Story(
                          thumbnailUrl: 'http://app.adamarkeet.com/adalogo.png?text=Story+5',
                          imageUrl: 'http://app.adamarkeet.com/adalogo.png?text=Story+5+Image',
                          description: 'این پنجمین استوری است.',
                          isSeen: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    ),

            //پایا استوری



            SizedBox(height: 20),


            //دسته بندی ها
            _buildCard(
              child: _buildCarouselSlider(),
            ),
            SizedBox(height: 20),
            //قسمت دسته بندی ها
            _buildCard(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.teal.shade400,
                      Colors.teal.shade200,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8.0,
                      spreadRadius: 2.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'دسته بندی‌ها',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    _buildCategoryList(),
                  ],
                ),
              ),
            ),
            //پایان دسته بندی



            SizedBox(height: 20),



            //قسمت محصولات پیشنهادی
            _buildCard(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'محصولات پیشنهادی',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                  ),
                  _buildProductList(),
                ],
              ),
            ),
            //پایان محصولات پیشنهادی



            SizedBox(height: 20),


            _buildAdWidget(),
          ],
        ),
      ),
    );
  }


  //اسلایدر
  Widget _buildCarouselSlider() {
    return Container(
      height: 200,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200.0,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 4),
          autoPlayAnimationDuration: Duration(milliseconds: 600),
          enlargeCenterPage: true,
          viewportFraction: 0.8,
        ),
        items: [1, 2, 3].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage('http://app.adamarkeet.com/adalogo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
  //پایان اسلایدر


 //ویجت دسته بندی
  Widget _buildCategoryList() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (ctx, index) => _buildCategoryCard(),
      ),
    );
  }

  //ویجت محصولات پیشنهادی
  Widget _buildProductList() {
    return Container(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (ctx, i) => ProductCard(),
      ),
    );
  }

  //ویجت تبلیغات
  Widget _buildAdWidget() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.teal.shade300,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            spreadRadius: 1.0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'تبلیغ',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }





  Widget _buildCategoryCard() {
    return Container(
      width: 100,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          ClipOval(
            child: Image.network(
              'http://app.adamarkeet.com/adalogo.png',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 5),
          Text('دسته بندی ۱', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }




  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            spreadRadius: 1.0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}




//استوری اینستاگرام
class StoryWidget extends StatelessWidget {
  final List<Story> stories;
  StoryWidget({required this.stories});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: stories.map((story) {
        return GestureDetector(
          onTap: () {
            story.isSeen = true; // مشخص کردن اینکه استوری مشاهده شده است
            showDialog(
              context: context,
              builder: (context) => StoryDetailDialog(story: story),
            );
          },
          child: Container(
            width: 70,
            height: 70,
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(story.thumbnailUrl),
                fit: BoxFit.cover,
              ),
              border: Border.all(
                color: story.isSeen ? Colors.grey : Colors.blue, // رنگ حاشیه برای استوری‌های دیده شده و ندیده
                width: 3,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
class StoryDetailDialog extends StatefulWidget {
  final Story story;
  StoryDetailDialog({required this.story});
  @override
  _StoryDetailDialogState createState() => _StoryDetailDialogState();
}
class _StoryDetailDialogState extends State<StoryDetailDialog> {
  late Timer _timer;
  int _currentTime = 0;
  final int _duration = 5; // Duration in seconds
  @override
  void initState() {
    super.initState();
    _startTimer();
  }
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentTime < _duration) {
        setState(() {
          _currentTime++;
        });
      } else {
        Navigator.of(context).pop(); // Close dialog after time
      }
    });
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onHorizontalDragEnd: (details) {
              Navigator.of(context).pop(); // Close dialog on swipe
            },
            child: Hero(
              tag: widget.story.thumbnailUrl,
              child: Image.network(widget.story.imageUrl),
            ),
          ),
          SizedBox(height: 10),
          Text(
            widget.story.description,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: _currentTime / _duration,
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }
}
class Story {
  final String thumbnailUrl;
  final String imageUrl;
  final String description;
  bool isSeen; // ویژگی جدید برای نشان دادن وضعیت مشاهده
  Story({
    required this.thumbnailUrl,
    required this.imageUrl,
    required this.description,
    this.isSeen = false, // مقدار پیش‌فرض برای استوری‌های مشاهده نشده
  });
}







class ProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                'https://picsum.photos/200/300',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'محصول نمونه',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'قیمت: 100,000 تومان',
              style: TextStyle(color: Colors.teal),
            ),
          ),
        ],
      ),
    );
  }
}








//صفحه دسته بندی ها
class CategoriesPage extends StatelessWidget {
  final List<TestModel> categories = [
    TestModel(
        sectionName: "دسته‌بندی ۱",
        listItems: ["مورد ۱", "مورد ۲", "مورد ۳", "مورد ۴"]),
    TestModel(
        sectionName: "دسته‌بندی ۲",
        listItems: ["مورد ۵", "مورد ۶", "مورد ۷"]),
    TestModel(
        sectionName: "دسته‌بندی ۳",
        listItems: ["مورد ۸", "مورد ۹", "مورد ۱۰"]),
    TestModel(
        sectionName: "دسته‌بندی ۴",
        listItems: ["مورد ۱۱", "مورد ۱۲", "مورد ۱۳", "مورد ۱۴"]),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('صفحه دسته‌بندی‌ها', style: TextStyle(fontSize: 24)),
      ),
      body: GroupGridView(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16),
        sectionCount: categories.length,
        headerForSection: (section) => Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(categories[section].sectionName,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        footerForSection: (section) {
          return const SizedBox(height: 16);
        },
        itemInSectionBuilder: (_, indexPath) {
          final data =
          categories[indexPath.section].listItems[indexPath.index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(data,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500)),
              ),
            ),
          );
        },
        itemInSectionCount: (section) => categories[section]
            .listItems
            .length,
      ),
    );
  }
}








class TestModel {
  TestModel(
      {required this.sectionName, required this.listItems, this.footerName});
  final String sectionName;
  final String? footerName;
  final List<String> listItems;
}



//صفحه سبد خرید
class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('صفحه سبد خرید', style: TextStyle(fontSize: 24)),
    );
  }
}


class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('پروفایل', style: TextStyle(fontSize: 24)),
    );
  }
}



class VamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('وام', style: TextStyle(fontSize: 24)),
    );
  }
}
