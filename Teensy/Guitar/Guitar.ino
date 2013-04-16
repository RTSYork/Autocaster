const int numPins = 23;
const int numButtons = 13;
const int ledPin = 13;
int whammyValue = 128;

/**
 * Pin Map
 **
 *  0 - Green Fret
 *  1 - Red Fret
 *  2 - Yellow Fret
 *  3 - Blue Fret
 *  4 - Orange Fret
 *  5 - Strum Bar
 *  6 - Up
 *  7 - Right
 *  8 - Down
 *  9 - Left
 * 10 - Start Button
 * 11 - Select Button
 * 12 - PS Button
 * 13 - LED (on board)
 * 14 - Tilt Sensor
 * 15 - Whammy Bar 0 (LSB)
 * 16 - Whammy Bar 1
 * 17 - Whammy Bar 2
 * 18 - Whammy Bar 3
 * 19 - Whammy Bar 4
 * 20 - Whammy Bar 5
 * 21 - Whammy Bar 6
 * 22 - Whammy Bar 7 (MSB)
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
  //Guitar.setExtras();
  Guitar.position(128, 128);
  Guitar.Zrotate(128);
  Guitar.whammy(whammyValue);
  Guitar.strum(false);
  for (int i = 1; i <= numButtons; i++) {
    Guitar.button(i, false);
  }
  
  Guitar.send_now();
  
  // Light LED
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
  
  Guitar.fret(GREEN,  digitalRead(0));
  Guitar.fret(RED,    digitalRead(1));
  Guitar.fret(YELLOW, digitalRead(2));
  Guitar.fret(BLUE,   digitalRead(3));
  Guitar.fret(ORANGE, digitalRead(4));
  
  if(digitalRead(5))
    Guitar.strum(true);
  else if (digitalRead(6))
    Guitar.hat(0);
  else if (digitalRead(7))
    Guitar.hat(90);
  else if (digitalRead(8))
    Guitar.hat(180);
  else if (digitalRead(9))
    Guitar.hat(270);
  else
    Guitar.strum(false);
  
  Guitar.button(START,  digitalRead(10));
  Guitar.button(SELECT, digitalRead(11));
  //Guitar.button(PS,     digitalRead(12));
  
  //Guitar.tilt(digitalRead(14));
  
  whammyValue = (!digitalRead(15) ? 0 : 1)        +
                (!digitalRead(16) ? 0 : (1 << 1)) +
                (!digitalRead(17) ? 0 : (1 << 2)) +
                (!digitalRead(18) ? 0 : (1 << 3)) +
                (!digitalRead(19) ? 0 : (1 << 4)) +
                (!digitalRead(20) ? 0 : (1 << 5)) +
                (!digitalRead(21) ? 0 : (1 << 6)) +
                (!digitalRead(22) ? 0 : (1 << 7));
  
  Guitar.whammy(whammyValue);
  
  
  // Send data
  Guitar.send_now();
  
  // a brief delay, so this runs "only" 200 times per second
  delay(5);
}

