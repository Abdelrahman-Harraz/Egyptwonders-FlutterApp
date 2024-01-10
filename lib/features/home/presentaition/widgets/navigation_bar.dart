import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/features/home/presentaition/blocs/home_bloc/home_bloc.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:sizer/sizer.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (int index) {
        HomeTab selectedTab = getHomeTab(index);
        print(selectedTab);
        print(index);
        HomeBloc.get(context).add(SetHomeTabEvent(selectedTab));
        setState(() {
          _currentIndex = index;
        });
      },
      showUnselectedLabels: true,
      // backgroundColor: Colors.transparent,
      elevation: 0.0,
      selectedItemColor: OwnTheme.grey, // Change the selected item color
      unselectedItemColor: OwnTheme.grey, // Change the unselected item color
      selectedLabelStyle: OwnTheme.bodyTextStyle().copyWith(
          color: OwnTheme.grey), // Change the style of the selected label
      unselectedLabelStyle: OwnTheme.bodyTextStyle().copyWith(
          color: OwnTheme.grey), // Change the style of the unselected label
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: '',
        ),
        BottomNavigationBarItem(
          icon:
              Icon(_currentIndex == 1 ? Icons.explore : Icons.explore_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
              _currentIndex == 2 ? Icons.favorite : Icons.favorite_outline),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(_currentIndex == 3 ? Icons.menu : Icons.menu),
          label: '',
        ),
      ],
    );
  }
}

HomeTab getHomeTab(int index) {
  switch (index) {
    case 1:
      return HomeTab.explore;
    case 2:
      return HomeTab.favorits;
    case 3:
      return HomeTab.profile;
    default:
      return HomeTab.home;
  }
}
