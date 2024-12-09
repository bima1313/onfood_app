Map<String, double> membershipFunction({
  required int numberPurchasesInput,
  required int totalSpendingInput,
}) {
  double numberPurchasesLow = 0;
  double numberPurchasesMedium = 0;
  double numberPurchasesHigh = 0;
  double totalSpendingLow = 0;
  double totalSpendingMedium = 0;
  double totalSpendingHigh = 0;

  // jumlah_pembelian //
  // low
  if (numberPurchasesInput <= 5) {
    numberPurchasesLow = 1; // x <= a
  } else if ((numberPurchasesInput > 5) & (numberPurchasesInput < 10)) {
    numberPurchasesLow = (10 - numberPurchasesInput) / 5; // (b-x)/(b-a)
  } else {
    numberPurchasesLow = 0; // x >= b
  }
  // middle
  if ((numberPurchasesInput <= 5) | (numberPurchasesInput >= 15)) {
    numberPurchasesMedium = 0; // x <= a | x >= c
  } else if ((numberPurchasesInput > 5) & (numberPurchasesInput < 10)) {
    numberPurchasesMedium = (numberPurchasesInput - 5) / 5; // (x-a)/(b-a)
  } else {
    numberPurchasesMedium = (15 - numberPurchasesInput) / 5; // (c-x)/(c-b)
  }
  // high
  if ((numberPurchasesInput <= 10)) {
    numberPurchasesHigh = 0; // x <= a
  } else if ((numberPurchasesInput > 10) & (numberPurchasesInput < 15)) {
    numberPurchasesHigh = (numberPurchasesInput - 10) / 5; // (x-a)/(b-a)
  } else {
    numberPurchasesHigh = 1; // x >= b
  }

  // total_belanja //
  // low
  if (totalSpendingInput <= 100000) {
    totalSpendingLow = 1; // x <= a
  } else if ((totalSpendingInput > 100000) & (totalSpendingInput < 200000)) {
    totalSpendingLow = (200000 - totalSpendingInput) / 100000; // (b-x)/(b-a)
  } else {
    totalSpendingLow = 0; // x >= b
  }
  // middle
  if ((totalSpendingInput <= 100000) | (totalSpendingInput >= 300000)) {
    totalSpendingMedium = 0; // x <= a | x >= c
  } else if ((totalSpendingInput > 100000) & (totalSpendingInput < 200000)) {
    totalSpendingMedium = (totalSpendingInput - 100000) / 100000; // (x-a)/(b-a)
  } else {
    totalSpendingMedium = (300000 - totalSpendingInput) / 100000; // (c-x)/(c-b)
  }
  // high
  if ((totalSpendingInput <= 200000)) {
    totalSpendingHigh = 0; // x <= a
  } else if ((totalSpendingInput > 200000) & (totalSpendingInput < 300000)) {
    totalSpendingHigh = (totalSpendingInput - 200000) / 100000; // (x-a)/(b-a)
  } else {
    totalSpendingHigh = 1; // x >= b
  }

  Map<String, double> membership = {
    'number_purchases_low': numberPurchasesLow,
    'number_purchases_medium': numberPurchasesMedium,
    'number_purchases_high': numberPurchasesHigh,
    'total_spending_low': totalSpendingLow,
    'total_spending_medium': totalSpendingMedium,
    'total_spending_high': totalSpendingHigh,
  };

  return membership;
}
