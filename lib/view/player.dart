import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/const/colors.dart';
import 'package:music_player/const/text_style.dart';
import 'package:music_player/cotroller/player_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Player extends StatelessWidget {
  final List<SongModel> data;
  const Player({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () => Expanded(
                  child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                // ignore: sort_child_properties_last
                child: QueryArtworkWidget(
                  id: data[controller.playIndex.value].id,
                  type: ArtworkType.AUDIO,
                  artworkHeight: double.infinity,
                  artworkWidth: double.infinity,
                  nullArtworkWidget: const Icon(
                    Icons.music_note,
                    size: 48,
                    color: whiteColor,
                  ),
                ),
                alignment: Alignment.center,
              )),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  color: whiteColor),
              child: Obx(
                () => Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      data[controller.playIndex.value].displayNameWOExt,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: ourStyle(
                          color: darkColor,
                          fontWeight: FontWeight.bold,
                          size: 18),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      data[controller.playIndex.value].artist.toString(),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: ourStyle(
                          color: darkColor,
                          fontWeight: FontWeight.normal,
                          size: 16),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Obx(
                      () => Row(
                        children: [
                          Text(
                            controller.position.value,
                            style: ourStyle(color: darkColor),
                          ),
                          Expanded(
                            child: Slider(
                                activeColor: sliderColor,
                                thumbColor: sliderColor,
                                inactiveColor: mainColor,
                                min: const Duration(seconds: 0)
                                    .inSeconds
                                    .toDouble(),
                                max: controller.max.value,
                                value: controller.value.value,
                                onChanged: (newValue) {
                                  controller
                                      .changeDurationToSecond(newValue.toInt());
                                  newValue = newValue;
                                }),
                          ),
                          Text(
                            controller.duration.value,
                            style: ourStyle(color: darkColor),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              controller.playMusic(
                                  data[controller.playIndex.value - 1].uri,
                                  controller.playIndex.value - 1);
                            },
                            icon: const Icon(
                              Icons.skip_previous_rounded,
                              size: 40,
                              color: darkColor,
                            )),
                        Obx(
                          () => CircleAvatar(
                            radius: 35,
                            backgroundColor: darkColor,
                            child: Transform.scale(
                              scale: 2.5,
                              child: IconButton(
                                  onPressed: () {
                                    if (controller.isPlaying.value) {
                                      controller.audioPlayer.pause();
                                      controller.isPlaying(false);
                                    } else {
                                      controller.audioPlayer.play();
                                      controller.isPlaying(true);
                                    }
                                  },
                                  icon: controller.isPlaying.value
                                      ? const Icon(
                                          Icons.pause,
                                          color: whiteColor,
                                        )
                                      : const Icon(
                                          Icons.play_arrow_rounded,
                                          color: whiteColor,
                                        )),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              controller.playMusic(
                                  data[controller.playIndex.value + 1].uri,
                                  controller.playIndex.value + 1);
                            },
                            icon: const Icon(
                              Icons.skip_next_rounded,
                              size: 40,
                              color: darkColor,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
