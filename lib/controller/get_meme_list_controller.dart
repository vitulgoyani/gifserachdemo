import 'package:get/get.dart';
import 'package:gifserachdemo/common/network_utils.dart';
import 'package:gifserachdemo/model/meme_list_model.dart';

class GetMemeListController extends GetxController {
  var memeList = MemeList();
  var isLoading = true.obs;
  var listOfMeme = [].obs;
  int start = 0;
  int end = 4;
  int i = 0;

  @override
  void onInit() {
    // TODO: implement onInit
    getMemeListAPICall();
    super.onInit();
  }

  void getMemeListAPICall() {
    NetworkUtils().getMemeList().then((value) {
      if (value != null) {
        memeList = value;
        callUpdate();
        isLoading(false);
      }
    });
  }

  void callUpdate() {
    if (end <= memeList.data!.memes!.length) {
      for (start; start < end; start++) {
        listOfMeme.add(memeList.data!.memes![start]);
      }

      start = end;
      end = start + 4;
    }
  }
}
