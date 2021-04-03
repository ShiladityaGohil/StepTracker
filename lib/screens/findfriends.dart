import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:steptracker/screens/friendprofile.dart';

class SearchBarDemoHome extends StatefulWidget {
  final String name, uid;

  const SearchBarDemoHome({Key key, this.name, this.uid}) : super(key: key);
  @override
  _SearchBarDemoHomeState createState() => new _SearchBarDemoHomeState(name,uid);
}

class _SearchBarDemoHomeState extends State<SearchBarDemoHome> {
  SearchBar searchBar;
  
  final db = Firestore.instance;
  List<DocumentSnapshot> documents;
  List<DocumentSnapshot> friends;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final String name, uid;
  _SearchBarDemoHomeState(this.name, this.uid);

  Future getdata() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('users').getDocuments();
    documents = result.documents;
    documents.remove(uid);
    return documents;
  }

  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false, _show = false;
  String searchQuery = "Search query";

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search Friend Name",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 26.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              friends.clear();
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    /*  ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching)); */

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      _show = true;
      searchQuery = newQuery;
      friendlist();
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
      friendlist();
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  Future friendlist() async {
    QuerySnapshot result;
    if(_searchQueryController.text=="")
      result=await db.collection('users').getDocuments();
    else
      result=await db.collection('users').where('name',isEqualTo:_searchQueryController.text).getDocuments();
    return result.documents;
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: _isSearching ? const BackButton() : Container(),
        title: _isSearching ? _buildSearchField() : Text('Find Friends'),
        actions: _buildActions(),
      ),
      key: _scaffoldKey,
      body: FutureBuilder(
          future: friendlist(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ));
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  String name = snapshot.data[i]['name'];
                  if(snapshot.data[i]['uid']!=uid){
                  return InkWell(
                    onTap: (){ Navigator.push(context, 
                       MaterialPageRoute(builder:(context)=> FriendProfile(name:name,friuid:snapshot.data[i]['uid'],currentuid:uid))
                    );},
                     child: Container(
                      height: 70,
                      child: Card(
                        elevation: 20,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(name,
                              style: TextStyle(fontSize: 30, color: Colors.white)),
                        ),
                      ),
                    ),
                  );
                 }
                 else{
                   return Container();
                 }
                },
              );
            }
          }),
    );
  }
}
