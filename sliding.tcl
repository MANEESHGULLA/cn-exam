# Sliding Window (Go-Back-N) in NS2 with NAM

set ns [new Simulator]

# Trace files
set tr [open slide.tr w]
$ns trace-all $tr

set nam [open slide.nam w]
$ns namtrace-all $nam

# Nodes
set s [$ns node]
set d [$ns node]

# Link
$ns duplex-link $s $d 1Mb 10ms DropTail
$ns duplex-link-op $s $d orient right

# TCP (Sliding Window behavior)
set tcp [new Agent/TCP]
$tcp set window_ 5
$tcp set packetSize_ 500
$ns attach-agent $s $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $d $sink

$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

# Start traffic
$ns at 0.2 "$ftp start"
$ns at 3.0 "$ftp stop"
$ns at 3.1 "finish"

proc finish {} {
    global ns tr nam
    $ns flush-trace
    close $tr
    close $nam
    exec nam slide.nam &
    exit 0
}

$ns run
