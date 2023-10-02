import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/const/colors.dart';
import 'package:music_player/const/text_style.dart';
import 'package:music_player/cotroller/player_controller.dart';
import 'package:music_player/view/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Scaffold(
        backgroundColor: darkColor,
        appBar: AppBar(
          backgroundColor: darkColor,
          leading: const Icon(
            Icons.sort_rounded,
            color: whiteColor,
          ),
          title: Text('Beats', style: ourStyle(size: 18)),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: whiteColor,
                ))
          ],
        ),
        body: FutureBuilder<List<SongModel>>(
            future: controller.audioQuery.querySongs(
                ignoreCase: true,
                orderType: OrderType.ASC_OR_SMALLER,
                sortType: null,
                uriType: UriType.EXTERNAL),
            builder: (BuildContext context, snapshot) {
              if (snapshot.data == null) {
                return const CircularProgressIndicator();
              } else if (snapshot.data!.isEmpty) {
                return const Center(
                    child: Text(
                  'No Songs found',
                  style: TextStyle(
                      fontSize: 14,
                      color: whiteColor,
                      fontWeight: FontWeight.bold),
                ));
              } else {
                print(snapshot.data);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 2),
                          child: Obx(
                            () => ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              tileColor: mainColor,
                              title: Text(
                                snapshot.data![index].displayNameWOExt,
                                style: ourStyle(
                                    size: 15, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "${snapshot.data![index].artist}",
                                style: ourStyle(
                                    size: 12, fontWeight: FontWeight.normal),
                              ),
                              leading: QueryArtworkWidget(
                                id: snapshot.data![index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Icon(
                                  Icons.music_note,
                                  color: whiteColor,
                                  size: 32,
                                ),
                              ),
                              trailing: controller.playIndex == index &&
                                      controller.isPlaying.value
                                  ? const Icon(
                                      Icons.play_arrow,
                                      size: 26,
                                      color: whiteColor,
                                    )
                                  : null,
                              onTap: () {
                                Get.to(() => Player(
                                      data: snapshot.data!,
                                    ));
                                controller.playMusic(
                                    snapshot.data![index].uri, index);
                              },
                            ),
                          ),
                        );
                      }),
                );
              }
            }));
  }
}
