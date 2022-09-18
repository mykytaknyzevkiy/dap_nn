import 'package:dap_app_new/models/TrackModel.dart';

class AlarmTrackModel {

  final int hour;
  final int minute;
  final TrackModel trackModel;
  final int alarmID;

  AlarmTrackModel(this.alarmID, this.hour, this.minute, this.trackModel);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> _map = {};
    _map['alarmID'] = alarmID;
    _map['hour'] = hour;
    _map['minute'] = minute;
    _map['trackModel'] = trackModel.toMap();
    return _map;
  }

  factory AlarmTrackModel.fromJson(Map<String, dynamic> json) {
    return AlarmTrackModel(
        json['alarmID'],
        json['hour'],
        json['minute'],
        TrackModel.fromJson(json['trackModel'])
    );
  }

}