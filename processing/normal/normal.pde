boolean mock = true;

void setup() {
    size(1000, 830);
    if (!mock) setupSerial();
    startBaseline();
}

void keyPressed() {
    if (key == 'b') startBaseline();
    if (key >= '0' && key <= '9' && ageStr.length() < 3) ageStr += key;
    if (key == BACKSPACE && ageStr.length() > 0) ageStr = ageStr.substring(0, ageStr.length() - 1);
    updateAge();
}

void draw() {
    if (mock) mockSamples();
    background(255);
    fill(0);
    text("ecg: " + ecg + " resp: " + resp, 20, 30);
    text("Heart rate: " + bpm, 20, 50);
    text("Respiration rate: " + rpm, 20, 70);
    text("Inhale: " + inhaleMs + " ms   Exhale: " + exhaleMs + " ms", 20, 90);
    text(baselineText(), 20, 110);
    String zoneText = baselineDone ? zoneNames[zoneOf(bpm)] : "(after baseline)";
    text("Age: " + ageStr + " (type to change)   Max HR: " + maxHr + "   Zone: " + zoneText, 20, 130);

    drawGraph("ECG", ecg_history, 20, 150, width - 40, 200);
    drawGraph("Respiration", rr_history, 20, 400, width - 40, 200);
    drawZoneGraph("Cardio zone (HR per second)", 20, 650, width - 40, 150);
}
