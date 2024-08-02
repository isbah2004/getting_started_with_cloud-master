import 'package:flutter/material.dart';
import 'package:getting_started_with_cloud/auth/app_provider.dart';
import 'package:getting_started_with_cloud/model/documentmodel.dart';
import 'package:provider/provider.dart';

class EditListItemDialog extends StatefulWidget {
  final ListItem item;
  final Function(ListItem) onSave;

  const EditListItemDialog({Key? key, required this.item, required this.onSave})
      : super(key: key);

  @override
  _EditListItemDialogState createState() => _EditListItemDialogState();
}

class _EditListItemDialogState extends State<EditListItemDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _subtitleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item.title);
    _subtitleController = TextEditingController(text: widget.item.subtitle);
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
      title: const Text('Edit item'),
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
            // Update the data on Appwrite
            final appProvider = Provider.of<AppProvider>(context, listen: false);
            appProvider.updateDocument(
              widget.item.id!,
              _titleController.text,
              _subtitleController.text,
            );

            // Save the edited data and close the dialog box
            final editedItem = ListItem(
              title: _titleController.text,
              subtitle: _subtitleController.text,
              id: widget.item.id!,
            );
            widget.onSave(editedItem);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}