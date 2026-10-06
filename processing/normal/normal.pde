boolean mock = true;

void setup() {
    size(1000, 600);
    if (!mock) setupSerial();
}

void draw() {
    if (mock) mockSamples();
    background(255);
    fill(0);
    text("ecg: " + ecg + " resp: " + resp, 20, 30);
    text("Heart rate: " + bpm, 20, 50);
    text("Respiration rate: " + rpm, 20, 70);

    drawGraph("ECG", ecg_history, 20, 100, width - 40, 200);
    drawGraph("Respiration", rr_history, 20, 350, width - 40, 200);
}
