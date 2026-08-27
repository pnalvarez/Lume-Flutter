import 'package:flutter/foundation.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/layers/domain/models/category/category_domain.dart';

/// How the select-category screen was opened.
enum SelectCategoryEntry { onboarding, profile }

enum SelectCategoryStatus { loading, ready, error }

enum SelectCategoryDestination { home, login, pop }

@immutable
final class SelectCategoryState {
  const SelectCategoryState({
    this.entry = SelectCategoryEntry.onboarding,
    this.status = SelectCategoryStatus.loading,
    this.categories = const [],
    this.selectedIds = const {},
    this.initialSelectedIds = const {},
    this.isSaving = false,
    this.errorMessage,
    this.notice,
    this.destination,
  });

  final SelectCategoryEntry entry;
  final SelectCategoryStatus status;
  final List<CategoryDomain> categories;
  final Set<int> selectedIds;

  /// Selection loaded from the server; used to detect unsaved edits.
  final Set<int> initialSelectedIds;
  final bool isSaving;
  final String? errorMessage;
  final String? notice;
  final SelectCategoryDestination? destination;

  bool get isProfileEntry => entry == SelectCategoryEntry.profile;

  bool get allSelected =>
      categories.isNotEmpty && selectedIds.length == categories.length;

  bool get hasChanges => !setEquals(selectedIds, initialSelectedIds);

  bool get canSubmit =>
      status == SelectCategoryStatus.ready &&
      !isSaving &&
      selectedIds.isNotEmpty &&
      hasChanges;

  String get ctaLabel =>
      isProfileEntry ? selectCategorySaveCta : selectCategoryCta;

  SelectCategoryState copyWith({
    SelectCategoryEntry? entry,
    SelectCategoryStatus? status,
    List<CategoryDomain>? categories,
    Set<int>? selectedIds,
    Set<int>? initialSelectedIds,
    bool? isSaving,
    String? errorMessage,
    String? notice,
    SelectCategoryDestination? destination,
    bool clearError = false,
    bool clearNotice = false,
    bool clearDestination = false,
  }) {
    return SelectCategoryState(
      entry: entry ?? this.entry,
      status: status ?? this.status,
      categories: categories ?? this.categories,
      selectedIds: selectedIds ?? this.selectedIds,
      initialSelectedIds: initialSelectedIds ?? this.initialSelectedIds,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      notice: clearNotice ? null : notice ?? this.notice,
      destination: clearDestination ? null : destination ?? this.destination,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is SelectCategoryState &&
      other.entry == entry &&
      other.status == status &&
      listEquals(other.categories, categories) &&
      setEquals(other.selectedIds, selectedIds) &&
      setEquals(other.initialSelectedIds, initialSelectedIds) &&
      other.isSaving == isSaving &&
      other.errorMessage == errorMessage &&
      other.notice == notice &&
      other.destination == destination;

  @override
  int get hashCode => Object.hash(
    entry,
    status,
    Object.hashAll(categories),
    Object.hashAll(selectedIds),
    Object.hashAll(initialSelectedIds),
    isSaving,
    errorMessage,
    notice,
    destination,
  );
}
