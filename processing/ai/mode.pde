String mode = "Fitness";
int badBreaths = 0;   // consecutive breaths that missed the 1:3 target

void setMode(String newMode) {
    mode = newMode;
    startBaseline();
    resetZoneStats();
    badBreaths = 0;
}

// Stress: compare current values to the resting baseline
String stressState() {
    if (!baselineDone || bpm == 0) return "Waiting...";
    boolean hrUp = bpm > restingHr * 1.10;   // 10% above resting
    boolean rrUp = rpm > restingRr * 1.15;   // 15% above resting
    if (hrUp && rrUp) return "Stressed";
    if (!hrUp && !rrUp) return "Calm";
    return "Elevated";
}

// Meditation: called once per completed breath
void onBreathDone() {
    if (!mode.equals("Meditation") || !baselineDone) return;
    if (inhaleMs * 2 <= exhaleMs) badBreaths = 0;   // inhale at most half the exhale: OK
    else badBreaths++;
}

boolean showSummary = false;

void drawSummary() {
    int total = 0;
    for (int i = 0; i < 5; i++) total += zoneN[i];

    noStroke();
    fill(4, 6, 12, 190);
    rect(0, 0, width, height);

    float x = 340, y = 180, w = 600, h = 420;
    card(x, y, w, h);
    fill(18, 24, 42, 240);
    stroke(255, 255, 255, 40);
    rect(x, y, w, h, 18);
    label("WORKOUT SUMMARY", x + 30, y + 46, 18, C_TEXT, LEFT, true);
    label("press R to close", x + w - 30, y + 46, 11, C_DIM, RIGHT, false);

    int mx = 1;
    for (int i = 0; i < 5; i++) mx = max(mx, zoneN[i]);
    for (int i = 0; i < 5; i++) {
        float ry = y + 82 + i * 38;
        label(zoneNames[i], x + 30, ry + 14, 13, C_TEXT, LEFT, true);
        bar(x + 150, ry + 4, w - 290, 10, zoneN[i] / (float) mx, zoneColors[i]);
        label(zoneN[i] + " s", x + w - 30, ry + 14, 13, C_TEXT, RIGHT, true);
    }
    if (total > 0) {
        float sy = y + 308;
        label("AVG HR", x + 30, sy, 10, C_DIM, LEFT, false);
        label(nf(hrTotal / total, 0, 0) + " bpm", x + 30, sy + 34, 26, C_TEXT, LEFT, true);
        label("PEAK HR", x + 230, sy, 10, C_DIM, LEFT, false);
        label(nf(peakHr, 0, 0) + " bpm", x + 230, sy + 34, 26, C_TEXT, LEFT, true);
        label("CALORIES", x + 420, sy, 10, C_DIM, LEFT, false);
        label(nf(kcal, 0, 1) + " kcal", x + 420, sy + 34, 26, C_TEXT, LEFT, true);
        label("assumed " + int(WEIGHT_KG) + " kg, male", x + 420, sy + 54, 10, C_DIM, LEFT, false);
    }
}
