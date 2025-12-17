# Star topology in NS2

set ns [new Simulator]

set tr [open star.tr w]
$ns trace-all $tr

set nam [open star.nam w]
$ns namtrace-all $nam

# Create nodes
set c [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

# Links (center c connected to all)
$ns duplex-link $c $n1 2Mb 10ms DropTail
$ns duplex-link $c $n2 2Mb 10ms DropTail
$ns duplex-link $c $n3 2Mb 10ms DropTail
$ns duplex-link $c $n4 2Mb 10ms DropTail

# Traffic: TCP from n1 -> n3
set tcp [new Agent/TCP]
$ns attach-agent $n1 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink

$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns at 0.5 "$ftp start"
$ns at 4.5 "$ftp stop"
$ns at 5.0 "finish"

proc finish {} {
    global ns tr nam
    $ns flush-trace
    close $tr
    close $nam
    exec nam star.nam &
    exit 0
}

$ns run
