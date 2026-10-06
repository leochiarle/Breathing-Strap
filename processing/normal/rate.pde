int lastBeatMs = 0;
float bpm = 0;
float prevEcg = 0;
int lastRespMs = 0;
float rpm = 0;
float prevResp = 0;

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

void calculateRpm(float resp) {
    if (prevResp < 650 && resp >= 650) {
        int now = millis();
        if (lastRespMs > 0) {
            rpm = 60000.0 / (now - lastRespMs);
        }
        lastRespMs = now;
    }
    prevResp = resp;
}
