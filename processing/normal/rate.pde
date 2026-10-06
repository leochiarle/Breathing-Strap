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

int lastRespMs = 0;
float rpm = 0;
float prevResp = 0;

void calculateRpm(float resp) {
    if (prevResp < 512 && resp >= 512) {
        int now = millis();
        if (lastRespMs > 0) {
            rpm = 60000.0 / (now - lastRespMs);
        }
        lastRespMs = now;
    }
    prevResp = resp;
}

int lastRiseMs = 0;
int lastFallMs = 0;
int inhaleMs = 0;
int exhaleMs = 0;
float prevBreath = 512;

void calculateBreath(float resp) {
    int now = millis();
    if (prevBreath < 512 && resp >= 512) {
        if (lastFallMs > 0) exhaleMs = now - lastFallMs;
        lastRiseMs = now;
    } else if (prevBreath >= 512 && resp < 512) {
        if (lastRiseMs > 0) inhaleMs = now - lastRiseMs;
        lastFallMs = now;
    }
    prevBreath = resp;
}
