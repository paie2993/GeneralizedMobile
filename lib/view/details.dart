import 'package:base/view_model/add_vm.dart';
import 'package:base/view_model/details_vm.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../model/model.dart';
import '../view_model/connection_vm.dart';
import 'add.dart';

class DetailsWidget extends StatelessWidget {
  DetailsWidget({
    super.key,
    required DetailsViewModel detailsViewModel,
    required AddViewModel addViewModel,
    required ConnectionViewModel connectionViewModel,
    required String date,
  }) {
    _detailsViewModel = detailsViewModel;
    _addViewModel = addViewModel;
    _connectionViewModel = connectionViewModel;
    _date = date;
  }

  late final DetailsViewModel _detailsViewModel;
  late final AddViewModel _addViewModel;
  late final ConnectionViewModel _connectionViewModel;
  late final String _date;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Details ${_connectionViewModel.connected ? '(online)' : '(offline)'}',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pressActionButton(context, _date),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder(
        stream: _detailsViewModel.financesStream,
        builder: (final context, final snapshot) {
          developer.log(
            'Details StreamBuilder builder called',
            name: 'DetailsWidget:build',
          );
          if (!snapshot.hasData) {
            return const Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No data',
                style: TextStyle(
                  fontSize: 20.00,
                  fontFamily: 'Roboto',
                ),
              ),
            );
          }
          final data = snapshot.data!;
          developer.log(
            'Details StreamBuilder snapshot data: $data',
            name: 'DetailsWidget:build',
          );
          return Padding(
            padding: const EdgeInsets.all(16.00),
            child: ListView.separated(
              itemCount: data.length,
              separatorBuilder: (final context, final index) => const Divider(),
              itemBuilder: (final context, final index) {
                final item = data[index];
                return _connectionViewModel.connected
                    ? _deletableCard(context, item)
                    : _unDeletableCard(context, item);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _deletableCard(final BuildContext context, final FinanceModel item) {
    return Dismissible(
      key: Key(item.id.toString()),
      onDismissed: (final direction) => _dismiss(context, direction, item.id!),
      child: _detailsCard(item),
    );
  }

  Widget _unDeletableCard(final BuildContext context, final FinanceModel item) {
    return GestureDetector(
      onHorizontalDragEnd: (final details) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Deleting Finances is only available online'),
          ),
        );
      },
      child: _detailsCard(item),
    );
  }

  Card _detailsCard(final FinanceModel item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.00),
        child: DefaultTextStyle.merge(
          style: const TextStyle(
            fontSize: 15.00,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Type: ${item.type}'),
              Text('Amount: ${item.amount}'),
              Text('Category: ${item.category}'),
              Text('Description: ${item.description}'),
            ],
          ),
        ),
      ),
    );
  }

  void _dismiss(
    final BuildContext context,
    final DismissDirection direction,
    final int id,
  ) async {
    await _detailsViewModel.deleteFinance(id, _date);
  }

  void _pressActionButton(final BuildContext context, final String date) {
    if (!_connectionViewModel.connected) {
      showDialog(
        context: context,
        builder: (final context) {
          return AlertDialog(
            title: const Text('Offline'),
            content: const Text('Adding finances is only available online'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (final context) {
          return AddWidget(
            addViewModel: _addViewModel,
            date: date,
          );
        },
      ),
    );
  }
}
