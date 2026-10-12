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

    fill(255);
    stroke(0);
    rect(200, 150, 600, 300);
    fill(0);
    text("WORKOUT SUMMARY (press r to close)", 220, 175);
    for (int i = 0; i < 5; i++) {
        text(zoneNames[i] + ": " + zoneN[i] + " s", 220, 205 + i * 20);
    }
    if (total > 0) {
        text("Average HR: " + nf(hrTotal / total, 0, 0) + " bpm", 220, 330);
        text("Peak HR: " + nf(peakHr, 0, 0) + " bpm", 220, 350);
        text("Calories: " + nf(kcal, 0, 1) + " kcal (assumed " + int(WEIGHT_KG) + " kg, male)", 220, 370);
    }
}
