import 'package:base/view_model/add_vm.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import '../model/model.dart';

class AddWidget extends StatefulWidget {
  AddWidget({
    super.key,
    required AddViewModel addViewModel,
    // required Field field,
  }) {
    _addViewModel = addViewModel;
    // _field = field;
  }

  late final AddViewModel _addViewModel;

  // late final Field _field;

  @override
  State<StatefulWidget> createState() => _AddState();
}

class _AddState extends State<AddWidget> {
  final GlobalKey<FormState> _globalKey = GlobalKey();

  final TextEditingController _field = TextEditingController();
  final TextEditingController _field = TextEditingController();
  final TextEditingController _field = TextEditingController();
  final TextEditingController _field = TextEditingController();
  final TextEditingController _field = TextEditingController();
  final TextEditingController _field = TextEditingController();
  final TextEditingController _field = TextEditingController();
  final TextEditingController _field = TextEditingController();

  final RegExp _fieldRegExp = RegExp(r'^$');
  final RegExp _fieldRegExp = RegExp(r'^$');
  final RegExp _fieldRegExp = RegExp(r'^$');

  @override
  void initState() {
    super.initState();
    // _field.text = widget._field;
  }

  @override
  void dispose() {
    _field.dispose();
    _field.dispose();
    _field.dispose();
    _field.dispose();
    _field.dispose();
    _field.dispose();
    _field.dispose();
    _field.dispose();
    super.dispose();
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
                ///////////////////with form validator
                controller: _field,
                validator: (final value) => _fieldValidator(value),
                decoration: const InputDecoration(
                  label: Text('Field'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15.00),
              TextFormField(
                //////////////////without form validator
                controller: _field,
                decoration: const InputDecoration(
                  label: Text('Type'),
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

  String? _fieldValidator(final String? value) {
    if (value == null) {
      developer.log(
        'Field value is null: not allowed',
        name: '_AddState:_fieldValidator',
      );
      return 'Field cannot be null';
    }
    if (!_fieldRegExp.hasMatch(value)) {
      developer.log(
        'Field value does not follow the date format',
        name: '_AddState:_fieldValidator',
      );
      return 'Field format not followed';
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
    late final EntityModel? entityModel;
    try {
      entityModel = _buildEntity();
    } on Exception catch (e) {
      developer.log(
        'Exception building FinanceModel from given form data',
        name: '_AddState:_pressedAddButton',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error building model from form: $e')),
      );
      return;
    }
    if (entityModel == null) {
      developer.log(
        'Failed to build FinanceModel from given form data',
        name: '_AddState:_pressedAddButton',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error building model from form')),
      );
      return;
    }
    widget._addViewModel.add(entity);
    Navigator.of(context).pop();
  }

  EntityModel? _buildEntity() {
    final field = _field.text;
    final field = _field.text;
    final field = _field.text;
    final field = _field.text;
    final field = _field.text;
    final field = _field.text;
    final field = _field.text;
    final field = _field.text;

    final actualField = double.tryParse(field);
    if (realAmount == null) {
      return null;
    }

    return EntityModel(
      field: field,
      field: field,
      field: field,
      field: field,
      field: field,
      field: field,
      field: field,
      field: field,
    );
  }
}
