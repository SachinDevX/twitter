import 'package:flutter/material.dart';

class FollowListPage extends StatefulWidget {
  const FollowListPage({super.key});

  @override
  State<FollowListPage> createState() => _FollowListPageState();
}

class _FollowListPageState extends State<FollowListPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            //Tab BAR
            bottom: TabBar(
                tabs: [
                  Tab(text: "Follower",),
                  Tab(text: "Following",),
                ]
            ),
          ),

          //Tab Bar View
          body: TabBarView(
              children: [
                Text("FOLLOWER"),
                Text("FOLLOWING"),
              ]
          ),
        )
    );
  }
}
