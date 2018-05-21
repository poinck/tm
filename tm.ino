/*
 * tm (temperature measurement), by poinck, CC0
 *
 * lcd code used from Mark Bramwell (100700)
 * - modified (180520)
 */

#include <LiquidCrystal.h>
#include <EEPROM.h>

#define LCD_BACKLIGHT 10
int lcd_backlight_stdlevel = 16;
int lcd_backlight_level = lcd_backlight_stdlevel;
int lcd_backlight_cycle = 0;

LiquidCrystal lcd(8, 9, 4, 5, 6, 7);

// define some values used by the panel and buttons
int lcd_key = 0;
int adc_key_in = 0;

#define button_right 0
#define btnUP     1
#define btnDOWN   2
#define button_left 3
#define btnSELECT 4
#define btnNONE   5

#include <OneWire.h>
#include <DallasTemperature.h>

#define ONE_WIRE_BUS 2

OneWire ourWire(ONE_WIRE_BUS);
DallasTemperature sensors(&ourWire);
String s1 = "";
String s2 = "";
int t1 = 0;
int t2 = 0;

void identify_sensors(const byte* addr_part) {
    String st;
    if (addr_part == 0xF2) {
        Serial.print(", inside");
        st = "i";
    }
    else if (addr_part == 0xD1) {
        Serial.print(", outside");
        st = "o";
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

int read_lcd_buttons() {
    adc_key_in = analogRead(0);

    if (adc_key_in > 1000) return btnNONE;

    // button thresholds
    if (adc_key_in < 50)   return button_right;
    if (adc_key_in < 195)  return btnUP;
    if (adc_key_in < 380)  return btnDOWN;
    if (adc_key_in < 555)  return button_left;
    if (adc_key_in < 790)  return btnSELECT;

    return btnNONE;
}

int ee_address = 0;

struct lcdtext {
    char s[14];
};

void setup() {
    // initialize the LCD lib
    lcd.begin(16, 2);
    lcd.setCursor(0,0);
    lcd.print("t:push buttons");

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

    String ee_text = "";

    lcdtext lt_get;
    EEPROM.get(ee_address, lt_get);
    Serial.println("current text on EEPROM is");
    Serial.print("t:");
    Serial.println(lt_get.s);
    lcd.setCursor(2,0);
    lcd.print("              ");
    lcd.setCursor(2,0);
    lcd.print(lt_get.s);

    Serial.println("type to print on LCD");

    // by default, switch off lcd backlight
    analogWrite(LCD_BACKLIGHT, lcd_backlight_stdlevel);
}

int incomingByte = 0;
String incoming_text = "";
int next_interval = 0;
int nbl_interval = 0; // next backlight interval
int seconds_past = 0;
int next_counter = 0;

void loop(){
    lcd.setCursor(4,1);
    lcd.print("i:");
    lcd.setCursor(10,1);
    lcd.print("o:");
    seconds_past = millis()/1000;

    lcd.setCursor(0,1);
    lcd_key = read_lcd_buttons();

    switch (lcd_key){
        case button_right: {
            // cycle through LCD backlight levels (step 64)
            lcd_backlight_cycle = lcd_backlight_cycle + 1;
            if (lcd_backlight_cycle > 4) {
                lcd_backlight_cycle = 0;
            }
            lcd_backlight_level = lcd_backlight_cycle * 64;
            //if (lcd_backlight_level < lcd_backlight_stdlevel) {
            //    lcd_backlight_cycle = 1;
            //    lcd_backlight_level = 64;
            //}
            if (lcd_backlight_level == 256) {
                lcd_backlight_level = 255;
            }
            analogWrite(LCD_BACKLIGHT, lcd_backlight_level);
            nbl_interval = seconds_past + 60;
            Serial.print("lcd_backlight_level=");
            Serial.println(lcd_backlight_level);

            lcd.print("l:");
            lcd.print(lcd_backlight_cycle);

            break;
        }
        case button_left: {
            Serial.println("switch LCD backlight off");
            lcd_backlight_level = 0;
            lcd_backlight_cycle = 0;
            analogWrite(LCD_BACKLIGHT, lcd_backlight_level);

            lcd.print("l:0");

            break;
        }
        case btnUP: {
            lcd.print("b:U");
            break;
        }
        case btnDOWN: {
            lcd.print("b:D");
            break;
        }
        case btnSELECT: {
            lcd.print("b:S");
            break;
        }
        case btnNONE: {
            lcd.print("b:N");
            break;
        }
    }

    if (Serial.available() > 0) {
        //incomingByte = Serial.read();
        incoming_text = Serial.readString();

        // say what you got:
        Serial.print("t:");
        //Serial.println(incomingByte, DEC);
        Serial.println(incoming_text);
        lcd.setCursor(2,0);
        lcd.print("              ");
        lcd.setCursor(2,0);
        lcd.print(incoming_text);

        char c_text[14];
        lcdtext lt;
        incoming_text.toCharArray(lt.s, 14);
        //lt.s = c_text;

        EEPROM.put(ee_address, lt);
    }

    // temperature measurement every minute
    if (next_interval < seconds_past) {
        next_interval = next_interval + 60;
        sensors.requestTemperatures();

        Serial.print("s:");
        Serial.print(seconds_past);
        Serial.print(" ");
        Serial.print(s1);
        Serial.print(":");
        t1 = (int) sensors.getTempCByIndex(0);
        Serial.print(t1);
        lcd.setCursor(6,1);
        lcd.print("   ");
        lcd.setCursor(6,1);
        lcd.print(t1);
        Serial.print(" ");
        Serial.print(s2);
        Serial.print(":");
        t2 = (int) sensors.getTempCByIndex(1);
        Serial.print(t2);
        lcd.setCursor(12,1);
        lcd.print("   ");
        lcd.setCursor(12,1);
        lcd.print(t2);
        Serial.println();
    }

    // reset lcd backlight to std after 1 minute unless explicitly switched off
    if (lcd_backlight_level != 0) {
        if (lcd_backlight_level != lcd_backlight_stdlevel && nbl_interval < seconds_past) {
            Serial.println("setting LCD backlight standard level");
            lcd_backlight_level = lcd_backlight_stdlevel;
            lcd_backlight_cycle = 0;
            analogWrite(LCD_BACKLIGHT, lcd_backlight_stdlevel);
        }
    }

    next_counter = (int) ((next_interval - seconds_past) / 10) + 1;
    lcd.setCursor(13,0);
    lcd.print("d:");
    lcd.print(next_counter);

    delay(1000);
}

