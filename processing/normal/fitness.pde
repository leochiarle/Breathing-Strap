float[] zoneRrSum = new float[5];
float[] zoneInSum = new float[5];
float[] zoneExSum = new float[5];
int[] zoneCount = new int[5];

void resetZoneStats() {
    zoneRrSum = new float[5];
    zoneInSum = new float[5];
    zoneExSum = new float[5];
    zoneCount = new int[5];
}

void updateZoneStats() {
    if (!baselineDone || bpm <= 0 || rpm <= 0 || inhaleMs <= 0) return;
    int z = zoneOf(bpm);
    zoneRrSum[z] += rpm;
    zoneInSum[z] += inhaleMs;
    zoneExSum[z] += exhaleMs;
    zoneCount[z]++;
}

void drawZoneStats(float x, float y) {
    if (!mode.equals("Fitness")) return;
    fill(0);
    text("Zone: avg RR (change from rest), inhale, exhale", x, y);
    for (int z = 0; z < 5; z++) {
        String row = zoneNames[z] + ": ";
        if (zoneCount[z] == 0) {
            row += "-";
        } else {
            float rr = zoneRrSum[z] / zoneCount[z];
            row += nf(rr, 0, 1) + " (" + nf(rr - restingRr, 0, 1) + "), ";
            row += int(zoneInSum[z] / zoneCount[z]) + " ms, " + int(zoneExSum[z] / zoneCount[z]) + " ms";
        }
        text(row, x, y + 18 * (z + 1));
    }
}
