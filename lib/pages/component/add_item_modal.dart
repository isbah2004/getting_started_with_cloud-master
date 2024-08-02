import 'package:flutter/material.dart';
import 'package:getting_started_with_cloud/auth/app_provider.dart';
import 'package:provider/provider.dart';

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({Key? key}) : super(key: key);

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;

  @override
  void initState() {
    _titleController = TextEditingController(text: "");
    _subtitleController = TextEditingController(text: "");
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'Enter the title',
            ),
          ),
          TextField(
            controller: _subtitleController,
            decoration: const InputDecoration(
              labelText: 'Subtitle',
              hintText: 'Enter the subtitle',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            //Create a new item on Appwrite
            AppProvider state =
                Provider.of<AppProvider>(context, listen: false);
            state.createDocument(
                _titleController.text, _subtitleController.text, context);
          },
          child: const Text('Add'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
