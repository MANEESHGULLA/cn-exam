# Stop-and-Wait ARQ Simulation in NS2

set ns [new Simulator]

set tracefile [open stopwait.tr w]
$ns trace-all $tracefile

set namfile [open stopwait.nam w]
$ns namtrace-all $namfile

# Create nodes
set sender [$ns node]
set receiver [$ns node]

# Link
$ns duplex-link $sender $receiver 1Mb 10ms DropTail

# Agents
set tcp [new Agent/TCP]
$tcp set packetSize_ 500
$ns attach-agent $sender $tcp

set ack [new Agent/TCPSink]
$ns attach-agent $receiver $ack

$ns connect $tcp $ack

# Application (represents Stop & Wait data sending)
set ftp [new Application/FTP]
$ftp attach-agent $tcp

# Simulation events
$ns at 0.5 "$ftp start"
$ns at 2.0 "$ftp stop"
$ns at 2.5 "finish"

# Finish procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam stopwait.nam &
    exit 0
}

$ns run
