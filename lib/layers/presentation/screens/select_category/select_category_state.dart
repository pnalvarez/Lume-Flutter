import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/category/category_domain.dart';

enum SelectCategoryStatus { loading, ready, error }

enum SelectCategoryDestination { home, login }

@immutable
final class SelectCategoryState {
  const SelectCategoryState({
    this.status = SelectCategoryStatus.loading,
    this.categories = const [],
    this.selectedIds = const {},
    this.isSaving = false,
    this.errorMessage,
    this.notice,
    this.destination,
  });

  final SelectCategoryStatus status;
  final List<CategoryDomain> categories;
  final Set<int> selectedIds;
  final bool isSaving;
  final String? errorMessage;
  final String? notice;
  final SelectCategoryDestination? destination;

  bool get allSelected =>
      categories.isNotEmpty && selectedIds.length == categories.length;

  bool get canSubmit =>
      status == SelectCategoryStatus.ready &&
      !isSaving &&
      selectedIds.isNotEmpty;

  SelectCategoryState copyWith({
    SelectCategoryStatus? status,
    List<CategoryDomain>? categories,
    Set<int>? selectedIds,
    bool? isSaving,
    String? errorMessage,
    String? notice,
    SelectCategoryDestination? destination,
    bool clearError = false,
    bool clearNotice = false,
    bool clearDestination = false,
  }) {
    return SelectCategoryState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      selectedIds: selectedIds ?? this.selectedIds,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      notice: clearNotice ? null : notice ?? this.notice,
      destination: clearDestination ? null : destination ?? this.destination,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is SelectCategoryState &&
      other.status == status &&
      listEquals(other.categories, categories) &&
      setEquals(other.selectedIds, selectedIds) &&
      other.isSaving == isSaving &&
      other.errorMessage == errorMessage &&
      other.notice == notice &&
      other.destination == destination;

  @override
  int get hashCode => Object.hash(
    status,
    Object.hashAll(categories),
    Object.hashAll(selectedIds),
    isSaving,
    errorMessage,
    notice,
    destination,
  );
}
