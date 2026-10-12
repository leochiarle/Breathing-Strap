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
