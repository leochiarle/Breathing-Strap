void setup() {
    size(1000, 600);
}

void draw() {
    mockSamples();
    background(255);
    fill(0);
    text("ecg: " + ecg + " resp: " + resp, 20, 30);
    text("Heart rate: " + bpm, 20, 50);

    drawGraph("ECG", ecg_history, 20, 90, width - 40, 200);
    drawGraph("Respiration", rr_history, 20, 340, width - 40, 200);
}
