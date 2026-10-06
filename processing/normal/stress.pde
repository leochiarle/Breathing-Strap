boolean isStressed() {
    boolean hrUp = restingHr > 0 && bpm > restingHr * 1.10;
    boolean rrUp = restingRr > 0 && rpm > restingRr * 1.10;
    return hrUp || rrUp;
}

void drawStressIndicator(float x, float y) {
    if (!mode.equals("Stress") || !baselineDone) return;
    if (isStressed()) {
        fill(255, 0, 0);
        rect(x, y, 280, 40);
        fill(255);
        text("STRESSED", x + 10, y + 25);
    } else {
        fill(0, 160, 0);
        rect(x, y, 280, 40);
        fill(255);
        text("CALM", x + 10, y + 25);
    }
}
