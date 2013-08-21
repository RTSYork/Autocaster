const int numPins = 23;
const int numButtons = 13;
const int ledPin = 13;
int whammyValue = 128;

/**
 * Pin Map
 **
 *  0 - Orange Fret
 *  1 - Blue Fret
 *  2 - Yellow Fret
 *  3 - Red Fret
 *  4 - Green Fret
 *  5 - Up
 *  6 - Select Button
 *  7 - Left
 *  8 - Start Button
 *  9 - Right
 * 10 - Down
 * 13 - LED (on board)
 * 14 - Whammy Bar 0 (LSB)
 * 15 - Whammy Bar 1
 * 16 - Whammy Bar 2
 * 17 - Whammy Bar 3
 * 18 - Whammy Bar 4
 * 19 - Whammy Bar 5
 * 20 - Whammy Bar 6
 * 21 - Whammy Bar 7 (MSB)
 **/

void setup() {
  
  // Set up pins
  for (int i = 0; i < numPins; i++) {
    if (i == ledPin)
      pinMode(i, OUTPUT);
    else
      pinMode(i, INPUT); // INPUT_PULLUP
  }
  
  // Initialise Guitar interface
  Guitar.useManualSend(true);
  Guitar.position(128, 128);
  Guitar.Zrotate(128);
  Guitar.whammy(whammyValue);
  Guitar.strum(false);
  for (int i = 1; i <= numButtons; i++) {
    Guitar.button(i, false);
  }
  
  Guitar.send_now();
  
  // Flash and light LED
  digitalWrite(ledPin, HIGH);
  delay(250);
  digitalWrite(ledPin, LOW);
  delay(250);
  digitalWrite(ledPin, HIGH);
  delay(250);
  digitalWrite(ledPin, LOW);
  delay(250);
  digitalWrite(ledPin, HIGH);
}


void loop() {
  
  // Fret buttons
  Guitar.fret(GREEN,  digitalRead(4));
  Guitar.fret(RED,    digitalRead(3));
  Guitar.fret(YELLOW, digitalRead(2));
  Guitar.fret(BLUE,   digitalRead(1));
  Guitar.fret(ORANGE, digitalRead(0));
  
  // Directional buttons (and strum)
  if (digitalRead(5))
    Guitar.hat(0);
  else if (digitalRead(9))
    Guitar.hat(90);
  else if (digitalRead(10))
    Guitar.hat(180);
  else if (digitalRead(7))
    Guitar.hat(270);
  else
    Guitar.strum(false);
  
  // Start and Select (Tilt) buttons
  Guitar.button(START,  digitalRead(8));
  Guitar.button(SELECT, digitalRead(6));
  
  // Whammy bar
  whammyValue = (!digitalRead(14) ? 0 : 1)        +
                (!digitalRead(15) ? 0 : (1 << 1)) +
                (!digitalRead(16) ? 0 : (1 << 2)) +
                (!digitalRead(17) ? 0 : (1 << 3)) +
                (!digitalRead(18) ? 0 : (1 << 4)) +
                (!digitalRead(19) ? 0 : (1 << 5)) +
                (!digitalRead(20) ? 0 : (1 << 6)) +
                (!digitalRead(21) ? 0 : (1 << 7));
                
  Guitar.whammy(whammyValue);
  
  
  // Send data
  Guitar.send_now();
  
  // Brief delay, so this runs ~200 times per second
  delay(5);
}
