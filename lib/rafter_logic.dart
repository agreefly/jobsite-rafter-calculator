import 'dart:math' as math;

class RafterCalculationResult {
  RafterCalculationResult({
    required this.decimalInches,
    required this.formattedLength,
    required this.actualRunInches,
    required this.actualRiseInches,
    required this.totalSpanInches,
    required this.theoreticalRunInches,
  });

  final double decimalInches;
  final String formattedLength;
  final double actualRunInches;
  final double actualRiseInches;
  final double totalSpanInches;
  final double theoreticalRunInches;
}

class RafterCutList {
  RafterCutList({
    required this.totalLengthInches,
    required this.formattedTotalLength,
    required this.overhangLengthInches,
    required this.formattedOverhangLength,
    required this.plumbCutInches,
    required this.formattedPlumbCut,
    required this.seatCutInches,
    required this.formattedSeatCut,
  });

  final double totalLengthInches;
  final String formattedTotalLength;
  final double overhangLengthInches;
  final String formattedOverhangLength;
  final double plumbCutInches;
  final String formattedPlumbCut;
  final double seatCutInches;
  final String formattedSeatCut;
}

class RoofPitchSummary {
  RoofPitchSummary({
    required this.pitchIn12,
    required this.riseOverRun,
    required this.angleDegrees,
  });

  final double pitchIn12;
  final String riseOverRun;
  final double angleDegrees;
}

class MaterialQuantity {
  MaterialQuantity({
    required this.raftersNeeded,
    required this.wasteAdjustedRafters,
    required this.estimatedBoardFeet,
    required this.sheathingSheets,
  });

  final int raftersNeeded;
  final int wasteAdjustedRafters;
  final double estimatedBoardFeet;
  final int sheathingSheets;
}

RafterCalculationResult calculateRafter(
  double spanFeet,
  double pitch,
  double ridgeThicknessInches,
) {
  if (spanFeet <= 0.0 || pitch < 0.0 || ridgeThicknessInches < 0.0) {
    return RafterCalculationResult(
      decimalInches: 0.0,
      formattedLength: 'Invalid input',
      actualRunInches: 0.0,
      actualRiseInches: 0.0,
      totalSpanInches: 0.0,
      theoreticalRunInches: 0.0,
    );
  }

  final totalSpanInches = spanFeet * 12.0;
  final theoreticalRunInches = totalSpanInches / 2.0;
  final actualRunInches = theoreticalRunInches - (ridgeThicknessInches / 2.0);

  final actualRiseInches = (pitch / 12.0) * actualRunInches;
  final decimalInches = math.sqrt(
    (actualRunInches * actualRunInches) + (actualRiseInches * actualRiseInches),
  );

  return RafterCalculationResult(
    decimalInches: decimalInches,
    formattedLength: formatInches(decimalInches),
    actualRunInches: actualRunInches,
    actualRiseInches: actualRiseInches,
    totalSpanInches: totalSpanInches,
    theoreticalRunInches: theoreticalRunInches,
  );
}

RafterCutList calculateCutList({
  required double spanFeet,
  required double pitch,
  required double ridgeThicknessInches,
  required double overhangFeet,
}) {
  final result = calculateRafter(spanFeet, pitch, ridgeThicknessInches);

  final overhangRunInches = overhangFeet * 12.0;
  final overhangRiseInches = (pitch / 12.0) * overhangRunInches;
  final overhangLengthInches = math.sqrt(
    (overhangRunInches * overhangRunInches) + (overhangRiseInches * overhangRiseInches),
  );

  final totalLengthInches = result.decimalInches + overhangLengthInches;

  return RafterCutList(
    totalLengthInches: totalLengthInches,
    formattedTotalLength: formatInches(totalLengthInches),
    overhangLengthInches: overhangLengthInches,
    formattedOverhangLength: formatInches(overhangLengthInches),
    plumbCutInches: 1.5,
    formattedPlumbCut: formatInches(1.5),
    seatCutInches: 1.5,
    formattedSeatCut: formatInches(1.5),
  );
}

RoofPitchSummary summarizePitch(double pitch) {
  return RoofPitchSummary(
    pitchIn12: pitch,
    riseOverRun: '${pitch.toStringAsFixed(0)}/12',
    angleDegrees: math.atan(pitch / 12.0) * 180.0 / math.pi,
  );
}

MaterialQuantity estimateMaterialQuantity({
  required double wallLengthFeet,
  required double rafterSpacingInches,
  required double rafterLengthFeet,
  required double spanFeet,
  int wastePercent = 10,
}) {
  if (wallLengthFeet <= 0.0 || rafterSpacingInches <= 0.0 || rafterLengthFeet <= 0.0 || spanFeet <= 0.0) {
    return MaterialQuantity(
      raftersNeeded: 0,
      wasteAdjustedRafters: 0,
      estimatedBoardFeet: 0.0,
      sheathingSheets: 0,
    );
  }

  final raftersNeeded = math.max(
    2,
    ((wallLengthFeet * 12.0) / rafterSpacingInches).ceil(),
  );

  final wasteAdjustedRafters = (raftersNeeded * (1 + (wastePercent / 100.0))).ceil();
  final boardFeetPerRafter = rafterLengthFeet * 10.0;
  final estimatedBoardFeet = wasteAdjustedRafters * boardFeetPerRafter;
  final roofAreaSquareFeet = spanFeet * rafterLengthFeet;
  final sheathingSheets = (roofAreaSquareFeet / 32.0).ceil();

  return MaterialQuantity(
    raftersNeeded: raftersNeeded,
    wasteAdjustedRafters: wasteAdjustedRafters,
    estimatedBoardFeet: estimatedBoardFeet,
    sheathingSheets: sheathingSheets,
  );
}

String formatInches(double decimalInches) {
  if (decimalInches.isNaN || decimalInches.isInfinite || decimalInches <= 0.0) {
    return 'Invalid input';
  }

  var wholeInches = decimalInches.truncate();
  var fractionalPart = decimalInches - wholeInches;
  var sixteenths = (fractionalPart * 16).round();

  if (sixteenths == 16) {
    wholeInches += 1;
    sixteenths = 0;
  }

  if (sixteenths == 0) {
    return '$wholeInches"';
  }

  var numerator = sixteenths;
  var denominator = 16;
  final gcd = math.gcd(numerator, denominator);
  numerator ~/= gcd;
  denominator ~/= gcd;

  if (wholeInches == 0) {
    return '$numerator/$denominator"';
  }

  return '$wholeInches $numerator/$denominator"';
}
