/*
 * tm, by poinck, CC0
 */

#include <OneWire.h>
#include <DallasTemperature.h>

#define ONE_WIRE_BUS 6

OneWire ourWire(ONE_WIRE_BUS);
DallasTemperature sensors(&ourWire);
String s1 = "";
String s2 = "";

void setup() {
    Serial.begin(9600);
    delay(1000);
    Serial.println("start tm with serial 9600 ..");
    sensors.begin();
    Serial.println(" - get dallas sensors ..");
    get_sensors();
    Serial.println(" - set dallas resolution ..");
    sensors.setResolution(9);
    Serial.println(".. tm ready");
    Serial.println();
}

void loop() {
    sensors.requestTemperatures();

    Serial.print(s1);
    Serial.print(": ");
    Serial.print(sensors.getTempCByIndex(0));
    Serial.println();
    Serial.print(s2);
    Serial.print(": ");
    Serial.print(sensors.getTempCByIndex(1));
    Serial.println();

    delay(15000);
}

void identify_sensors(const byte* addr_part) {
    String st;
    if (addr_part == 0xF2) {
        Serial.print(", inside");
        st = "inside";
    }
    else if (addr_part == 0xD1) {
        Serial.print(", outside");
        st = "outside";
    }
    else {
        Serial.print("");
        st = "unknown";
    }

    if (s1 == "") {
        s1 = st;
    }
    else {
        s2 = st;
    }
}

void get_sensors(void) {
    byte i;
    byte present = 0;
    byte data[12];
    byte addr[8];

    while(ourWire.search(addr)) {
        Serial.print("   ");
        for (i = 0; i < 8; i++) {
            if (addr[i] < 16) {
                Serial.print('0');
            }
            Serial.print(addr[i], HEX);
            if (i < 7) {
                Serial.print(" ");
            }
            else {
                identify_sensors(addr[i]);
                Serial.println();
            }
        }
        if (OneWire::crc8(addr, 7) != addr[7]) {
            Serial.print("   CRC is not valid!\n\r");

            return;
        }
    }
    ourWire.reset_search();

    return;
}
