import processing.serial.*;

String PORT_NAME = "/dev/cu.usbserial-0001";
Serial port;
float lastEcg = 512;

void setupSerial() {
    printArray(Serial.list());
    port = new Serial(this, PORT_NAME, 115200);
    port.bufferUntil('\n');
}

void serialEvent(Serial p) {
    String line = p.readStringUntil('\n');
    if (line == null) return;
    line = trim(line);
    println("serial: '" + line + "'");
    if (line.equals("!") || line.length() == 0) return;
    if (line.startsWith("->")) return;
    if (line.startsWith("Analog Reading = ")) {
        float r = float(line.substring(17));
        onSample(lastEcg, r);
    } else {
        lastEcg = float(line);
    }
}
