int BASELINE_MS = 30000;
int baselineStartMs = 0;
boolean baselineDone = false;
float hrSum = 0, rrSum = 0;
int hrCount = 0, rrCount = 0;
float restingHr = 0, restingRr = 0;

void startBaseline() {
    baselineStartMs = millis();
    baselineDone = false;
    hrSum = rrSum = 0;
    hrCount = rrCount = 0;
}

void updateBaseline() {
    if (baselineDone) return;
    if (bpm > 0) { hrSum += bpm; hrCount++; }
    if (rpm > 0) { rrSum += rpm; rrCount++; }
    if (millis() - baselineStartMs >= BASELINE_MS) {
        restingHr = hrCount > 0 ? hrSum / hrCount : 0;
        restingRr = rrCount > 0 ? rrSum / rrCount : 0;
        baselineDone = true;
    }
}

String baselineText() {
    if (!baselineDone) {
        int left = ceil((BASELINE_MS - (millis() - baselineStartMs)) / 1000.0);
        return "Baseline: hold still, " + left + " s left";
    }
    return "Resting HR: " + nf(restingHr, 0, 1) + " bpm   Resting RR: " + nf(restingRr, 0, 1) + " /min";
}
