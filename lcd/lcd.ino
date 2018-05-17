/*************************************************************************************

  Mark Bramwell, July 2010

  This program will test the LCD panel and the buttons.When you push the button on the shield，
  the screen will show the corresponding one.

  Connection: Plug the LCD Keypad to the UNO(or other controllers)

**************************************************************************************/

#include <LiquidCrystal.h>
#include <EEPROM.h>

LiquidCrystal lcd(8, 9, 4, 5, 6, 7);           // select the pins used on the LCD panel

// define some values used by the panel and buttons
int lcd_key     = 0;
int adc_key_in  = 0;

#define btnRIGHT  0
#define btnUP     1
#define btnDOWN   2
#define btnLEFT   3
#define btnSELECT 4
#define btnNONE   5

int read_LCD_buttons(){               // read the buttons
    adc_key_in = analogRead(0);       // read the value from the sensor

    // my buttons when read are centered at these valies: 0, 144, 329, 504, 741
    // we add approx 50 to those values and check to see if we are close
    // We make this the 1st option for speed reasons since it will be the most likely result

    if (adc_key_in > 1000) return btnNONE;

    // For V1.1 us this threshold
    //if (adc_key_in < 50)   return btnRIGHT;
    //if (adc_key_in < 250)  return btnUP;
    //if (adc_key_in < 450)  return btnDOWN;
    //if (adc_key_in < 650)  return btnLEFT;
    //if (adc_key_in < 850)  return btnSELECT;

   // For V1.0 comment the other threshold and use the one below:
     if (adc_key_in < 50)   return btnRIGHT;
     if (adc_key_in < 195)  return btnUP;
     if (adc_key_in < 380)  return btnDOWN;
     if (adc_key_in < 555)  return btnLEFT;
     if (adc_key_in < 790)  return btnSELECT;

    return btnNONE;                // when all others fail, return this.
}

int ee_address = 0;

struct lcdtext {
    char s[14];
};

void setup() {
   lcd.begin(16, 2);               // start the library
   lcd.setCursor(0,0);             // set the LCD cursor   position
   lcd.print("t:push buttons");  // print a simple message on the LCD

    Serial.begin(9600);
    delay(1000);
    Serial.println("type to print on LCD");

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

    Serial.println("type to print something else on LCD");
}

int incomingByte = 0;
String incoming_text = "";

void loop(){
   lcd.setCursor(9,1);             // move cursor to second line "1" and 9 spaces over
    lcd.print("s:");
    lcd.setCursor(11,1);
   lcd.print(millis()/1000);       // display seconds elapsed since power-up

   lcd.setCursor(0,1);             // move to the begining of the second line
   lcd_key = read_LCD_buttons();   // read the buttons

   switch (lcd_key){               // depending on which button was pushed, we perform an action
       case btnRIGHT:{             //  push button "RIGHT" and show the word on the screen
            lcd.print("b:R");
            break;
       }
       case btnLEFT:{
             lcd.print("b:L"); //  push button "LEFT" and show the word on the screen
             break;
       }
       case btnUP:{
             lcd.print("b:U");  //  push button "UP" and show the word on the screen
             break;
       }
       case btnDOWN:{
             lcd.print("b:D");  //  push button "DOWN" and show the word on the screen
             break;
       }
       case btnSELECT:{
             lcd.print("b:S");  //  push button "SELECT" and show the word on the screen
             break;
       }
       case btnNONE:{
             lcd.print("b:N");  //  No action  will show "None" on the screen
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
}

