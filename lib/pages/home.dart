import 'package:flutter/material.dart';
import 'package:getting_started_with_cloud/auth/app_provider.dart';
import 'package:getting_started_with_cloud/model/documentmodel.dart';
import 'package:getting_started_with_cloud/pages/component/add_item_modal.dart';
import 'package:getting_started_with_cloud/pages/component/edit_item_modal.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    final state = Provider.of<AppProvider>(context, listen: false);
    state.listDocument();
  }

  @override
  Widget build(BuildContext context) => Consumer<AppProvider>(
        builder: (context, state, child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.lightBlueAccent,
                Color.fromARGB(255, 196, 66, 219),
                Colors.deepOrange
              ], begin: Alignment.topLeft, end: Alignment.bottomLeft),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                  child: state.isLoading
                      ? circularloader()
                      : appContainer(context, state)),
            ),
          );
        },
      );

  Widget circularloader() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

// if there is a session available, logged in container
  Widget appContainer(BuildContext context, state) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 50, right: 50, top: 50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: const Color.fromARGB(238, 238, 232, 198),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Handle the tap event by displaying a dialog box where the user can edit the data
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // Return the dialog widget
                      return const AddItemDialog();
                    },
                  );
                },
                icon: const Icon(
                  Icons.add,
                  size: 24.0,
                ),
                label: const Text("Add Item"),
              ),
            ),
            items(state)
          ],
        ));
  }

  Widget items(state) {
    return Expanded(
        child: Container(
            child: state.listItem.isEmpty
                ? const Center(
                    child: Text(
                      "No items found",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  )
                : listContainer(state)));
  }

  Widget listContainer(state) {
    return ListView.builder(
      itemCount: state.listItem.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            // Handle the tap event by displaying a dialog box where the user can edit the data
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // Return the dialog widget
                return EditListItemDialog(
                  item: state.listItem[index],
                  onSave: (ListItem editedItem) {
                    // Update the item in the list with the edited data
                    state.listItem[index] = editedItem;
                    // Rebuild the UI to reflect the updated data
                    setState(() {});
                  },
                );
              },
            );
          },
          child: ListTile(
            title: Text(state.listItem[index].title),
            subtitle: Text(state.listItem[index].subtitle),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () =>
                  state.removeReminder(state.listItem[index].id, index),
            ),
          ),
        );
      },
    );
  }
}
