
const int FSR_PIN = A0;
int fsrReading;

void setup() {
  Serial.begin(115200);
  pinMode(10, INPUT);
  pinMode(11, INPUT);

}

void loop() {
  if((digitalRead(10) == 1)||(digitalRead(11) == 1)){
    Serial.println('!');
  }
  else{
      Serial.println(analogRead(A0));
  }

  fsrReading = analogRead(FSR_PIN);

  Serial.print("Analog Reading = ");
  Serial.println(fsrReading);

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

  delay(2);
}
