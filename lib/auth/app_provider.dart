import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:getting_started_with_cloud/constants/app_constants.dart';
import 'package:getting_started_with_cloud/model/documentmodel.dart';

class AppProvider extends ChangeNotifier {
  Client client = Client();
  late Account account;
  late Databases databases;
  late bool _isLoading;
  List<ListItem>? _listItem;

  bool get isLoading => _isLoading;
  List<ListItem>? get listItem => _listItem;

  AppProvider() {
    _isLoading = true;
    initialize();
  }

  initialize() {
    client
      ..setEndpoint(AppConstants.endpoint)
      ..setProject(AppConstants.projectid);

    account = Account(client);
    databases = Databases(client);
    createAnon();
  }

  createAnon() async {
    try {
      await account.get();
    } catch (_) {
      await account.createAnonymousSession();
      _isLoading = false;
      notifyListeners();
    }
  }

  createDocument(String newTitle, String newSubtitle, context) async {
    try {
      final response = await databases.createDocument(
          databaseId: AppConstants.databaseID,
          collectionId: AppConstants.collectionID,
          documentId: ID.unique(),
          data: {'title': newTitle, 'subtitle': newSubtitle});
      if (response.data.isNotEmpty) {
        await listDocument();
        Navigator.pop(context);
      }
    } catch (e) {
      rethrow;
    }
  }

  listDocument() async {
    try {
      final response = await databases.listDocuments(
          databaseId: AppConstants.databaseID,
          collectionId: AppConstants.collectionID);
      _listItem = response.documents
          .map((listitem) => ListItem.fromJson(listitem.data))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  updateDocument(
      String documentId, String updateTitle, String updateSubtitle) async {
    try {
      await databases.updateDocument(
          databaseId: AppConstants.databaseID,
          collectionId: AppConstants.collectionID,
          documentId: documentId,
          data: {'title': updateTitle, 'subtitle': updateSubtitle});
    } catch (e) {
      rethrow;
    }
  }

  removeReminder(String documentID, int index) async {
    try {
      await databases.deleteDocument(
          databaseId: AppConstants.databaseID,
          collectionId: AppConstants.collectionID,
          documentId: documentID);
      _listItem!.removeAt(index);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}