import 'package:flutter/material.dart';

import '../model/response/response.dart';

class QueryWidget<T> extends StatelessWidget {
  QueryWidget(
      {super.key,
      required Future<Response<List<T>>> response,
      required Function(BuildContext, T) tileBuilder}) {
    _response = response;
    _tileBuilder = tileBuilder;
  }

  late final Future<Response<List<T>>> _response;
  late final Function(BuildContext, T) _tileBuilder;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.00),
        child: FutureBuilder(
          future: _response,
          builder: (final context, final snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final data = snapshot.data!;
            if (!data.status) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(data.error!)),
              );
              return const Center(child: Text(':('));
            }
            final list = data.value!;
            if (list.isEmpty) {
              return const Center(
                child: Text(
                  'No data :(',
                  style: TextStyle(
                    fontSize: 20.00,
                    fontFamily: 'Roboto',
                  ),
                ),
              );
            }
            return ListView.separated(
              itemCount: list.length,
              separatorBuilder: (final context, final index) => const Divider(),
              itemBuilder: (final context, final index) {
                final item = list[index];
                return _tileBuilder(context, item);
              },
            );
          },
        ),
      ),
    );
  }
}
