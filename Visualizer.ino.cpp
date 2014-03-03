#include <Arduino.h>
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

int [] row = {13, 11, 15, 12, 4, 16, 6, 1}; // reversed of {2, 7, 19, 5, 13, 18, 12, 16};
int [] col = {5, 10, 9, 2, 14, 3, 7, 8};

int col_index = 0;


void draw();

void setup() {
	println(Arduino.list());

	arduino = new Arduino(this, "/dev/tty.usbmodem1411" );

	for( int i = 0; i < 8; i++ ) {
		arduino.pinMode( row[i], Arduino.OUTPUT );
		arduino.pinMode( col[i], Arduino.OUTPUT );

		arduino.digitalWrite( col[i], Arduino.HIGH );
	}
}

void draw() {
	for( int i = 0; i < 8; i++ ) {
		arduino.digitalWrite( row[i], Arduino.LOW );
		arduino.digitalWrite( col[i], Arduino.HIGH );
	}

	arduino.digitalWrite( row[0], Arduino.HIGH );
	arduino.digitalWrite( col[0], Arduino.LOW );


	delay( 500 );

}