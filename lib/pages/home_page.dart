import 'package:flutter/material.dart';
import 'package:vyktor/pages/map_page.dart';
import 'package:vyktor/pages/settings_page.dart';
import 'package:vyktor/blocs/delegate.dart';
import 'permissions_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vyktor/blocs/map/map_data_barrel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bloc/bloc.dart';

enum TabItem { MAP, SETTINGS }

/// TODO: Documentation.
class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hasLocationPermissions = false;
  Geolocator _geolocator = Geolocator();
  Position _initialPositon;

  TabItem _currentTab = TabItem.MAP;
  final List<TabItem> _bottomTabs = [TabItem.MAP, TabItem.SETTINGS];

  @override
  initState() {
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location)
        .then((PermissionStatus status) {
      setState(() {
        _hasLocationPermissions = status == PermissionStatus.granted;
      });
    });
    super.initState();
  }

  permissionsCallback() async {
    var initialPosition = await _geolocator.getCurrentPosition();
    setState(() {
      _initialPositon = initialPosition;
      _hasLocationPermissions = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_hasLocationPermissions) {
      BlocSupervisor.delegate = SimpleBlocDelegate();
      return BlocProvider(
        builder: (context) => MapDataBloc(),
        child: MapPage(),
      );
    }
    return PermissionsPage(enableLocation: permissionsCallback);
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: _bottomTabs
          .map((tab) => _buildBottomNavigationBarItem(_icon(tab), tab))
          .toList(),
      onTap: _onSelectTab,
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData icon, TabItem tab) {
    final String text = _title(tab);
    final Color color =
        _currentTab == tab ? Theme.of(context).primaryColor : Colors.grey;

    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: TextStyle(
          color: color,
        ),
      ),
    );
  }

  void _onSelectTab(int index) {
    TabItem selectedTab = _bottomTabs[index];

    setState(() {
      _currentTab = selectedTab;
    });
  }

  String _title(TabItem tab) {
    switch (tab) {
      case TabItem.MAP:
        return 'Map';
      case TabItem.SETTINGS:
        return 'Settings';
      default:
        throw 'Unknown: $tab';
    }
  }

  IconData _icon(TabItem tab) {
    switch (tab) {
      case TabItem.MAP:
        return Icons.map;
      case TabItem.SETTINGS:
        return Icons.settings;
      default:
        throw 'Unknown: $tab';
    }
  }
}
