require 'leap-motion-ws'
require 'pry'

$stdout.sync = true

class LeapTest < LEAP::Motion::WS
  def initialize side_threshold = 50
    @side_flag = 'none'
    @side_threshold = side_threshold
    puts 'initialize'
  end

  def on_connect
    puts 'Connect'
  end

  def on_frame frame
    # puts "Frame ##{frame.id}, timestamp: #{frame.timestamp}, hands: #{frame.hands.size}, pointables: #{frame.pointables.size}, gestures: #{frame.gestures.size}"
    # frame.hands.each_with_index do |hand, idx|
      # puts "Hand #{idx}. Palm position: #{hand.palmPosition}"
    # end

    hands = frame.hands
    if hands.any?
      first_hand = hands.first
      x, y, z = first_hand.palmPosition
      if x < -@side_threshold
        puts 'right-up' if @side_flag == 'right'

        if @side_flag != 'left'
          @side_flag = 'left'
          puts 'left-down'
        end
      elsif x > @side_threshold
        puts 'left-up' if @side_flag == 'left'

        if @side_flag != 'right'
          @side_flag = 'right'
          puts 'right-down'
        end
      else
        puts 'left-up' if @side_flag == 'left'
        puts 'right-up' if @side_flag == 'right'
        @side_flag = 'none' if @side_flag != 'none'
      end
    end
  end

  def on_disconnect
    puts 'disconect'
    stop
  end
end

leap = LeapTest.new
leap.start

