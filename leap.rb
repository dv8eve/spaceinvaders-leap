require 'leap-motion-ws'
require 'pry'

$stdout.sync = true

class LeapTest < LEAP::Motion::WS
  def initialize side_threshold = 30, side_max = 100, offset = 120, intensivity_ranges = 10, vertical_threshold = 50, fire_threshold = 3
    @side_state = 'mid'
    @signal = 'none'
    @vertical_flag = 'none'
    @fire_flag = 'none'
    @side_threshold = side_threshold
    @vertical_threshold = vertical_threshold
    @fire_threshold = fire_threshold
    @offset = offset
    @intensivity_ranges = intensivity_ranges
    @range_size = (side_max - side_threshold) / intensivity_ranges
    @counter = 0
    puts 'initialize'
  end

  def inc_counter
    @counter = (@counter + 1) % @intensivity_ranges
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
    if hands.size == 2
      left_hand, right_hand = hands.sort_by { |h| h.palmPosition[0] }
      left_hand_pointables = frame.pointables.select { |p| p.handId == left_hand.id }

      process_left_hand left_hand
      process_right_hand right_hand, left_hand_pointables
    end
  end

  def process_left_hand hand
    x, y, z = hand.palmPosition
    x -= @offset

    intensivity = x.abs
    intensivity -= @side_threshold
    if intensivity < 0
      intensivity = 0
    else
      intensivity = (intensivity / @range_size).ceil
      intensivity = [intensivity, @intensivity_ranges].min
    end

    if x < -@side_threshold
      requested_state = 'left'
    elsif x > @side_threshold
      requested_state = 'right'
    else
      requested_state = 'mid'
    end

    if @side_state == requested_state
      if requested_state != 'mid'
        inc_counter
      end
    else
      @counter = 0
    end

    if @counter < intensivity
      requested_signal = requested_state
    else
      requested_signal = 'none'
    end

    # puts "x: #{x}\tintsv: #{intensivity}\treq: #{requested_state}, #{requested_signal}"

    if requested_signal != @signal
      puts "#{@signal}-up" if @signal != 'none'
      puts "#{requested_signal}-down" if requested_signal != 'none'
    end

    @signal = requested_signal
    @side_state = requested_state
  end

  def process_right_hand hand, pointables
    x, y, z = hand.palmPosition
    if z < -@vertical_threshold
      puts 'brake-up' if @vertical_flag == 'brake'

      if @vertical_flag != 'accelerate'
        @vertical_flag = 'accelerate'
        puts 'accelerate-down'
      end
    elsif z > @vertical_threshold
      puts 'accelerate-up' if @vertical_flag == 'accelerate'

      if @vertical_flag != 'brake'
        @vertical_flag = 'brake'
        puts 'brake-down'
      end
    else
      puts 'accelerate-up' if @vertical_flag == 'accelerate'
      puts 'brake-up' if @vertical_flag == 'brake'
      @vertical_flag = 'none' if @vertical_flag != 'none'
    end

    if pointables.size > @fire_threshold
      puts 'fire-press' if @fire_flag == 'none'
      @fire_flag = 'fire'
    else
      @fire_flag = 'none'
    end
  end


  def on_disconnect
    puts 'disconect'
    stop
  end
end

leap = LeapTest.new(30)
leap.start

