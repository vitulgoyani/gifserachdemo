import 'package:get/get.dart';
import 'package:gifserachdemo/common/network_utils.dart';
import 'package:gifserachdemo/model/meme_list_model.dart';
import 'package:gifserachdemo/model/user_list_model.dart';

class GetUserListController extends GetxController {
  var userList = UserList();
  var isLoading = true.obs;
  var isLoadingMore = false.obs;
  var listOfUser = <Result>[].obs;
  int i=0;

  @override
  void onInit() {
    // TODO: implement onInit
    getUserListAPICall();
    super.onInit();
  }

  void getUserListAPICall() {
    if(i!=0){
      isLoadingMore(true);
    }
    i++;
    NetworkUtils().getUserList().then((value) {
      if (value != null) {
        userList = value;
        value!.results!.forEach((element) {
          listOfUser.add(element);
        });
        isLoading(false);
        isLoadingMore(false);
      }
    });
  }
}
