/// Type scale for [lume_design_system] (aligned with Auror's numeric steps).
///
/// Inter is used throughout, matching the web app's `tailwind.config.ts`.
library;

// --- Numeric helpers (Auror-compatible names) ---------------------------

const double defaultTiny  = 10;
const double defaultSBody = 12;
const double defaultBody  = 14;
const double defaultXS2   = 18;
const double defaultXS    = 20;
const double defaultS     = 24;
const double defaultM     = 28;
const double defaultL     = 32;
const double defaultXL    = 40;
const double defaultXL2   = 48;

// --- Label helpers ------------------------------------------------------

const double labelXS = 12;
const double labelS  = 14;
const double labelM  = 16;
const double labelL  = 18;

// --- Semantic headline steps (XL → 2XS) ---------------------------------

const double headlineXl  = defaultXL2;
const double headlineL   = defaultXL;
const double headlineM   = defaultL;
const double headlineS   = defaultM;
const double headlineXs  = defaultS;
const double headline2xs = defaultXS;

// --- Semantic subtitle steps (mirror headline) --------------------------

const double subtitleXl  = headlineXl;
const double subtitleL   = headlineL;
const double subtitleM   = headlineM;
const double subtitleS   = headlineS;
const double subtitleXs  = headlineXs;
const double subtitle2xs = headline2xs;
