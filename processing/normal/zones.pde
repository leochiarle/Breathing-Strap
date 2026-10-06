String ageStr = "20";
int maxHr = 200;   // 220 - age
Queue<Float> hrHistory = new ArrayDeque<Float>();   // one HR reading per second
int lastZoneSampleMs = 0;
int HISTORY_LEN = 300;   // 5 minutes

// zone 0 = below 50% of max, then 50-60, 60-70, 70-80, 80-90, 90+
color[] zoneColors = {#9E9E9E, #4FC3F7, #66BB6A, #FFEE58, #FFA726, #EF5350};
String[] zoneNames = {"Resting", "Very light", "Light", "Moderate", "Hard", "Maximum"};

int zoneOf(float hr) {
    float pct = hr / maxHr * 100;
    if (pct < 50) return 0;
    if (pct < 60) return 1;
    if (pct < 70) return 2;
    if (pct < 80) return 3;
    if (pct < 90) return 4;
    return 5;
}

void updateAge() {
    int age = ageStr.length() > 0 ? int(ageStr) : 0;
    maxHr = max(220 - age, 1);
}

// call once per sample; stores HR once a second
void updateZones() {
    if (millis() - lastZoneSampleMs < 1000) return;
    lastZoneSampleMs = millis();
    hrHistory.add(bpm);
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
        float barH = min(hr / maxHr * h, h);   // bar height = HR as a fraction of max
        fill(zoneColors[zoneOf(hr)]);
        rect(x + i * 3, y + h - barH, 3, barH);   // each second is a 3 px wide bar
        i++;
    }
}
