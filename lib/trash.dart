
/*
  List<PostsModel> posts = [];
  int likes =0;
  int index=0;

  void getPosts() {
    emit(HomeLoadingGetPostsState());
    FirebaseFirestore.instance.collection('posts')
    .snapshots().listen((event) {
      posts = [];
       index=0;
      likes =0;
      for (var docPost in event.docs) {
        print("----------------------\n");
        posts.add(PostsModel.fromJson(docPost.data()));
        docPost.reference
            .collection('likes')
            .get()
            .then((value) {
              for (var element in value.docs) {
                print("==================\n");
                likes++;
                emit(HomeCounterLikesState());
              }
        }).catchError((error){
          emit(HomeErrorLikeState(error.toString()));
        });

      }
      emit(HomeSuccessGetPostsState());
    });
  }

*/

/*

  void getLikes(String postId){

    emit(HomeLoadingGetPostsState());
    for(var element in posts){
      if(element.postId==postId){
    FirebaseFirestore.instance.
    collection('posts')
        .doc(postId)
        .collection('likes')
    .snapshots().listen((event) {
      index = 0;
      likes = 0;
      for (var docLikes in event.docs) {
        print("----------------------\n");

        element.usersLiked;
      }
    }

        }


      }
      emit(HomeSuccessGetPostsState());

  }

*/


/*Future<UserModel> getUserData(String id)=> FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get().then((value) {
      return  UserModel.fromJson(value.data()!);
    }).catchError((error){
      emit(UsersErrorUserState(error.toString()));
    });
*/

/*
Padding(
padding: const EdgeInsetsDirectional.only(
top: 5.0,
bottom: 10.0,
),
child: SizedBox(
width: double.infinity,
child: Wrap(
direction: Axis.horizontal,
children: [
Padding(
padding: const EdgeInsetsDirectional.only(
end: 6.0,
),
child: SizedBox(
height: 25.0,
child: MaterialButton(
height: 25.0,
minWidth: 1.0,
padding: EdgeInsets.zero,
child: Text(
'#birthday',
style: Theme.of(context)
.textTheme
    .bodyMedium!
.copyWith(
color: Colors.blue,
),
),
onPressed: () {}),
),
),
Padding(
padding: const EdgeInsetsDirectional.only(
end: 10.0,
),
child: SizedBox(
height: 25.0,
child: MaterialButton(
height: 25.0,
minWidth: 1.0,
padding: EdgeInsets.zero,
child: Text(
'#birthday',
style: Theme.of(context)
.textTheme
    .bodyMedium!
.copyWith(
color: Colors.blue,
),
),
onPressed: () {}),
),
),
],
),
),
),
*/
