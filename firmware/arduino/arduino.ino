

const int ECG_PIN = A0;
const int FSR_PIN = A1;

void setup() {
  Serial.begin(115200);
  pinMode(10, INPUT); // Setup for leads off detection LO +
  pinMode(11, INPUT); // Setup for leads off detection LO -

}

void loop() {

  //----------------------------------------------------//
  if((digitalRead(10) == 1)||(digitalRead(11) == 1)){
    Serial.print('!');
  }
  else{
    // send the value of analog input 0:
      Serial.print(analogRead(ECG_PIN));
  }

  
  Serial.print(", ");
  
  
  //----------------------------------------------------//
  // Read the analog voltage from the divider circuit
  
  Serial.print(analogRead(FSR_PIN));     
/*
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
  */
  Serial.println();  
  //Wait for a bit to keep serial data from saturating
  delay(5);
}
