
const int FSR_PIN = A0; // FSR and 10k pull-down connected to Analog Pin 0
int fsrReading;         // Stores the raw ADC value (0-1023)

void setup() {
  // initialize the serial communication:
  Serial.begin(115200);
  pinMode(10, INPUT); // Setup for leads off detection LO +
  pinMode(11, INPUT); // Setup for leads off detection LO -

}

void loop() {

  //----------------------------------------------------//
  if((digitalRead(10) == 1)||(digitalRead(11) == 1)){
    Serial.println('!');
  }
  else{
    // send the value of analog input 0:
      Serial.println(analogRead(A0));
  }

  //----------------------------------------------------//
  // Read the analog voltage from the divider circuit
  fsrReading = analogRead(FSR_PIN);  
  
  Serial.print("Analog Reading = ");
  Serial.println(fsrReading);     

  // Determine threshold categories based on resistance drop
  if (fsrReading < 10) {
    Serial.println("-> Status: No pressure");
  } else if (fsrReading < 200) {
    Serial.println("-> Status: Light touch");
  } else if (fsrReading < 500) {
    Serial.println("-> Status: Medium squeeze");
  } else if (fsrReading < 800) {
    Serial.println("-> Status: Heavy squeeze");
  } else {
    Serial.println("-> Status: Big Squeeze!");
  }
  //----------------------------------------------------//
  //Wait for a bit to keep serial data from saturating
  delay(2);
}
