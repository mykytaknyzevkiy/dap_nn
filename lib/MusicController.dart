import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/AlarmTrackModel.dart';
import 'models/TrackModel.dart';
import 'models/playerstate.dart';
import 'models/song_model.dart';
import 'sign_in.dart';
import 'unit/MyConst.dart';
import 'unit/Requester.dart';

Future<List<TrackModel>> searchSong(String quary) async {
  final data = await Requester().get(
      '/tracks',
      <String, String>{'search': quary},
      'tracks',
          (data) =>
          (data as List).map((it) => TrackModel.fromJson(it)).toList());

  if (!data.success) {
    return [];
  }

  return data.data;
}

Future<String?> trackPaymentUrl(String trackId) async {
  final data = await Requester().create('/tracks/$trackId/add',
      <String, String>{}, 'paypal_url', (data) => data);

  if (!data.success) {
    return null;
  }

  return data.data.toString();
}

class MusicController {
  final _audioPlayer = MusicPlayerN();

  MusicController() {
    _audioPlayer.onIsPlaying = (TrackModel trackModel) {
      trackStates.value = (MapEntry(PlayerState.playing, trackModel));
    };
    _audioPlayer.onIsPaused = (TrackModel trackModel) {
      trackStates.add(MapEntry(PlayerState.paused, trackModel));
    };
    _audioPlayer.onIsLoading = (TrackModel trackModel) {
      trackStates.add(MapEntry(PlayerState.loading, trackModel));
    };

    init();
  }

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  NotificationDetails? platformChannelSpecifics;

  static SharedPreferences? prefs;

  Timer? currentTime;

  Future<void> _handleMethod(MethodCall call) async {

    print('Nikita _handleMethod ' + call.arguments);

    //print('Nikita _handleMethod ' + json.decode(call.arguments as String));

    if (call.method == 'didReceiveLocalNotification_nek') {

      if (alarmTracks == null || alarmTracks.value == null || alarmTracks.value.isEmpty) {
        createArmList();
      }


      TrackModel? trackModel;

      for (AlarmTrackModel alarmTrackModel in alarmTracks.value) {
        if ((call.arguments as String).contains(alarmTrackModel.alarmID.toString())) {
          trackModel = alarmTrackModel.trackModel;
        }
      }

      playTrack(trackModel!);

    }

    switch (call.method) {
      case 'selectNotification':
        print('Nikita selectNotification');
        break;
      case 'didReceiveLocalNotification':
        print('Nikita didReceiveLocalNotification');
        break;
      default:
        print('Nikita default');
        break;
    }
  }

  createArmList() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs!.containsKey(MyConst.alrm_list_key)) {
      final listString = prefs!.getStringList(MyConst.alrm_list_key);


      final alarmListNew = <AlarmTrackModel>[];

      for (var value in listString) {
        alarmListNew.add(AlarmTrackModel.fromJson(json.decode(value)));
      }

      alarmTracks = BehaviorSubject.seeded(alarmListNew);
    }
  }

  init() async {

    prefs = await SharedPreferences.getInstance();

    // await AndroidAlarmManager.initialize();
    final _fullTracks = await searchSong('');
    fullTracks.add(_fullTracks);
    userTrackIds.add(myUserModel!.trackIds);

    createArmList();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin!.initialize(initializationSettings,
        onSelectNotification: null);

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails('Playback', 'Playback');

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);


    var result = await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    const MethodChannel _channel =
    MethodChannel('dexterous.com/flutter/local_notifications');

    _channel.setMethodCallHandler(_handleMethod);

  }

  BehaviorSubject<List<TrackModel>> fullTracks = BehaviorSubject.seeded(null);

  BehaviorSubject<List<String>> userTrackIds = BehaviorSubject.seeded([]);

  BehaviorSubject<MapEntry<PlayerState, TrackModel>> trackStates =
  BehaviorSubject.seeded(null);

  BehaviorSubject<TrackModel> onPayingTrack = BehaviorSubject.seeded(null);

  BehaviorSubject<List<AlarmTrackModel>> alarmTracks =
  BehaviorSubject.seeded([]);

  addUserTrack(TrackModel trackModel) {
    userTrackIds.value.add(trackModel.id);
  }

  playTrack(TrackModel trackModel) async {
    if (currentTime != null) {
      currentTime!.cancel();
    }
    var trackTime = 0.0;
    if (trackModel.getRealDuration() != trackModel.duration) {
      trackTime = trackModel.getRealDuration();
    }

    await _audioPlayer.playInt(trackModel);

    if (trackTime < 60) {
      currentTime = new Timer(Duration(milliseconds: (trackModel.duration * 1000).toInt()), () {
        _audioPlayer.pause(trackModel);
      });
    }
    else if (trackModel.duration > trackTime) {
      currentTime = new Timer(Duration(milliseconds: (trackTime * 1000).toInt()), () {
        _audioPlayer.pause(trackModel);
      });
    }
    else {
      playTrackReal(trackModel, trackTime);
    }

  }

  playTrackReal(TrackModel trackModel, double trackTime) async {
    await _audioPlayer.playInt(trackModel);

    currentTime = createTrackTime(trackModel, trackTime);
  }

  Timer createTrackTime(TrackModel trackModel, double trackTime) {

    final trackTimeN = (trackModel.duration * 1000).toInt();
    final songTimeN = (trackTime * 1000).toInt();

    if ( trackTimeN > songTimeN) {
      return new Timer(Duration(milliseconds: songTimeN), () {
        _audioPlayer.pause(trackModel);
      });
    }

    return new Timer(Duration(milliseconds: trackTimeN), () {
      trackTime -= trackModel.duration;
      if (trackTime > 0) {
        playTrackReal(trackModel, trackTime);
      }
      else
        _audioPlayer.pause(trackModel);
    });
  }

  pauseTrack(TrackModel trackModel) {
    _audioPlayer.pause(trackModel);
    if (currentTime != null) {
      currentTime!.cancel();
    }
  }

  dispose() {
    fullTracks.close();
    userTrackIds.close();
    trackStates.close();
    onPayingTrack.close();
    alarmTracks.close();
  }

  addTackPlayBack(TrackModel trackModel, DateTime dateTime) async {
    print("Date time is " + dateTime.toString());
    final alarmID = Random().nextInt(pow(2, 31).toInt());

    var scheduledNotificationDateTime = Time(dateTime.hour, dateTime.minute, 0);

    alarmTracks.value.add(AlarmTrackModel(alarmID, dateTime.hour, dateTime.minute, trackModel));

    await flutterLocalNotificationsPlugin?.showDailyAtTime(
        alarmID,
        trackModel.name,
        trackModel.description,
        scheduledNotificationDateTime,
        platformChannelSpecifics!);

    reSaveAlarmsList();

  }

  removeTackPlayBack(AlarmTrackModel alarmTrackModel) async {
    final trackAlrm = alarmTracks.value;
    trackAlrm.remove(alarmTrackModel);
    alarmTracks.add(trackAlrm);

    reSaveAlarmsList();

    await flutterLocalNotificationsPlugin!.cancel(alarmTrackModel.alarmID);
  }

  reSaveAlarmsList() {
    final saveList = <String>[];

    for (AlarmTrackModel alarmTrackModel in alarmTracks.value) {
      saveList.add(json.encode(alarmTrackModel.toMap()));
    }

    prefs!.setStringList(MyConst.alrm_list_key, saveList);
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    print("onDidReceiveLocalNotification");
  }

}
