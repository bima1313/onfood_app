import 'package:onfood/utilities/fuzzy/fuzzy_logic.dart';
import 'package:onfood/utilities/fuzzy/membership_function.dart';

// a reward systems using a fuzzy logic
int rewardSystems({
  required int numberPurchasesInput,
  required int totalSpendingInput,
}) {
  Map<String, double> membership = membershipFunction(
    numberPurchasesInput: numberPurchasesInput,
    totalSpendingInput: totalSpendingInput,
  );

  int result = fuzzy(
    numberPurchasesLow: membership['number_purchases_low']!,
    numberPurchasesMedium: membership['number_purchases_medium']!,
    numberPurchasesHigh: membership['number_purchases_high']!,
    totalSpendingLow: membership['total_spending_low']!,
    totalSpendingMedium: membership['total_spending_medium']!,
    totalSpendingHigh: membership['total_spending_high']!,
  );

  return result;
}
