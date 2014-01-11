$stdout.sync = true

while true do
  puts "left-down"
  $stdout.flush
  sleep(1)
  puts "left-up"
  $stdout.flush
  sleep(1)
  puts "right-down"
  $stdout.flush
  sleep(1)
  puts "right-up"
  $stdout.flush
  sleep(1)
end
