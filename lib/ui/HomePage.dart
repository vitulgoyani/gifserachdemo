import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gifserachdemo/controller/get_meme_list_controller.dart';
import 'package:gifserachdemo/ui/UserListPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController = new ScrollController();
  final GetMemeListController getMemeListController =
      Get.put(GetMemeListController());
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
          getMemeListController.callUpdate();
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
        title: const Text("Meme Search"),
        actions: [
          ElevatedButton(
              onPressed: () {
                Get.to(UserListPage());
              },
              child: Text("User List"))
        ],
      ),
      body: Column(
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
              if (getMemeListController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: getMemeListController.listOfMeme.length,
                    itemBuilder: (context, index) {
                      if (filter == null || filter == "") {
                        return Card(
                          child: Image.network(
                            getMemeListController.listOfMeme[index].url!,
                            height: 200,
                          ),
                        );
                      } else {
                        if (getMemeListController.listOfMeme[index].name!
                            .toLowerCase()
                            .contains(filter!.toLowerCase())) {
                          return Card(
                            child: Image.network(
                              getMemeListController.listOfMeme[index].url!,
                              height: 200,
                            ),
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
    );
  }
}
