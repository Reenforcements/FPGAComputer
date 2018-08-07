
// This program runs really quickly because it 
//   accesses registers directly.

const byte matrix_R1 = 22;
const byte matrix_R2 = 24;

const byte matrix_G1 = 26;
const byte matrix_G2 = 28;

const byte matrix_B1 = 30;
const byte matrix_B2 = 32;

const byte matrix_a = 34;
const byte matrix_b = 36;
const byte matrix_c = 38;
const byte matrix_d = 48;
const byte matrix_e = 40;


const byte matrix_la = 42;
const byte matrix_clk = 44;
const byte matrix_oe = 46;

template <typename T> void printBits(T in) {
    unsigned char s = sizeof(T) * 8;
    Serial.print("0b");
    for (signed char g = s - 1; g >= 0; g--) {
        Serial.print( ((in & (1 << ((unsigned char) g))) > 0) ? "1" : "0");
    }
    Serial.println("");
}

void setup() {
    
    for (byte i = matrix_R1; i <= matrix_d; i+=2) {
        pinMode(i, OUTPUT);
        digitalWrite(i, LOW);
    }
    Serial.begin(9600);
}
byte row = 0;
unsigned long delayTime = 1;
unsigned long benchmark = 0;
unsigned long currentTime = millis();
void loop() {
    // Clock out data
    for (byte i = 0; i < 32; i++) {
        PORTA |= (1 << 0);//(matrix_R1, HIGH);
        PORTA &= ~(1 << 1);//digitalWrite(matrix_R2, LOW);
        PORTC &= ~(1 << 7);//digitalWrite(matrix_B1, LOW);
        PORTC |= (1 << 5);//digitalWrite(matrix_B2, HIGH);
        PORTA &= ~(1 << 4);//digitalWrite(matrix_G1, LOW);
        PORTA &= ~(1 << 6);//digitalWrite(matrix_G2, LOW);
        
        PORTL &= ~(1 << 5);//digitalWrite(matrix_clk, LOW);
        delayMicroseconds(delayTime);
        PORTL |= (1 << 5);//digitalWrite(matrix_clk, HIGH);
        delayMicroseconds(delayTime);
        PORTL &= ~(1 << 5);//digitalWrite(matrix_clk, LOW);
    }

    // Latch
    PORTL &= ~(1 << 7);//digitalWrite(matrix_la, LOW);
    PORTL &= ~(1 << 3);//digitalWrite(matrix_oe, LOW);
    delayMicroseconds(delayTime);
    PORTL |= (1 << 7);//digitalWrite(matrix_la, HIGH);
    PORTL |= (1 << 3);//digitalWrite(matrix_oe, HIGH);
    delayMicroseconds(delayTime);
    PORTL &= ~(1 << 7);//digitalWrite(matrix_la, LOW);
    PORTL &= ~(1 << 3);//digitalWrite(matrix_oe, LOW);

    //delay(200);
    PORTC = PORTC & 0b11110111 | ( ((0b00000001 & row) > 0) << 3); //digitalWrite(matrix_a, (0b00000001 & row) > 0 ? HIGH : LOW);
    PORTC = PORTC & 0b11111101 | ( ((0b00000010 & row) > 0) << 1);//digitalWrite(matrix_b, (0b00000010 & row) > 0 ? HIGH : LOW);
    PORTD = PORTD & 0b01111111 | ( ((0b00000100 & row) > 0) << 7);//digitalWrite(matrix_c, (0b00000100 & row) > 0 ? HIGH : LOW);
    PORTL = PORTL & 0b11111101 | ( ((0b00001000 & row) > 0) << 1);//digitalWrite(matrix_d, (0b00001000 & row) > 0 ? HIGH : LOW);
    PORTG = PORTG & 0b11111101 | ( ((0b00010000 & row) > 0) << 1);//digitalWrite(matrix_e, (0b00010000 & row) > 0 ? HIGH : LOW);
    
    //printBits(PORTC);
    row += 1;
    /*
    benchmark += 1;
    if ( millis() > (currentTime + 1000)) {
        currentTime = millis();
        Serial.println(benchmark);
        benchmark = 0;
    }
    */
    
}



