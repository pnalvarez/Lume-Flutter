import 'package:flutter/foundation.dart';

@immutable
sealed class SelectCategoryEvent {
  const SelectCategoryEvent();
}

final class SelectCategoryStarted extends SelectCategoryEvent {
  const SelectCategoryStarted();
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
