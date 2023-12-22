=begin
Ticking timer
=end
class Timer
  "" "
  Create a new timer instance
  wait_time is the time to wait before next tick
  " ""

  def initialize(wait_time)
    @wait_time = wait_time
  end

  "" "
  Start the timer
  " ""

  def start
    @start_time = Time.now
  end

  "" "
  Stop the timer
  " ""
  def stop
    @start_time = nil
  end

  "" "
  Reset the timer
  " ""
  def reset
    @start_time = Time.now
  end

  "" "
  Get the elapsed time since the timer started
  " ""
  def elapsed_time
    return 0 if @start_time.nil?

    Time.now - @start_time
  end

  "" "
  Check if the timer has ticked
  " ""
  def tick?
    return false if @start_time.nil?

    elapsed_time >= @wait_time
  end

  "" "
  Change the wait time before next tick
  " ""

  def change_wait_time(wait_time)
    @wait_time = wait_time
  end
end