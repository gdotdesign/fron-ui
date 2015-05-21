class Date
  def days_for_calendar
    padding_for_calendar + (beginning_of_month..end_of_month).to_a
  end

  def padding_for_calendar
    (fmwday == 0 ? (0..5) : (0...fmwday - 1)).map { '' }
  end

  def fmwday
    beginning_of_month.wday
  end
end
