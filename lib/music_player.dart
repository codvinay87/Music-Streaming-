import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  bool isPlaying = false;
  double value = 0;
  //created an instance of music player
  final player = AudioPlayer();

  //setting the duration
  Duration? duration = Duration(seconds: 0);

  // create functionm to initiaqte music into the player

  void initPlayer() async {
    await player.setSource(AssetSource("Iraaday(PaglaSongs).mp3"));
    duration = await player.getDuration();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text("Music Streaming Platform"),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: Column(
            children: [
              Image.asset("assets/Cover.jpg"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "${(value / 60).floor()}:${(value % 60).floor()}",
                    style: TextStyle(color: Colors.white),
                  ),
                  Expanded(
                    child: Slider.adaptive(
                      min: 0.0,
                      max: duration!.inSeconds.toDouble(),
                      value: value,
                      onChanged: (v) {
                        setState(() {
                          value = v;
                        });
                      },
                      onChangeEnd: (newValue) async {
                        setState(() {
                          value = newValue;
                          print(newValue);
                        });
                        player.pause();
                        await player.seek(Duration(seconds: newValue.toInt()));
                        await player.resume();
                      },
                      activeColor: Colors.white,
                    ),
                  ),
                  // const SizedBox(
                  //   width: 50,
                  // ),
                  Text(
                    duration != null
                        ? "${duration!.inMinutes} : ${duration!.inSeconds % 60}"
                        : "Loading...", // Display a loading message when duration is null
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.black87,
                        border: Border.all(color: Colors.pink)),
                    child: InkWell(
                      onTap: () async {
                        //here we will play the song

                        if (isPlaying) {
                          await player.pause();
                          setState(() {
                            isPlaying = false;
                          });
                        } else {
                          await player.resume();
                          setState(() {
                            isPlaying = true;
                          });

                          player.onPositionChanged.listen(
                            (position) => setState(
                              () {
                                value = position.inSeconds.toDouble();
                              },
                            ),
                          );
                        }
                      },
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.black87,
                        border: Border.all(color: Colors.pink)),
                    child: InkWell(
                      onTap: () async {
                        player.onPositionChanged.listen(
                          (position) => setState(
                            () {
                              value = position.inSeconds.toDouble() + 10;
                            },
                          ),
                        );
                      },
                      child: Icon(
                        Icons.forward_10_rounded,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
