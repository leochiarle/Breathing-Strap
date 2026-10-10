void setup() {
    size(1000, 830);
    setupSerial();
    startBaseline();
    initChartHistory(ecg_history);
    initChartHistory(rr_history);
    initChartHistory(hr_history);
}

void keyPressed() {
    if (key == 'f') setMode("Fitness");
    if (key == 's') setMode("Stress");
    if (key == 'm') setMode("Meditation");
    if (key >= '0' && key <= '9' && ageStr.length() < 3) ageStr += key;
    if (key == BACKSPACE && ageStr.length() > 0) ageStr = ageStr.substring(0, ageStr.length() - 1); updateAge();
}

void draw() {
    background(255);
    fill(0);
    text("Mode: " + mode + " (f = fitness, s = stress, m = meditation)", 20, 14);
    text("Heart rate: " + bpm, 20, 34);
    text("Respiration rate: " + rpm, 20, 54);
    text("Inhale: " + inhaleMs + " ms   Exhale: " + exhaleMs + " ms", 20, 74);
    text(baselineText(), 20, 94);
    String zoneText = baselineDone ? zoneNames[zoneOf(bpm)] : "(after baseline)";
    text("Age: " + ageStr + " (type to change)   Max HR: " + maxHr + "   Zone: " + zoneText, 20, 114);
    
    float span = millis()/1000;
    
    drawGraph("ECG", ecg_history, 65, 150, width - 85, 200, 1023);
    drawAxes(60, 150, width - 80, 200, "Time (s)", "ECG", 0, span, 150, 1023);
    
    drawGraph("Respiration", rr_history, 65, 400, width - 85, 200, 400);
    drawAxes(60, 400, width - 80, 200, "Time (s)", "FSR", 0, span, 0, 400);
    
    drawZoneGraph("Cardio zone", hr_history, 65, 650, width - 85, 150);
    drawAxes(60, 650, width - 80, 150, "Time (s)", "Heart rate (bpm)", 0, span, 0, maxHr);

}

void onSample(float e, float r) {
    if (sampleCount++ == 0) firstSampleMs = millis();
    pushValue(ecg_history, e);
    pushValue(rr_history, r);
    calculateBpm(e);
    calculateRpm(r);
    calculateBreath(r);
    updateBaseline();
    updateZones();
}
