# Extensions for date
class Date
  # Returns the days in the month with padding.
  #
  # @return [Array<Date>] The days
  def days_for_calendar
    padding_for_calendar + (beginning_of_month..end_of_month).to_a
  end

  # Returns padding for the calendar
  #
  # @return [Array<String>] The padding with empty strings
  def padding_for_calendar
    (fmwday == 0 ? (0..5) : (0...fmwday - 1)).map { '' }
  end

  # Returns the first wday of the months
  #
  # @return [String] The day
  def fmwday
    beginning_of_month.wday
  end
end
