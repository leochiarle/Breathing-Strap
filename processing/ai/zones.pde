String ageStr = "20";
int maxHr = 200;
Float[] hr_history = new Float[BUFFER_SIZE];
int lastZoneSampleMs = 0;

color[] zoneColors = {#64748B, #38BDF8, #34D399, #FBBF24, #F43F5E};
String[] zoneNames = {"Very light", "Light", "Moderate", "Hard", "Maximum"};

int zoneOf(float hr) {
    float pct = hr / maxHr * 100;
    if (pct < 60) return 0;
    if (pct < 70) return 1;
    if (pct < 80) return 2;
    if (pct < 90) return 3;
    return 4;
}

void updateAge() {
    int age = ageStr.length() > 0 ? int(ageStr) : 0;
    maxHr = max(220 - age, 1);
}

void pushZoneValue(Float[] q, float value) {
    for (int i = 0; i < BUFFER_SIZE - 1; i++) {
      q[i] = q[i + 1];
    }
    q[BUFFER_SIZE - 1] = value;
}

void drawZoneGraph(String title, Float[] data, float x, float y, float w, float h) {
    card(x, y, w, h);
    label(title.toUpperCase(), x + 22, y + 28, 11, C_DIM, LEFT, false);
    float px0 = plotX(x), py0 = plotY(y), pw = plotW(w), ph = plotH(h);

    // zone legend
    float lx = x + w - 22;
    for (int i = 4; i >= 0; i--) {
        label(zoneNames[i], lx, y + 28, 10, C_DIM, RIGHT, false);
        lx -= textWidth(zoneNames[i]) + 10;
        noStroke();
        fill(zoneColors[i]);
        ellipse(lx, y + 25, 7, 7);
        lx -= 16;
    }

    noStroke();
    float barW = pw / data.length;
    for (int i = 0; i < data.length; i++) {
        float hr = data[i];
        float barH = min(hr / maxHr * ph, ph);
        color zc = zoneColors[zoneOf(hr)];
        fill(red(zc), green(zc), blue(zc), 220);
        rect(px0 + i * barW, py0 + ph - barH, barW + 0.5, barH);
    }
}

int[] zoneN = new int[5];         // seconds spent in each zone
float[] zoneInh = new float[5];   // total inhale time (ms) in each zone
float[] zoneExh = new float[5];   // total exhale time (ms) in each zone
float[] zoneRr = new float[5];    // last respiratory rate seen in each zone
/*
void resetZoneStats() {
    for (int i = 0; i < 5; i++) {
        zoneN[i] = 0;
        zoneInh[i] = zoneExh[i] = zoneRr[i] = 0;
    }
}
*/
void updateZones() {
    if (millis() - lastZoneSampleMs < 1000) return;
    lastZoneSampleMs = millis();
    pushZoneValue(hr_history, bpm);
    if (baselineDone && bpm > 0) {
        zoneN[zoneOf(bpm)]++;
        hrTotal += bpm;
        peakHr = max(peakHr, bpm);
    
        int age = 220 - maxHr;   // age comes from the typed age
        float perMin = (-55.0969 + 0.6309 * bpm + 0.1988 * WEIGHT_KG + 0.2017 * age) / 4.184;
        kcal += max(perMin, 0) / 60;   // this second's share of the per-minute value
    }
}

float hrTotal = 0;       // sum of heart rate readings (one per second)
float peakHr = 0;        // highest heart rate seen
float kcal = 0;          // estimated calories burned
float WEIGHT_KG = 70;    // assumed weight, change it to yours

void resetZoneStats() {
    for (int i = 0; i < 5; i++) {
        zoneN[i] = 0;
        zoneInh[i] = zoneExh[i] = zoneRr[i] = 0;
    }
    hrTotal = peakHr = kcal = 0;
}
