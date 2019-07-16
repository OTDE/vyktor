import 'package:flutter/material.dart';
import 'package:vyktor/pages/map_page.dart';
import 'package:vyktor/pages/settings_page.dart';

enum TabItem {
  MAP,
  SETTINGS
}

/// TODO: Documentation.
class HomePage extends StatefulWidget {

  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  TabItem _currentTab = TabItem.MAP;
  final List<TabItem> _bottomTabs = [TabItem.MAP, TabItem.SETTINGS];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    switch(_currentTab) {
      case TabItem.MAP:
        return MapPage();
      case TabItem.SETTINGS:
        return SettingsPage();
      default:
        return MapPage();
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: _bottomTabs
        .map((tab) =>
          _buildBottomNavigationBarItem(_icon(tab), tab))
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
    switch(tab) {
      case TabItem.MAP:
        return 'Map';
      case TabItem.SETTINGS:
        return 'Settings';
      default:
        throw 'Unknown: $tab';
    }
  }

  IconData _icon(TabItem tab) {
    switch(tab) {
      case TabItem.MAP:
        return Icons.map;
      case TabItem.SETTINGS:
        return Icons.settings;
      default:
        throw 'Unknown: $tab';
    }
  }

}