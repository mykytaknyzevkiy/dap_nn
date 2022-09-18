import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../MyLocalizations.dart';
import '../../blocs/global.dart';
import '../../models/AlarmTrackModel.dart';
import '../../models/TrackModel.dart';
import '../all_songs/song_tile.dart';

class PlaybackScreen extends StatefulWidget {

  final TrackModel? trackModel;

  PlaybackScreen({this.trackModel});

  @override
  _PlaybackScreenState createState() => _PlaybackScreenState(trackModel);
}

const String MIN_DATETIME = '2010-05-12 00:00:20';
const String MAX_DATETIME = '2021-11-25 23:59:10';
const String INIT_DATETIME = '2019-05-17 18:13:15';

class _PlaybackScreenState extends State<PlaybackScreen> {

  final TrackModel? trackModel;

  _PlaybackScreenState(this.trackModel);

  final GlobalBloc _globalBloc = GlobalBloc.instance();

  String _format = 'HH:mm';
  int _itemsLength = 0;
  TextEditingController _formatCtrl = TextEditingController();

  late AppLocalizations translate;

  late SlidableController slidableController;

  final List<_HomeItem> items = List.generate(
      20,
          (i) =>
          _HomeItem(
            i,
            'Tile n°$i',
            _getSubtitle(i)!,
            _getAvatarColor(i)!,
          ));

  @override
  Widget build(BuildContext context) {
    translate = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(translate.translate('playback')),
        backgroundColor: Color(0xFF2F80ED),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                //_showTimePicker();
                _showTrackList(context);
              },
              icon: Icon(
                Icons.add_alarm,
                color: Colors.white,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: listWidget(),
    );
  }

  @override
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    super.initState();
    _formatCtrl.text = _format;
  }

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {});
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {});
  }

  Widget listWidget() {
    return Center(
      child: OrientationBuilder(
        builder: (context, orientation) =>
            _buildList(
                context,
                orientation == Orientation.portrait
                    ? Axis.vertical
                    : Axis.horizontal),
      ),
    );
  }

  Widget _buildList(BuildContext context, Axis direction) {
    return StreamBuilder<List<AlarmTrackModel>>(
      stream: _globalBloc.musicControllerBloc.alarmTracks,
      builder: (context, snapShot) {
        if (!snapShot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            scrollDirection: direction,
            itemBuilder: (context, index) {
              final Axis slidableDirection =
              direction == Axis.horizontal ? Axis.vertical : Axis.horizontal;
              var item = snapShot.data![index];
              return _getSlidableWithDelegates(
                  context, item, index, slidableDirection);
            },
            itemCount: snapShot.data!.length,
          );
        }
      },
    );
  }

  Widget _getSlidableWithDelegates(BuildContext context, AlarmTrackModel item,
      int index, Axis direction) {
    return Slidable.builder(
      key: Key(item.trackModel.name),
      controller: slidableController,
      direction: direction,
      dismissal: SlidableDismissal(
        closeOnCanceled: true,
        onWillDismiss: (index != 10)
            ? null
            : (actionType) {
          return showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Delete'),
                content: Text('Item will be deleted'),
                actions: <Widget>[
                  MaterialButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  MaterialButton(
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (actionType) {
          _showSnackBar(
              context,
              actionType == SlideActionType.primary
                  ? 'Dismiss Archive'
                  : 'Dimiss Delete');
          setState(() {
            items.removeAt(index);
          });
        },
        child: const SlidableDrawerDismissal(),
      ),
      actionPane: _getActionPane(index),
      actionExtentRatio: 0.25,
      secondaryActionDelegate: SlideActionBuilderDelegate(
          actionCount: 1,
          builder: (context, index, animation, renderingMode) {
            /*if (index == 0) {
              return IconSlideAction(
                caption: 'More',
                color: renderingMode == SlidableRenderingMode.slide
                    ? Colors.grey.shade200.withOpacity(animation.value)
                    : Colors.grey.shade200,
                icon: Icons.more_horiz,
                onTap: () => _showSnackBar(context, 'More'),
                closeOnTap: false,
              );
            } */
            return IconSlideAction(
              caption: translate.translate('delete'),
              color: renderingMode == SlidableRenderingMode.slide
                  ? Colors.red.withOpacity(animation.value)
                  : Colors.red,
              icon: Icons.delete,
              onTap: () async {
                var state = Slidable.of(context);
                var dismiss = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(translate.translate('delete')),
                      content: Text(translate.translate('playback_will_be_deleted')),
                      actions: <Widget>[
                        MaterialButton(
                          child: Text(translate.translate('cancel')),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        MaterialButton(
                          child: Text('Ok'),
                          onPressed: ()
                          {
                            _globalBloc.musicControllerBloc.removeTackPlayBack(item);
                            Navigator.of(context).pop(false);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            );
          }),
      child: direction == Axis.horizontal
          ? VerticalListItem(item)
          : HorizontalListItem(item),
    );
  }

  void _showSnackBar(BuildContext context, String text) {
    //Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  static Widget? _getActionPane(int index) {
    switch (index % 4) {
      case 0:
        return const SlidableBehindActionPane();
      case 1:
        return const SlidableStrechActionPane();
      case 2:
        return const SlidableScrollActionPane();
      case 3:
        return const SlidableDrawerActionPane();
      default:
        return null;
    }
  }

  static Color? _getAvatarColor(int index) {
    switch (index % 4) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.indigoAccent;
      default:
        return null;
    }
  }

  static String? _getSubtitle(int index) {
    switch (index % 4) {
      case 0:
        return 'SlidableBehindActionPane';
      case 1:
        return 'SlidableStrechActionPane';
      case 2:
        return 'SlidableScrollActionPane';
      case 3:
        return 'SlidableDrawerActionPane';
      default:
        return null;
    }
  }

  void _showTimePicker(TrackModel trackModel) {
    void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
      setState(() {
        _globalBloc.musicControllerBloc.addTackPlayBack(trackModel, args as DateTime);
      });
    }
    AlertDialog(
      content: Scaffold(
        body: SfDateRangePicker(
          onSelectionChanged: _onSelectionChanged,
          selectionMode: DateRangePickerSelectionMode.single,
        ),
      )
    );
  }

  void _showTrackList(BuildContext context) {
    final translater = AppLocalizations.of(context);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                translater.translate("selct_track")
            ),
            content: Container(
              width: double.maxFinite,
              child: StreamBuilder<List<TrackModel>>(
                stream: _globalBloc.musicControllerBloc.fullTracks,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return usersSongsList(snapshot, context, (track) {
                    Navigator.pop(context);
                    _showTimePicker(track);
                  });

                },
              ),
            ),
          );
        }
    );
  }

}

class _HomeItem {
  const _HomeItem(this.index,
      this.title,
      this.subtitle,
      this.color,);

  final int index;
  final String title;
  final String subtitle;
  final Color color;
}

class HorizontalListItem extends StatelessWidget {
  HorizontalListItem(this.item);

  final AlarmTrackModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 160.0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                item.trackModel.name,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VerticalListItem extends StatelessWidget {
  VerticalListItem(this.item);

  final AlarmTrackModel item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
      Slidable
          .of(context)
          ?.renderingMode == SlidableRenderingMode.none
          ? Slidable.of(context)?.open()
          : Slidable.of(context)?.close(),
      child: Container(
        color: Colors.white,
        child: ListTile(
          title: Text(item.trackModel.name),
          subtitle: Text(item.hour.toString() + ":" + item.minute.toString()),
        ),
      ),
    );
  }
}
