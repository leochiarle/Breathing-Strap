void setup() {
    size(1000, 400);
}

void draw() {
    mockSamples();
    background(255);
    fill(0);
    text("ecg: " + ecg + " resp: " + resp, 20, 30);

    drawGraph(ecg_history, 0, 0, width, 200);
    drawGraph(rr_history, 0, 200, width, 200);

    text("Heart rate: " + bpm, 20, 50);
}
