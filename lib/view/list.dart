import 'package:base/view/query.dart';
import 'package:base/view/tile.dart';
import 'package:base/view_model/connection_vm.dart';
import 'package:base/view_model/details_vm.dart';
import 'package:base/view_model/top_vm.dart';
import 'package:flutter/material.dart';
import '../view_model/add_vm.dart';
import '../view_model/list_vm.dart';
import '../view_model/progress_vm.dart';
import 'details.dart';

class ListWidget extends StatefulWidget {
  ListWidget({
    super.key,
    required ListViewModel listViewModel,
    required ProgressViewModel progressViewModel,
    required TopViewModel topViewModel,
    required DetailsViewModel detailsViewModel,
    required AddViewModel addViewModel,
    required ConnectionViewModel connectionViewModel,
  }) {
    _listViewModel = listViewModel;
    _progressViewModel = progressViewModel;
    _topViewModel = topViewModel;
    _detailsViewModel = detailsViewModel;
    _addViewModel = addViewModel;
    _connectionViewModel = connectionViewModel;
  }

  late final ListViewModel _listViewModel;
  late final ProgressViewModel _progressViewModel;
  late final TopViewModel _topViewModel;
  late final DetailsViewModel _detailsViewModel;
  late final AddViewModel _addViewModel;
  late final ConnectionViewModel _connectionViewModel;

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  bool? _light;

  late final MaterialStateProperty<Icon?> _thumbIcon;

  late final MaterialStateProperty<Color?> _trackColor;

  @override
  void initState() {
    super.initState();
    _thumbIcon = _resolveThumbIcon();
    _trackColor = _resolveTrackColor();
    _light = widget._connectionViewModel.connected;
  }

  @override
  void dispose() {
    _light = false;
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List ${widget._connectionViewModel.connected ? '(online)' : '(offline)'}',
        ),
        actions: [
          Switch(
            value: _light!,
            thumbIcon: _thumbIcon,
            trackColor: _trackColor,
            onChanged: (final value) {
              setState(() {
                widget._connectionViewModel.switchConnection();
                _light = value;
              });
            },
          ),
          IconButton(
            onPressed: () => !widget._connectionViewModel.connected
                ? _pressOnlineOnlyFeature(context)
                : _pressProgress(context),
            disabledColor: Colors.grey,
            tooltip: 'Progress',
            icon: const Icon(
              Icons.add_alarm,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () => !widget._connectionViewModel.connected
                ? _pressOnlineOnlyFeature(context)
                : _pressTopThree(context),
            tooltip: 'Top Three Categories',
            disabledColor: Colors.grey,
            icon: const Icon(
              Icons.account_balance,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: widget._connectionViewModel.stream,
            builder: (final context, final snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Date: ${data.date}, Type: ${data.type}, Amount: ${data.amount}, Category: ${data.category}, Description: ${data.description}',
                    ),
                  ));
                });
              }
              return const SizedBox();
            },
          ),
          Expanded(
            child: StreamBuilder(
              stream: widget._listViewModel.datesStream,
              builder: (final context, final snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final data = snapshot.data!;
                return ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (final context, final index) =>
                      const Divider(),
                  itemBuilder: (final context, final index) {
                    final date = data[index].date;
                    return GestureDetector(
                      onTap: () => _tapListItem(context, date),
                      child: ListTile(
                        title: Text(date),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  MaterialStateProperty<Icon?> _resolveThumbIcon() =>
      MaterialStateProperty.resolveWith(
        (final states) {
          if (states.contains(MaterialState.selected)) {
            return const Icon(Icons.check, color: Colors.white);
          }
          return const Icon(Icons.close, color: Colors.blue);
        },
      );

  MaterialStateProperty<Color?> _resolveTrackColor() =>
      MaterialStateProperty.resolveWith((final states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.grey.shade300;
        }
        return Colors.grey.shade500;
      });

  void _pressOnlineOnlyFeature(final BuildContext context) async {
    showDialog(
      context: context,
      builder: (final context) {
        return AlertDialog(
          title: const Text('Offline'),
          content: const Text('Selected feature is only available Online'),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _pressProgress(final BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (final context) {
          return QueryWidget(
            response: widget._progressViewModel.getWeeks(),
            tileBuilder: buildWeekTile,
          );
        },
      ),
    );
  }

  void _pressTopThree(final BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (final context) {
          return QueryWidget(
            response: widget._topViewModel.getCategories(),
            tileBuilder: buildTopTile,
          );
        },
      ),
    );
  }

  void _tapListItem(final BuildContext context, final String date) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (final context) {
          return DetailsWidget(
            detailsViewModel: widget._detailsViewModel,
            addViewModel: widget._addViewModel,
            connectionViewModel: widget._connectionViewModel,
            date: date,
          );
        },
      ),
    );
    await Future.delayed(const Duration(milliseconds: 500));
    widget._listViewModel.getFinances(date);
  }
}
