# CLOSED: APP_PASSIVE_OPEN -> LISTEN
# CLOSED: APP_ACTIVE_OPEN  -> SYN_SENT

# LISTEN: RCV_SYN          -> SYN_RCVD
# LISTEN: APP_SEND         -> SYN_SENT
# LISTEN: APP_CLOSE        -> CLOSED

# SYN_RCVD: APP_CLOSE      -> FIN_WAIT_1
# SYN_RCVD: RCV_ACK        -> ESTABLISHED

# SYN_SENT: RCV_SYN        -> SYN_RCVD
# SYN_SENT: RCV_SYN_ACK    -> ESTABLISHED
# SYN_SENT: APP_CLOSE      -> CLOSED

# ESTABLISHED: APP_CLOSE   -> FIN_WAIT_1
# ESTABLISHED: RCV_FIN     -> CLOSE_WAIT

# FIN_WAIT_1: RCV_FIN      -> CLOSING
# FIN_WAIT_1: RCV_FIN_ACK  -> TIME_WAIT
# FIN_WAIT_1: RCV_ACK      -> FIN_WAIT_2

# CLOSING: RCV_ACK         -> TIME_WAIT

# FIN_WAIT_2: RCV_FIN      -> TIME_WAIT

# TIME_WAIT: APP_TIMEOUT   -> CLOSED

# CLOSE_WAIT: APP_CLOSE    -> LAST_ACK

# LAST_ACK: RCV_ACK        -> CLOSED

STATES = {
  'CLOSED' => {'APP_PASSIVE_OPEN' => 'LISTEN', 'APP_ACTIVE_OPEN' => 'SYN_SENT'},
  'LISTEN' => {'RCV_SYN' => 'SYN_RCVD', 'APP_SEND' => 'SYN_SENT', 'APP_CLOSE' => 'CLOSED'},
  'SYN_RCVD' => {'APP_CLOSE' => 'FIN_WAIT_1', 'RCV_ACK' => 'ESTABLISHED'},
  'SYN_SENT' => {'RCV_SYN' => 'SYN_RCVD', 'RCV_SYN_ACK' => 'ESTABLISHED', 'APP_CLOSE' => 'CLOSED'},
  'ESTABLISHED' => {'APP_CLOSE' => 'FIN_WAIT_1', 'RCV_FIN' => 'CLOSE_WAIT'},
  'FIN_WAIT_1' => {'RCV_FIN' => 'CLOSING', 'RCV_FIN_ACK' => 'TIME_WAIT', 'RCV_ACK' => 'FIN_WAIT_2'},
  'CLOSING' => {'RCV_ACK' => 'TIME_WAIT'},
  'FIN_WAIT_2' => {'RCV_FIN' => 'TIME_WAIT'},
  'TIME_WAIT' => {'APP_TIMEOUT' => 'CLOSED'},
  'CLOSE_WAIT' => {'APP_CLOSE' => 'LAST_ACK'},
  'LAST_ACK' => {'RCV_ACK' => 'CLOSED'},
}

def traverse_TCP_states(event_list)
  event_list.reduce('CLOSED') do |state, event|
    return state if state == 'ERROR'
  
    STATES.dig(state, event) || 'ERROR'
  end
end

def eq(actual, expected)
  if actual == expected
    puts "PASSED. #{actual}"

    true
  else
    puts "Error: expected #{expected.inspect}, got #{actual.inspect}"

    false
  end
end

ok, failed = [
  eq(traverse_TCP_states(["APP_PASSIVE_OPEN",  "RCV_SYN","RCV_ACK",   "APP_CLOSE"]),"FIN_WAIT_1"),
  eq(traverse_TCP_states(["APP_PASSIVE_OPEN",  "RCV_SYN","RCV_ACK"]), "ESTABLISHED"),               
  eq(traverse_TCP_states(["APP_PASSIVE_OPEN",  "RCV_SYN"]), "SYN_RCVD"),               
  eq(traverse_TCP_states(["APP_PASSIVE_OPEN"]), "LISTEN"),
  eq(traverse_TCP_states(["APP_ACTIVE_OPEN","APP_CLOSE"]), "CLOSED"),                   
  eq(traverse_TCP_states(["APP_ACTIVE_OPEN","RCV_SYN","APP_CLOSE","RCV_FIN","RCV_ACK"]), "TIME_WAIT"),
  eq(traverse_TCP_states(["APP_ACTIVE_OPEN","RCV_SYN","APP_CLOSE","RCV_FIN","RCV_ACK","APP_TIMEOUT"]), "CLOSED"),
  eq(traverse_TCP_states(["RCV_SYN","RCV_ACK","APP_CLOSE"]), "ERROR"),
  eq(traverse_TCP_states(["APP_ACTIVE_OPEN","RCV_SYN","APP_CLOSE","RCV_ACK"]), "FIN_WAIT_2"),
  eq(traverse_TCP_states(["APP_ACTIVE_OPEN","RCV_SYN_ACK","RCV_FIN"]), "CLOSE_WAIT"), 
  eq(traverse_TCP_states(["APP_ACTIVE_OPEN","RCV_SYN_ACK","RCV_FIN","APP_CLOSE"]), "LAST_ACK"),
  eq(traverse_TCP_states(["APP_ACTIVE_OPEN"]), "SYN_SENT"),
].partition { |el| el }

if failed.empty?
  puts "\nFinished, all tests passed."
else
  puts "\nFinished, #{failed.size} of #{failed.size + ok.size} failed."
end
