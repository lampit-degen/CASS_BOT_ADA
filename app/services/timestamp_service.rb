class TimestampService
  TIME_DIFFERENCE_IN_SECONDS = 10.seconds

  def initialize(*timestamps)
    p timestamps.inspect
    # Convert all timestamps to floats if they aren't already
    @timestamps = timestamps.map(&:to_f)
  end

  def call
    # First, check if we have enough timestamps to proceed
    return false if @timestamps.length < 2
    # Sort timestamps to ensure we're checking in chronological order
    x = @timestamps.length
    sorted_timestamps = @timestamps.sort
    # Check if the first 'x' timestamps are within x seconds of each other
    (0...x-1).all? do |i|
      diff = (sorted_timestamps[i+1] - sorted_timestamps[i]).abs
      p "#{sorted_timestamps[i+1]} - #{sorted_timestamps[i]} = #{diff}"
      diff <= TIME_DIFFERENCE_IN_SECONDS
    end
  end
end
