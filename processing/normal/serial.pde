import processing.serial.*;

Serial port;

void setupSerial() {
    printArray(Serial.list());
    for (String name : Serial.list()) {
        if (name.contains("usb")) {
            port = new Serial(this, name, 115200);
            port.bufferUntil('\n');
            return;
        }
    }
    println("No USB serial port found. Set mock = true or plug in the board.");
}

void serialEvent(Serial p) {
    String line = p.readStringUntil('\n');
    if (line == null) return;
    line = trim(line);
    if (line.equals("!") || line.length() == 0) return;
    onSample(float(line), 512);
}
