class LoadTest
  def test_with_channel
    start_time = Time.now
    for i in 0..1000
      Totoro::Queue.enqueue_with_new_channel('example_queue', {shu: i})
    end
    end_time = Time.now
    p (end_time - start_time)
  end

  def test_without_channel
    start_time = Time.now
    for i in 0..1000
      Totoro::Queue.enqueue('example_queue', {shu: i})
    end
    end_time = Time.now
    p (end_time - start_time)
  end
end