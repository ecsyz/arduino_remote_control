#!/usr/bin/perl
$|=1;
use common::sense;
use Device::SerialPort;
use Time::HiRes qw/usleep/;
my $usleep=200000;

my $port = Device::SerialPort->new("/dev/ttyUSB0") || die "cant open COM port\n";

# Параметры считывания данных с порта
$port->baudrate(115200);
$port->databits(8);
$port->parity("none");
$port->stopbits(1);

my $code_retries = 4294967295;
my $code_last    = undef;

my $code2key={
	12   => 'xdotool key Escape',
	17   => 'xdotool key Left',
	16   => 'xdotool key Right',
	52   => 'xdotool key shift+3',
	54   => 'xdotool key v',
	55   => 'xdotool key Return',
	#...
};

while(1) {
	usleep($usleep);
	my $code = $port->lookfor();
	if(defined $code && $code=~/\d+/){
		$code=~s/[\r\n]//g;
		
		#---/ Обработка повторных нажатий /---#
		if($code == $code_retries && defined $code_last){
			$code=$code_last;
		}
		$code_last=$code if($code != $code_retries);
		next unless(exists $code2key->{$code});
		#--------------------------------------
		
		#say $code2key->{$code};
		system($code2key->{$code});
	}
}

1;