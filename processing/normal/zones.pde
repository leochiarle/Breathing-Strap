String ageStr = "20";
int maxHr = 200;
Queue<Float> hrHistory = new ArrayDeque<Float>();
int lastZoneSampleMs = 0;
int HISTORY_LEN = 300;

color[] zoneColors = {#4FC3F7, #66BB6A, #FFEE58, #FFA726, #EF5350};
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

void updateZones() {
    if (millis() - lastZoneSampleMs < 1000) return;
    lastZoneSampleMs = millis();
    hrHistory.add(bpm);
    updateZoneStats();
    if (hrHistory.size() > HISTORY_LEN) hrHistory.poll();
}

void drawZoneGraph(String title, float x, float y, float w, float h) {
    fill(0);
    text(title, x, y - 8);
    noFill();
    stroke(0);
    rect(x, y, w, h);

    noStroke();
    int i = 0;
    for (float hr : hrHistory) {
        float barH = min(hr / maxHr * h, h);
        fill(zoneColors[zoneOf(hr)]);
        rect(x + i * 3, y + h - barH, 3, barH);
        i++;
    }
}
