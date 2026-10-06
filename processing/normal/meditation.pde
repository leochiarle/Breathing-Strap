int badBreaths = 0;

void checkBreath() {
    if (!mode.equals("Meditation")) return;
    float target = exhaleMs / 3.0;
    if (abs(inhaleMs - target) <= target * 0.25) {
        badBreaths = 0;
    } else {
        badBreaths++;
    }
}

void drawMeditationIndicator(float x, float y) {
    if (mode.equals("Meditation") && badBreaths >= 3) {
        fill(255, 0, 0);
        rect(x, y, 280, 40);
        fill(255);
        text("Adjust breathing: inhale 1 : exhale 3", x + 10, y + 25);
    }
}
