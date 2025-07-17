import 'dart:async';
import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/danhmuc.dart';


class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<String> bannerImages = [
    'assets/banner1.png',
    'assets/banner2.png',
    'assets/banner3.png',
    'assets/banner4.png',
  ];

  final List<String> categories = [
    'Sữa bột',
    'Sữa tươi',
    'Sữa chua',
    'Sữa hạt',
    'Sữa đặc',
    'Sữa công thức',
    'Sữa cho bé',
    'Sữa người lớn',
  ];

  final List<Map<String, String>> flashSaleProducts = [
    {
      'name': 'Friso Gold 900g',
      'price': '450.000đ',
      'image': 'assets/friso2_900g.jpg',
    },
    {
      'name': 'Ensure Gold 850g',
      'price': '520.000đ',
      'image': 'assets/friso2_900g.jpg',
    },
    {
      'name': 'Dielac Alpha 900g',
      'price': '380.000đ',
      'image': 'assets/friso2_900g.jpg',
    },
    {
      'name': 'Vinamilk ADM 180ml',
      'price': '10.000đ',
      'image': 'assets/friso2_900g.jpg',
    },
  ];

  final PageController _bannerController = PageController();
  int _currentBanner = 0;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_bannerController.hasClients) {
        _currentBanner = (_currentBanner + 1) % bannerImages.length;
        _bannerController.animateToPage(
          _currentBanner,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _bannerController,
              itemCount: bannerImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      bannerImages[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Danh mục',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            itemCount: categories.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.orange[100],
                    child: const Icon(Icons.local_drink, color: Colors.orange),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    categories[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              );
            },
          ),


          const SizedBox(height: 10),

          SizedBox(
            height: 500,
            child: GridView.builder(
              itemCount: flashSaleProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                var product = flashSaleProducts[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orangeAccent),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                        child: Image.asset(
                          product['image']!,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product['name']!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          product['price']!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}
