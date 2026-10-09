String ageStr = "20";
int maxHr = 200;
Float[] hr_history = new Float[BUFFER_SIZE];
int lastZoneSampleMs = 0;

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

void pushZoneValue(Float[] q, float value) {
    for (int i = 0; i < BUFFER_SIZE - 1; i++) {
      q[i] = q[i + 1];
    }
    q[BUFFER_SIZE - 1] = value;
}

void updateZones() {
    //println("update zone: " + bpm);
    //println("lastZoneSampleMs: " + lastZoneSampleMs);
    //println("millis(): " + millis());
    if (millis() - lastZoneSampleMs < 1000) return;
    lastZoneSampleMs = millis();
    pushZoneValue(hr_history, bpm);
}

void drawZoneGraph(String title, Float[] data, float x, float y, float w, float h) {
    fill(0);
    text(title, x, y - 8);
    noFill();
    stroke(0);
    rect(x, y, w, h);

    noStroke();
    float barW = w / data.length;
    for (int i = 0; i < data.length; i++) {
        float hr = data[i];
        float barH = min(hr / maxHr * h, h);
        fill(zoneColors[zoneOf(hr)]);
        rect(x + i * barW, y + h - barH, barW, barH);
    }
}
