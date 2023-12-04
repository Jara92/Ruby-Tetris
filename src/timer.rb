class Timer
  def initialize(wait_time)
    @wait_time = wait_time
  end

  def start
    @start_time = Time.now
  end

  def stop
    @start_time = nil
  end

  def reset
    @start_time = Time.now
  end

  def elapsed_time
    return 0 if @start_time.nil?

    Time.now - @start_time
  end

  def tick?
    return false if @start_time.nil?

    elapsed_time >= @wait_time
  end

  def update_wait_time(wait_time)
    @wait_time = wait_time
  end
end