# Distance Vector Routing Simulation in NS2
# Bellman-Ford (RIP-style behavior)

set ns [new Simulator]

# Trace files
set tr [open dv.tr w]
$ns trace-all $tr

set nam [open dv.nam w]
$ns namtrace-all $nam

# Create 4 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

# Topology
# n0 -- n1 -- n2 -- n3
$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail

# Orientation for NAM
$ns duplex-link-op $n0 $n1 orient right
$ns duplex-link-op $n1 $n2 orient right
$ns duplex-link-op $n2 $n3 orient right

# Routing Protocol: Distance Vector (RIP type)
$ns rtproto DV

# Traffic source - Ping style packets
set udp [new Agent/UDP]
$ns attach-agent $n0 $udp

set null [new Agent/Null]
$ns attach-agent $n3 $null

$ns connect $udp $null

set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 500
$cbr set interval_ 0.05
$cbr attach-agent $udp

# Start / Stop
$ns at 0.5 "$cbr start"
$ns at 4.0 "$cbr stop"
$ns at 4.2 "finish"

# Finish procedure
proc finish {} {
    global ns tr nam
    $ns flush-trace
    close $tr
    close $nam
    exec nam dv.nam &
    exit 0
}

$ns run
