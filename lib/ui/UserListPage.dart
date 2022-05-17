import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifserachdemo/controller/get_user_list_controller.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  ScrollController _scrollController = new ScrollController();
  final GetUserListController getUserListController =
      Get.put(GetUserListController());
  TextEditingController searchController = new TextEditingController();
  String? filter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
          // You're at the top.
        } else {
          getUserListController.getUserListAPICall();
        }
      }
    });

    searchController.addListener(() {
      if (this.mounted)
        setState(() {
          filter = searchController.text;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User List"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: TextField(
                  autocorrect: false,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: searchController.text != ""
                        ? IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              searchController.clear();
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                          )
                        : SizedBox(),
                    hintText: "Search meme",
                  ),
                  controller: searchController,
                ),
              ),
              Divider(),
              Expanded(
                child: Obx(() {
                  if (getUserListController.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: getUserListController.listOfUser.length,
                        itemBuilder: (context, index) {
                          if (filter == null || filter == "") {
                            return Card(
                                child: Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          getUserListController
                                                  .listOfUser[index]
                                                  .picture
                                                  ?.thumbnail ??
                                              "")),
                                  title: Row(children: [
                                    Text(
                                        "${getUserListController.listOfUser[index].name?.title} "),
                                    Text(
                                        "${getUserListController.listOfUser[index].name?.first} "),
                                    Text(
                                        "${getUserListController.listOfUser[index].name?.last}"),
                                  ]),
                                )
                              ],
                            ));
                          } else {
                            String firstName = getUserListController
                                    .listOfUser[index].name?.first ??
                                "";
                            if (firstName
                                .toLowerCase()
                                .contains(filter!.toLowerCase())) {
                              return ListTile(
                                leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        getUserListController.listOfUser[index]
                                                .picture?.thumbnail ??
                                            "")),
                                title: Row(children: [
                                  Text(
                                      "${getUserListController.listOfUser[index].name?.title} "),
                                  Text(
                                      "${getUserListController.listOfUser[index].name?.first} "),
                                  Text(
                                      "${getUserListController.listOfUser[index].name?.last}"),
                                ]),
                              );
                            } else {
                              return const SizedBox();
                            }
                          }
                        });
                  }
                }),
              ),
            ],
          ),
          Obx(() {
            return getUserListController.isLoadingMore == true
                ? Positioned.fill(
                    child: Container(
                        color: Colors.black54,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 10),
                              Text(
                                "Load more data...",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        )))
                : SizedBox();
          }),
        ],
      ),
    );
  }
}
