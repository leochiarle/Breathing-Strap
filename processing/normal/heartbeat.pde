int lastBeatMs = 0;
float bpm = 0;
float prevEcg = 0;

void calculateBpm(float ecg) {
    if (prevEcg < 650 && ecg >= 650) {
        int now = millis();
        if (lastBeatMs > 0) {
            bpm = 60000.0 / (now - lastBeatMs);
        }
        lastBeatMs = now;
    }
    prevEcg = ecg;
}
