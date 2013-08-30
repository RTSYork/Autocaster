// Set current game to 'Rock Band 3' (RB) or 'Guitar Hero: Warriors of Rock' (GH)
#define RB 0
#define GH 1
#define GAME RB

// Enable (1) or disable (0) image filters
#define FILTERS 0

// Enable (1) or disable (0) tilt control
#define TILT 0


// ----------------------------------
// Generated options, based on above
#if (GAME == RB)
// Rock band
#define G_X 476+19+5+4+7+2
#define G_Y 581-45-15-15-1-15-5
#define R_X 559+8+2+3+2+1
#define R_Y 577-45-15-15-15-5
#define Y_X 640
#define Y_Y 575-45-15-15-15-5-1
#define B_X 721-8-2-3-2-1
#define B_Y 577-45-15-15-15-5
#define O_X 804-19-5-4-7-2
#define O_Y 581-45-15-15-1-15-5
#define DELAY 11
#define STRUM 1
#else
// Guitar Hero
#define G_X 487
#define G_Y 500
#define R_X 564
#define R_Y 500
#define Y_X 639
#define Y_Y 500
#define B_X 715
#define B_Y 500
#define O_X 791
#define O_Y 500
#define DELAY 5
#define STRUM 1
#endif
// ----------------------------------
