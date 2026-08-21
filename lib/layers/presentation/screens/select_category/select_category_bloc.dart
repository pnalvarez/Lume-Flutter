import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/core/errors/api_exception.dart';
import 'package:lume/layers/domain/usecases/get_categories_with_preferences.dart';
import 'package:lume/layers/domain/usecases/save_category_preferences.dart';
import 'package:lume/layers/presentation/screens/select_category/select_category_event.dart';
import 'package:lume/layers/presentation/screens/select_category/select_category_state.dart';

@injectable
final class SelectCategoryBloc
    extends Bloc<SelectCategoryEvent, SelectCategoryState> {
  SelectCategoryBloc(
    this._getCategoriesWithPreferences,
    this._saveCategoryPreferences,
  ) : super(const SelectCategoryState()) {
    on<SelectCategoryStarted>(_onStarted);
    on<SelectCategoryToggled>(_onToggled);
    on<SelectCategorySelectAllToggled>(_onSelectAllToggled);
    on<SelectCategorySubmitted>(_onSubmitted);
    on<SelectCategoryNavigationHandled>(_onNavigationHandled);
  }

  final IGetCategoriesWithPreferences _getCategoriesWithPreferences;
  final ISaveCategoryPreferences _saveCategoryPreferences;

  Future<void> _onStarted(
    SelectCategoryStarted event,
    Emitter<SelectCategoryState> emit,
  ) async {
    emit(
      state.copyWith(status: SelectCategoryStatus.loading, clearError: true),
    );
    try {
      final preferences = await _getCategoriesWithPreferences(
        forceRefresh: true,
      );
      emit(
        state.copyWith(
          status: SelectCategoryStatus.ready,
          categories: preferences.categories,
          selectedIds: preferences.selectedIds.toSet(),
        ),
      );
    } on Object {
      emit(
        state.copyWith(
          status: SelectCategoryStatus.error,
          errorMessage: selectCategoryLoadError,
        ),
      );
    }
  }

  void _onToggled(
    SelectCategoryToggled event,
    Emitter<SelectCategoryState> emit,
  ) {
    final next = Set<int>.from(state.selectedIds);
    if (next.contains(event.categoryId)) {
      next.remove(event.categoryId);
    } else {
      next.add(event.categoryId);
    }
    emit(state.copyWith(selectedIds: next, clearError: true));
  }

  void _onSelectAllToggled(
    SelectCategorySelectAllToggled event,
    Emitter<SelectCategoryState> emit,
  ) {
    if (state.allSelected) {
      emit(state.copyWith(selectedIds: {}, clearError: true));
      return;
    }
    emit(
      state.copyWith(
        selectedIds: {for (final category in state.categories) category.id},
        clearError: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    SelectCategorySubmitted event,
    Emitter<SelectCategoryState> emit,
  ) async {
    if (!state.canSubmit) return;
    emit(state.copyWith(isSaving: true, clearError: true));
    try {
      await _saveCategoryPreferences(
        categoryIds: state.selectedIds.toList(growable: false),
      );
      emit(
        state.copyWith(
          isSaving: false,
          destination: SelectCategoryDestination.home,
        ),
      );
    } on ApiHttpException catch (error) {
      if (error.statusCode == 401 || error.statusCode == 403) {
        emit(
          state.copyWith(
            isSaving: false,
            notice: selectCategorySessionExpired,
            destination: SelectCategoryDestination.login,
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          isSaving: false,
          errorMessage: error.message?.trim().isNotEmpty == true
              ? error.message
              : selectCategorySaveError,
        ),
      );
    } on Object catch (error) {
      final message = error is ApiException ? error.message : null;
      emit(
        state.copyWith(
          isSaving: false,
          errorMessage: message != null && message.trim().isNotEmpty
              ? message
              : selectCategorySaveError,
        ),
      );
    }
  }

  void _onNavigationHandled(
    SelectCategoryNavigationHandled event,
    Emitter<SelectCategoryState> emit,
  ) {
    emit(state.copyWith(clearDestination: true, clearNotice: true));
  }
}
