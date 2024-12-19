import 'dart:math';

/// Fuzzy Logic Tsukamoto
int fuzzy({
  required double numberPurchasesLow,
  required double numberPurchasesMedium,
  required double numberPurchasesHigh,
  required double totalSpendingLow,
  required double totalSpendingMedium,
  required double totalSpendingHigh,
}) {
  int reward = 0;
  // rule 1 {no reward}
  double alfa1 = min(numberPurchasesLow, totalSpendingLow);
  double z1 = 6 - (alfa1 * 3); // (6-x)/3 = alfa //

  // rule 2
  double alfa2 = min(numberPurchasesLow, totalSpendingMedium);
  double za = 3 + (alfa2 * 3); // (x-3)/3 = alfa //
  double zb = 9 - (alfa2 * 3); // (9-x)/3 = alfa //
  double z2 = (za + zb) / 2; // reward diskon 5%

  // rule 3
  double alfa3 = min(numberPurchasesLow, totalSpendingHigh);
  za = 6 + (alfa3 * 3); // (x-6)/3 = alfa //
  zb = 12 - (alfa3 * 3); // (12-x)/3 = alfa //
  double z3 = (za + zb) / 2; // reward diskon 10%

  // rule 4
  double alfa4 = min(numberPurchasesMedium, totalSpendingLow);
  za = 3 + (alfa4 * 3); // (x-3)/3 = alfa //
  zb = 9 - (alfa4 * 3); // (9-x)/3 = alfa //
  double z4 = (za + zb) / 2; // reward diskon 5%

  // rule 5
  double alfa5 = min(numberPurchasesMedium, totalSpendingMedium);
  za = 6 + (alfa5 * 3); // (x-6)/3 = alfa //
  zb = 12 - (alfa5 * 3); // (12-x)/3 = alfa //
  double z5 = (za + zb) / 2; // reward diskon 10%

  // rule 6 {reward diskon 20%}
  double alfa6 = min(numberPurchasesMedium, totalSpendingHigh);
  double z6 = 9 + (alfa6 * 3); // (x-9)/3 = alfa //

  // rule 7
  double alfa7 = min(numberPurchasesHigh, totalSpendingLow);
  za = 6 + (alfa7 * 3); // (x-6)/3 = alfa //
  zb = 12 - (alfa7 * 3); // (12-x)/3 = alfa //
  double z7 = (za + zb) / 2; // reward diskon 10%

  // rule 8 {reward diskon 20%}
  double alfa8 = min(numberPurchasesHigh, totalSpendingMedium);
  double z8 = 9 + (alfa8 * 3); // (x-9)/3 = alfa //

  // rule 9 {reward diskon 20%}
  double alfa9 = min(numberPurchasesHigh, totalSpendingHigh);
  double z9 = 9 + (alfa9 * 3); // (x-9)/3 = alfa //

  // defuzzyfication
  double top = (alfa1 * z1) +
      (alfa2 * z2) +
      (alfa3 * z3) +
      (alfa4 * z4) +
      (alfa5 * z5) +
      (alfa6 * z6) +
      (alfa7 * z7) +
      (alfa8 * z8) +
      (alfa9 * z9);

  double bottom =
      alfa1 + alfa2 + alfa3 + alfa4 + alfa5 + alfa6 + alfa7 + alfa8 + alfa9;

  double z = top / bottom;
  double zRounded = z.roundToDouble(); // rounded a number. ex: 3.5 => 4.0

  if (zRounded <= 3) {
    return reward;
  } else if ((zRounded > 3) & (zRounded <= 6)) {
    double noReward = (6 - zRounded) / (6 - 3); // c-x/c-b
    double diskon5Percent = (zRounded - 3) / (6 - 3); // x-a/b-a
    double choice = max(noReward, diskon5Percent);

    if (choice == noReward) {
      return reward;
    } else {
      return reward = 5;
    }
  } else if ((zRounded > 6) & (zRounded <= 9)) {
    double diskon5Percent = (9 - zRounded) / (9 - 6); // c-x/c-b
    double diskon10Percent = (zRounded - 6) / (9 - 6); // x-a/b-a
    double choice = max(diskon5Percent, diskon10Percent);

    if (choice == diskon5Percent) {
      return reward = 5;
    } else {
      return reward = 10;
    }
  } else if ((zRounded > 9) & (zRounded <= 12)) {
    double diskon10Percent = (12 - zRounded) / (12 - 9); // c-x/x-b
    double diskon20Percent = (zRounded - 9) / (12 - 9); // x-a/b-a
    double choice = max(diskon10Percent, diskon20Percent);

    if (choice == diskon10Percent) {
      return reward = 10;
    } else {
      return reward = 20;
    }
  } else {
    return reward = 20;
  }
}
