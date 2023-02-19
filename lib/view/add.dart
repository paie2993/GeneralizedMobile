import 'package:base/view_model/add_vm.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import '../model/model.dart';

class AddWidget extends StatefulWidget {
  AddWidget({
    super.key,
    required AddViewModel addViewModel,
    required String date,
  }) {
    _addViewModel = addViewModel;
    _date = date;
  }

  late final AddViewModel _addViewModel;
  late final String _date;

  @override
  State<StatefulWidget> createState() => _AddState();
}

class _AddState extends State<AddWidget> {
  final GlobalKey<FormState> _globalKey = GlobalKey();

  final TextEditingController _date = TextEditingController();
  final TextEditingController _type = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _category = TextEditingController();
  final TextEditingController _description = TextEditingController();

  final RegExp _dateRegExp = RegExp(r'^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
  final RegExp _amountRegExp = RegExp(r'^[0-9]+(\.[0-9]+)?$');

  @override
  void initState() {
    super.initState();
    _date.text = widget._date;
  }

  @override
  void dispose() {
    super.dispose();
    _date.dispose();
    _type.dispose();
    _amount.dispose();
    _category.dispose();
    _description.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.00),
        child: Form(
          key: _globalKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _date,
                validator: (final value) => _dateValidator(value),
                decoration: const InputDecoration(
                  label: Text('Date'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15.00),
              TextFormField(
                controller: _type,
                decoration: const InputDecoration(
                  label: Text('Type'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15.00),
              TextFormField(
                controller: _amount,
                validator: (final value) => _amountValidator(value),
                decoration: const InputDecoration(
                  label: Text('Amount'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15.00),
              TextFormField(
                controller: _category,
                decoration: const InputDecoration(
                  label: Text('Category'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15.00),
              TextFormField(
                controller: _description,
                decoration: const InputDecoration(
                  label: Text('Description'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15.00),
              TextButton(
                onPressed: () => _pressedAddButton(context),
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _dateValidator(final String? value) {
    if (value == null) {
      developer.log(
        'Date value is null: not allowed',
        name: '_AddState:_dateValidator',
      );
      return 'Date cannot be null';
    }
    if (!_dateRegExp.hasMatch(value)) {
      developer.log(
        'Date value does not follow the date format',
        name: '_AddState:_dateValidator',
      );
      return 'Date format not followed';
    }
    return null;
  }

  String? _amountValidator(final String? value) {
    if (value == null) {
      developer.log(
        'Amount value is null: not allowed',
        name: '_AddState:_amountValidator',
      );
      return 'Date cannot be null';
    }
    if (!_amountRegExp.hasMatch(value)) {
      developer.log(
        'Amount value does not follow the amount format',
        name: '_AddState:_amountValidator',
      );
      return 'Amount format not followed';
    }
    return null;
  }

  void _pressedAddButton(final BuildContext context) async {
    if (!_globalKey.currentState!.validate()) {
      developer.log(
        'Form did not pass validation',
        name: '_AddState:_pressedAddButton',
      );
      return;
    }
    developer.log(
      'Form passed validation',
      name: '_AddState:_pressedAddButton',
    );
    late final FinanceModel? finance;
    try {
      finance = _buildFinance();
    } on Exception {
      developer.log(
        'Exception building FinanceModel from given form data',
        name: '_AddState:_pressedAddButton',
      );
      return;
    }
    if (finance == null) {
      developer.log(
        'Failed to build FinanceModel from given form data',
        name: '_AddState:_pressedAddButton',
      );
      return;
    }
    widget._addViewModel.add(finance);
    Navigator.of(context).pop();
  }

  FinanceModel? _buildFinance() {
    final date = _date.text;
    final type = _type.text;
    final amount = _amount.text;
    final category = _category.text;
    final description = _description.text;

    final realAmount = double.tryParse(amount);
    if (realAmount == null) {
      return null;
    }

    return FinanceModel(
      date: date,
      type: type,
      amount: realAmount,
      category: category,
      description: description,
    );
  }
}
