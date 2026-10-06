import processing.serial.*;

String PORT_NAME = "/dev/cu.usbserial-0001";
Serial port;

void setupSerial() {
    printArray(Serial.list());
    port = new Serial(this, PORT_NAME, 115200);
    port.bufferUntil('\n');
}

void serialEvent(Serial p) {
    String line = p.readStringUntil('\n');
    if (line == null) return;
    line = trim(line);
    if (line.equals("!") || line.length() == 0) return;
    onSample(float(line), 512);
}
