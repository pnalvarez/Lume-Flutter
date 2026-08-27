import 'package:flutter/foundation.dart';
import 'package:lume/layers/presentation/screens/select_category/select_category_state.dart';

@immutable
sealed class SelectCategoryEvent {
  const SelectCategoryEvent();
}

final class SelectCategoryStarted extends SelectCategoryEvent {
  const SelectCategoryStarted({this.entry = SelectCategoryEntry.onboarding});

  final SelectCategoryEntry entry;
}

final class SelectCategoryToggled extends SelectCategoryEvent {
  const SelectCategoryToggled(this.categoryId);

  final int categoryId;
}

final class SelectCategorySelectAllToggled extends SelectCategoryEvent {
  const SelectCategorySelectAllToggled();
}

final class SelectCategorySubmitted extends SelectCategoryEvent {
  const SelectCategorySubmitted();
}

final class SelectCategoryNavigationHandled extends SelectCategoryEvent {
  const SelectCategoryNavigationHandled();
}
