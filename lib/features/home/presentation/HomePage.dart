// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasidak/core/constants/app_color.dart';
import 'package:rasidak/core/constants/app_size.dart';
import 'package:rasidak/core/localization/language_controller.dart';
import 'package:rasidak/core/routes/app_pages.dart';
import 'package:rasidak/features/customer/logic/customer_controller.dart';
import 'package:rasidak/features/customer/logic/entity/customer.dart';
import 'package:rasidak/features/customer/presentation/addCustomer.dart';
import 'package:rasidak/features/debt/presentation/newDebt.dart';
import 'package:rasidak/features/home/logic/HomeController.dart';
import 'package:rasidak/features/home/logic/waveClipper.dart';
import 'package:rasidak/features/setting/presentation/settingPage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final homeController = Get.find<HomeController>();
  final lang = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    AppSize size = AppSize(context);
    return Obx(()=>Scaffold(
      backgroundColor: AppColors.backgroundColor,
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomNavBar(),
      body: PageView(
        controller: homeController.pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            homeController.currentIndex.value = index;
          });
        },
        children: [
          ListView(
            children: [
              _buildTopPage(),
              _buildTextField(),
              GetX<CustomerController>(builder: (controller) {
                if (controller.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final list = controller.filteredCustomers;

                if (list.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Obx(() => Text(
                        controller.searchQuery.value.isEmpty
                            ? lang.t("لا يوجد زبائن بعد")
                            : lang.t("لا يوجد نتائج مطابقة"),
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.secondaryText,
                        ),
                      )),
                    ),
                  );
                }

                return Obx(
                  () => ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return _buildUsersBox(size, list[index]);
                    },
                  ),
                );
              })
            ],
          ),
          const AddCustomer(),
          const NewDebt(),
          const settingPage(),
        ],
      ),
    ));
  }

  Widget _buildTopPage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              "رصيدك",
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  fontSize: 35,
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w900),
            ),
            Text(
              "Rasidak",
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontSize: 28,
                letterSpacing: 2,
                color: AppColors.primaryText,
                fontWeight: FontWeight.w900,
              ),
            )
          ],
        ),
        CircleAvatar(
          radius: 60,
          backgroundColor: AppColors.backgroundColor,
          backgroundImage: const AssetImage("assets/images/logo.png"),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.person, size: 50),
          color: AppColors.primaryText,
          highlightColor: AppColors.accentGold,
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Obx(() => TextFormField(
        keyboardType: TextInputType.text,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        style: TextStyle(color: AppColors.primaryText),
        onChanged: (value) {
          Get.find<CustomerController>().searchQuery.value = value;
        },
        decoration: InputDecoration(
          hintText: lang.t("ابحث عن العملاء بسرعة"),
          hintStyle: TextStyle(
            color: AppColors.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.borderColor),
          ),
        ),
      )),
    );
  }

  Widget _buildUsersBox(AppSize size, Customer customer) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.debetDetails, arguments: customer);
      },
      child: Container(
        width: size.width,
        height: size.height * 0.2,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            children: [
              Container(color: AppColors.primaryColor),
              ClipPath(
                clipper: WaveClipper(),
                child: FractionallySizedBox(
                  widthFactor: 0.42,
                  heightFactor: 1.0,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    color: AppColors.secondaryColor,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, color: AppColors.accentGold, size: 14),
                        const SizedBox(width: 8),
                        Obx(() => Text(
                          customer.debtLevel == "simple"
                              ? lang.t("دين بسيط")
                              : customer.debtLevel == "medium"
                              ? lang.t("دين متوسط")
                              : lang.t("الدين عالي"),
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            color: AppColors.accentGold,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        customer.name,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${customer.totalDebt} NIS",
                        style: TextStyle(
                          color: AppColors.accentGold,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Obx(() => Text(
                        "${lang.t("أخر تعديل")} ${customer.lastUpdate.day}.${customer.lastUpdate.month}.${customer.lastUpdate.year}",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Obx(() {
      if (homeController.currentIndex.value == 0) {
        return InkWell(
          onTap: () {
            homeController.jumpToPage(1);
          },
          child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: AppColors.accentGold,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Icons.add, color: AppColors.backgroundColor, size: 30),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildBottomNavBar() {
    return Obx(() => BottomNavigationBar(
      backgroundColor: AppColors.backgroundColor,
      type: BottomNavigationBarType.fixed,
      currentIndex: homeController.currentIndex.value,
      selectedItemColor: AppColors.accentGold,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 11,
      ),
      unselectedLabelStyle: const TextStyle(fontSize: 11),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      elevation: 8,
      onTap: (index) {
        homeController.jumpToPage(index);
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          activeIcon: const Icon(Icons.home),
          label: lang.t('Home'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.add_circle_outline),
          activeIcon: const Icon(Icons.add_circle),
          label: lang.t('New Entry'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.fiber_new),
          activeIcon: const Icon(Icons.bar_chart),
          label: lang.t('New Debt'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings_outlined),
          activeIcon: const Icon(Icons.settings),
          label: lang.t('Settings'),
        ),
      ],
    ));
  }
}