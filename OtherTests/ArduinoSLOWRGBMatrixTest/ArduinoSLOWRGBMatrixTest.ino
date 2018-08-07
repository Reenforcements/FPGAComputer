
// This code is slow because it uses digitalWrite.
// The other program uses registers directly and goes insanely fast.

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

void setup() {
    
    for (byte i = matrix_R1; i <= matrix_d; i+=2) {
        pinMode(i, OUTPUT);
        digitalWrite(i, LOW);
    }
}
byte row = 0;
unsigned long delayTime = 1;
void loop() {
    // Clock out data
    for (byte i = 0; i < 32; i++) {
        digitalWrite(matrix_R1, HIGH);
        digitalWrite(matrix_R2, LOW);
        digitalWrite(matrix_B1, LOW);
        digitalWrite(matrix_B2, HIGH);
        digitalWrite(matrix_G1, LOW);
        digitalWrite(matrix_G2, LOW);

        digitalWrite(matrix_clk, LOW);
        delayMicroseconds(delayTime);
        digitalWrite(matrix_clk, HIGH);
        delayMicroseconds(delayTime);
        digitalWrite(matrix_clk, LOW);
    }

    // Latch
    digitalWrite(matrix_la, LOW);
    digitalWrite(matrix_oe, LOW);
    delayMicroseconds(delayTime);
    digitalWrite(matrix_la, HIGH);
    digitalWrite(matrix_oe, HIGH);
    delayMicroseconds(delayTime);
    digitalWrite(matrix_la, LOW);
    digitalWrite(matrix_oe, LOW);

    digitalWrite(matrix_a, (0b00000001 & row) > 0 ? HIGH : LOW);
    digitalWrite(matrix_b, (0b00000010 & row) > 0 ? HIGH : LOW);
    digitalWrite(matrix_c, (0b00000100 & row) > 0 ? HIGH : LOW);
    digitalWrite(matrix_d, (0b00001000 & row) > 0 ? HIGH : LOW);
    digitalWrite(matrix_e, (0b00010000 & row) > 0 ? HIGH : LOW);
    delay(100);
    row += 1;

}



