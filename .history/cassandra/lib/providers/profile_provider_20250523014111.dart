import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  bool isProfile = false;
  bool isProfileModal = false;
  bool isProfileEdit = false;
  bool isProfileEditModal = false;
  bool isProfileEditSave = false;
  bool isProfileEditSaveModal = false;
  bool isProfileEditCancel = false;
  bool isProfileEditCancelModal = false;
  bool isProfileEditDelete = false;
  bool isProfileEditDeleteModal = false;
  bool isProfileEditDeleteConfirm = false;
  bool isProfileEditDeleteConfirmModal = false;
  bool isProfileEditDeleteCancel = false;
  bool isProfileEditDeleteCancelModal = false;
  bool isProfileEditDeleteSuccess = false;
  bool isProfileEditDeleteSuccessModal = false;
  bool isProfileEditDeleteFail = false;
  bool isProfileEditDeleteFailModal = false;
  bool isProfileEditDeleteError = false;
  bool isProfileEditDeleteErrorModal = false;
  bool isProfileEditDeleteNetwork = false;
  bool isProfileEditDeleteNetworkModal = false;
  bool isProfileEditDeleteServer = false;
  bool isProfileEditDeleteServerModal = false;
  bool isProfileEditDeleteDatabase = false;
  bool isProfileEditDeleteDatabaseModal = false;
  bool isProfileEditDeleteUnknown = false;
  bool isProfileEditDeleteUnknownModal = false;
  bool isProfileEditDeleteRetry = false;
  bool isProfileEditDeleteRetryModal = false;
  bool isProfileEditDeleteRetrySuccess = false;
  bool isProfileEditDeleteRetrySuccessModal = false;
  bool isProfileEditDeleteRetryFail = false;
  bool isProfileEditDeleteRetryFailModal = false;
  bool isProfileEditDeleteRetryError = false;
  bool isProfileEditDeleteRetryErrorModal = false;

  void toggleProfile() {
    isProfile = !isProfile;
    notifyListeners();
  }

  void closeProfile() {
    isProfile = false;
    notifyListeners();
  }

  void toggleProfileEdit() {
    isProfileEdit = !isProfileEdit;
    notifyListeners();
  }

  void toggleProfileEditModal() {
    isProfileEditModal = !isProfileEditModal;
    notifyListeners();
  }

  void toggleProfileEditSave() {
    isProfileEditSave = !isProfileEditSave;
    notifyListeners();
  }

  void toggleProfileEditSaveModal() {
    isProfileEditSaveModal = !isProfileEditSaveModal;
    notifyListeners();
  }

  void toggleProfileEditCancel() {
    isProfileEditCancel = !isProfileEditCancel;
    notifyListeners();
  }

  void toggleProfileEditCancelModal() {
    isProfileEditCancelModal = !isProfileEditCancelModal;
    notifyListeners();
  }

  void toggleProfileEditDelete() {
    isProfileEditDelete = !isProfileEditDelete;
    notifyListeners();
  }

  void toggleProfileEditDeleteModal() {
    isProfileEditDeleteModal = !isProfileEditDeleteModal;
    notifyListeners();
  }

  void toggleProfileEditDeleteConfirm() {
    isProfileEditDeleteConfirm = !isProfileEditDeleteConfirm;
    notifyListeners();
  }

  void toggleProfileEditDeleteConfirmModal() {
    isProfileEditDeleteConfirmModal = !isProfileEditDeleteConfirmModal;
    notifyListeners();
  }

  void toggleProfileEditDeleteCancel() {
    isProfileEditDeleteCancel = !isProfileEditDeleteCancel;
    notifyListeners();
  }

  void toggleProfileEditDeleteCancelModal() {
    isProfileEditDeleteCancelModal = !isProfileEditDeleteCancelModal;
    notifyListeners();
  }

  void toggleProfileEditDeleteSuccess() {
    isProfileEditDeleteSuccess = !isProfileEditDeleteSuccess;
    notifyListeners();
  }

  void toggleProfileEditDeleteSuccessModal() {
    isProfileEditDeleteSuccessModal = !isProfileEditDeleteSuccessModal;
    notifyListeners();
  }

  void toggleProfileEditDeleteFail() {
    isProfileEditDeleteFail = !isProfileEditDeleteFail;
    notifyListeners();
  }

  void toggleProfileEditDeleteFailModal() {
    isProfileEditDeleteFailModal = !isProfileEditDeleteFailModal;
    notifyListeners();
  }

  void toggleProfileEditDeleteError() {
    isProfileEditDeleteError = !isProfileEditDeleteError;
    notifyListeners();
  }

  void toggleProfileEditDeleteErrorModal() {
    isProfileEditDeleteErrorModal = !isProfileEditDeleteErrorModal;
    notifyListeners();
  }

  void toggleProfileEditDeleteNetwork() {
    isProfileEditDeleteNetwork = !isProfileEditDeleteNetwork;
    notifyListeners();
  }

  void toggleProfileEditDeleteNetworkModal() {
    isProfileEditDeleteNetworkModal = !isProfileEditDeleteNetworkModal;
    notifyListeners();
  }

  void toggleProfileEditDeleteServer() {
    isProfileEditDeleteServer = !isProfileEditDeleteServer;
    notifyListeners();
  }

  void toggleProfileEditDeleteServerModal() {
    isProfileEditDeleteServerModal = !isProfileEditDeleteServerModal;
    notifyListeners();
  }

  void toggleProfileEditDeleteDatabase() {
    isProfileEditDeleteDatabase = !isProfileEditDeleteDatabase;
    notifyListeners();
  }

  void toggleProfileEditDeleteDatabaseModal() {
    isProfileEditDeleteDatabaseModal = !isProfileEditDeleteDatabaseModal;
    notifyListeners();
  }

  void toggleProfileEditDeleteUnknown() {
    isProfileEditDeleteUnknown = !isProfileEditDeleteUnknown;
    notifyListeners();
  }

  void toggleProfileEditDeleteUnknownModal() {
    isProfileEditDeleteUnknownModal = !isProfileEditDeleteUnknownModal;
    notifyListeners();
  }

  void toggleProfileEditDeleteRetry() {
    isProfileEditDeleteRetry = !isProfileEditDeleteRetry;
    notifyListeners();
  }

  void toggleProfileEditDeleteRetryModal() {
    isProfileEditDeleteRetryModal = !isProfileEditDeleteRetryModal;
    notifyListeners();
  }

  void toggleProfileEditDeleteRetrySuccess() {
    isProfileEditDeleteRetrySuccess = !isProfileEditDeleteRetrySuccess;
    notifyListeners();
  }

  void toggleProfileEditDeleteRetrySuccessModal() {
    isProfileEditDeleteRetrySuccessModal = !isProfileEditDeleteRetrySuccessModal;
    notifyListeners();
  }

  void toggleProfileEditDeleteRetryFail() {
    isProfileEditDeleteRetryFail = !isProfileEditDeleteRetryFail;
    notifyListeners();
  }

  void toggleProfileEditDeleteRetryFailModal() {
    isProfileEditDeleteRetryFailModal = !isProfileEditDeleteRetryFailModal;
    notifyListeners();
  }

  void toggleProfileEditDeleteRetryError() {
    isProfileEditDeleteRetryError = !isProfileEditDeleteRetryError;
    notifyListeners();
  }

  void toggleProfileEditDeleteRetryErrorModal() {
    isProfileEditDeleteRetryErrorModal = !isProfileEditDeleteRetryErrorModal;
    notifyListeners();
  }
} 