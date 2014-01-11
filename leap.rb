require 'leap-motion-ws'

class LeapTest < LEAP::Motion::WS
  def on_connect
    puts "Connect"
  end

  def on_frame frame
    puts "Frame ##{frame.id}, timestamp: #{frame.timestamp}, hands: #{frame.hands.size}, pointables: #{frame.pointables.size}, gestures: #{frame.gestures.size}"
    frame.hands.each_with_index do |hand, idx|
      puts "Hand #{idx}. Palm position: #{hand.palmPosition}"
    end
  end

  def on_disconnect
    puts "disconect"
    stop
  end
end

leap = LeapTest.new
leap.start
