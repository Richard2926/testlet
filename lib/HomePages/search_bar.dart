import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:testlet/HomePages/fitnessAppHomeScreen.dart';
import 'package:testlet/ThemeRelated/fintnessAppTheme.dart';

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  SearchBar({
    Key key,
    @required this.onCancelSearch,
    @required this.onSearchQueryChanged,
  }) : super(key: key);

  final VoidCallback onCancelSearch;
  final Function(String) onSearchQueryChanged;

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> with SingleTickerProviderStateMixin {
  String searchQuery = '';
  TextEditingController _searchFieldController = TextEditingController();

  clearSearchQuery() {
    _searchFieldController.clear();
    widget.onSearchQueryChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
//                IconButton(
//                  icon: Icon(Icons.arrow_back, color: Colors.white),
//                  onPressed: widget.onCancelSearch,
//                ),
                Expanded(
                  child: TextField(
                    controller: _searchFieldController,
                    cursorColor: Colors.white,
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Raleway',
                    color: FintnessAppTheme.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: FintnessAppTheme.white,
                        size: 23,
                      ),
                      hintText: "Search...",
                      hintStyle: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Raleway'),
                      suffixIcon: InkWell(
                        child: Padding(
                          padding: EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.close,
                              color: FintnessAppTheme.white,
                              size: 23,
                            ),
                        ),
                        onTap: widget.onCancelSearch,
                      ),
                    ),
                    onChanged: widget.onSearchQueryChanged,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}