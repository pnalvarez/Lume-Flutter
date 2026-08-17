/// Typography styles for [lume_design_system].
///
/// Uses [GoogleFonts.inter] — matching the Lume web app (font-family: 'Inter').
/// Scale mirrors Auror exactly; replace [GoogleFonts.poppins] → [GoogleFonts.inter].
library;

import 'package:lume_design_system/atoms/typography/font_sizes.dart'
    as fontsizes;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Headlines (display / page titles) — weight 700 --------------------

final headlineXl = GoogleFonts.inter(
  fontSize: fontsizes.headlineXl,
  fontWeight: FontWeight.w700,
  height: 1.15,
  letterSpacing: -0.5,
);

final headlineL = GoogleFonts.inter(
  fontSize: fontsizes.headlineL,
  fontWeight: FontWeight.w700,
  height: 1.15,
  letterSpacing: -0.25,
);

final headlineM = GoogleFonts.inter(
  fontSize: fontsizes.headlineM,
  fontWeight: FontWeight.w700,
  height: 1.2,
);

final headlineS = GoogleFonts.inter(
  fontSize: fontsizes.headlineS,
  fontWeight: FontWeight.w700,
  height: 1.2,
);

final headlineXs = GoogleFonts.inter(
  fontSize: fontsizes.headlineXs,
  fontWeight: FontWeight.w700,
  height: 1.25,
);

final headline2xs = GoogleFonts.inter(
  fontSize: fontsizes.headline2xs,
  fontWeight: FontWeight.w700,
  height: 1.25,
);

// --- Subtitles (section headers, card titles) — weight 600 -------------

final subtitleXl = GoogleFonts.inter(
  fontSize: fontsizes.subtitleXl,
  fontWeight: FontWeight.w600,
  height: 1.2,
  letterSpacing: -0.25,
);

final subtitleL = GoogleFonts.inter(
  fontSize: fontsizes.subtitleL,
  fontWeight: FontWeight.w600,
  height: 1.2,
);

final subtitleM = GoogleFonts.inter(
  fontSize: fontsizes.subtitleM,
  fontWeight: FontWeight.w600,
  height: 1.25,
);

final subtitleS = GoogleFonts.inter(
  fontSize: fontsizes.subtitleS,
  fontWeight: FontWeight.w600,
  height: 1.25,
);

final subtitleXs = GoogleFonts.inter(
  fontSize: fontsizes.subtitleXs,
  fontWeight: FontWeight.w600,
  height: 1.3,
);

final subtitle2xs = GoogleFonts.inter(
  fontSize: fontsizes.subtitle2xs,
  fontWeight: FontWeight.w600,
  height: 1.3,
);

// --- H1–H6 (legacy / generic headings) ----------------------------------

final headingH1 = GoogleFonts.inter(
  fontSize: fontsizes.defaultXL2,
  fontWeight: FontWeight.w700,
  height: 1.15,
);

final headingH2 = GoogleFonts.inter(
  fontSize: fontsizes.defaultXL,
  fontWeight: FontWeight.w700,
  height: 1.15,
);

final headingH3 = GoogleFonts.inter(
  fontSize: fontsizes.defaultL,
  fontWeight: FontWeight.w700,
  height: 1.2,
);

final headingH4 = GoogleFonts.inter(
  fontSize: fontsizes.defaultM,
  fontWeight: FontWeight.w700,
  height: 1.2,
);

final headingH5 = GoogleFonts.inter(
  fontSize: fontsizes.defaultS,
  fontWeight: FontWeight.w700,
  height: 1.25,
);

final headingH6 = GoogleFonts.inter(
  fontSize: fontsizes.defaultXS,
  fontWeight: FontWeight.w700,
  height: 1.25,
);

// --- Body — Light (weight 400) ------------------------------------------

final body1Light = GoogleFonts.inter(
  fontSize: fontsizes.defaultS,
  fontWeight: FontWeight.w400,
  height: 1.4,
);

final body2Light = GoogleFonts.inter(
  fontSize: fontsizes.defaultXS,
  fontWeight: FontWeight.w400,
  height: 1.45,
);

final body3Light = GoogleFonts.inter(
  fontSize: fontsizes.defaultXS2,
  fontWeight: FontWeight.w400,
  height: 1.45,
);

final body4Light = GoogleFonts.inter(
  fontSize: fontsizes.defaultBody,
  fontWeight: FontWeight.w400,
  height: 1.45,
);

final body5Light = GoogleFonts.inter(
  fontSize: fontsizes.defaultSBody,
  fontWeight: FontWeight.w400,
  height: 1.45,
);

final body6Light = GoogleFonts.inter(
  fontSize: fontsizes.defaultTiny,
  fontWeight: FontWeight.w400,
  height: 1.4,
);

// --- Body — Medium (weight 500) -----------------------------------------

final body1Medium = GoogleFonts.inter(
  fontSize: fontsizes.defaultS,
  fontWeight: FontWeight.w500,
  height: 1.4,
);

final body2Medium = GoogleFonts.inter(
  fontSize: fontsizes.defaultXS,
  fontWeight: FontWeight.w500,
  height: 1.45,
);

final body3Medium = GoogleFonts.inter(
  fontSize: fontsizes.defaultXS2,
  fontWeight: FontWeight.w500,
  height: 1.45,
);

final body4Medium = GoogleFonts.inter(
  fontSize: fontsizes.defaultBody,
  fontWeight: FontWeight.w500,
  height: 1.45,
);

final body5Medium = GoogleFonts.inter(
  fontSize: fontsizes.defaultSBody,
  fontWeight: FontWeight.w500,
  height: 1.45,
);

// --- Body — Semibold (weight 600) ---------------------------------------

final body1Semibold = GoogleFonts.inter(
  fontSize: fontsizes.defaultS,
  fontWeight: FontWeight.w600,
  height: 1.4,
);

final body2Semibold = GoogleFonts.inter(
  fontSize: fontsizes.defaultXS,
  fontWeight: FontWeight.w600,
  height: 1.45,
);

final body3Semibold = GoogleFonts.inter(
  fontSize: fontsizes.defaultXS2,
  fontWeight: FontWeight.w600,
  height: 1.45,
);

final body4Semibold = GoogleFonts.inter(
  fontSize: fontsizes.defaultBody,
  fontWeight: FontWeight.w600,
  height: 1.45,
);

final body5Semibold = GoogleFonts.inter(
  fontSize: fontsizes.defaultSBody,
  fontWeight: FontWeight.w600,
  height: 1.45,
);

// --- Labels (chip text, form labels) ------------------------------------

final labelL = GoogleFonts.inter(
  fontSize: fontsizes.defaultS,
  fontWeight: FontWeight.w600,
  height: 1.2,
);

final labelM = GoogleFonts.inter(
  fontSize: fontsizes.defaultXS,
  fontWeight: FontWeight.w600,
  height: 1.2,
);

final labelS = GoogleFonts.inter(
  fontSize: fontsizes.defaultXS2,
  fontWeight: FontWeight.w600,
  height: 1.2,
);

// --- Tags (badges, pills) -----------------------------------------------

final tagRegular = GoogleFonts.inter(
  fontSize: fontsizes.defaultBody,
  fontWeight: FontWeight.w600,
  height: 1.2,
);

final tagS = GoogleFonts.inter(
  fontSize: fontsizes.defaultSBody,
  fontWeight: FontWeight.w600,
  height: 1.2,
);

final tagXS = GoogleFonts.inter(
  fontSize: fontsizes.defaultTiny,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
