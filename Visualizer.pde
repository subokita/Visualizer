import processing.serial.*;
import cc.arduino.*;
import krister.Ess.*;

/* For audio */
AudioChannel audio_channel;
FFT fft;
int buffer_size;
int buffer_duration;

/* For arduino */
Arduino arduino;
int [] row = {16, 12, 18, 13, 5, 19, 7, 2}; // reversed of {2, 7, 19, 5, 13, 18, 12, 16};
int [] col = {6, 11, 10, 3, 17, 4, 8, 9};
int row_index = 0;
int col_index = 0;

int no_of_spectrums = 32;

void setup() {
	arduino = new Arduino(this, "/dev/tty.usbmodem1411" );

	for( int i = 0; i < 8; i++ ) {
		arduino.pinMode( row[i], Arduino.OUTPUT );
		arduino.pinMode( col[i], Arduino.OUTPUT );

		arduino.digitalWrite( col[i], Arduino.HIGH );
	}
	
	size(600, 600);

	Ess.start( this );

	audio_channel 	= new AudioChannel( "audio.mp3" );
	buffer_size 	= audio_channel.buffer.length;
	buffer_duration = audio_channel.ms( buffer_size );
	fft 			= new FFT( no_of_spectrums * 2 );

	frameRate( 30 );
	noSmooth();

}

void draw() {
	background( 200 );

	// for( int i = 0; i < 8; i++ ) {
	// 	arduino.digitalWrite( row[i], Arduino.LOW );
	// 	arduino.digitalWrite( col[i], Arduino.HIGH );
	// }

	if( audio_channel.state != Ess.PLAYING )
		return;

	fft.getSpectrum( audio_channel );

    for ( int i = 0; i < 8; i++ ) {    
    	for( int j = 0; j < 8; j++ ) {
			arduino.digitalWrite( row[j], Arduino.LOW );
			arduino.digitalWrite( col[j], Arduino.HIGH );
		}

    	float temp = constrain( fft.spectrum[i], 0.0, 0.5 );
    	float mapped = map( temp, 0.0, 0.5, 0, 7 );
    	int rounded = round( mapped );

    	for( int j = 0; j <= rounded; j++ )
			arduino.digitalWrite( row[j], Arduino.HIGH );
		arduino.digitalWrite( col[i], Arduino.LOW );   	
    }

}

public void stop() {
	Ess.stop();
	super.stop();
}

void keyPressed() {
	if( keyCode == 32 ) {
		if( audio_channel.state == Ess.PLAYING )
			audio_channel.stop();
		else
			audio_channel.play( Ess.FOREVER );
	}
}
