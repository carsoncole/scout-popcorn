module ApplicationHelper
  def nice_date(date)
    date.strftime("%B %d, %Y")
  end

  def nice_date_less(date)
    date.strftime("%b %d, %Y")
  end

  def nice_date_time(datetime)
    datetime.strftime("%B %d, %Y %I:%M%p")
  end

  def nice_date_time_less(datetime)
    datetime.strftime("%b %d, %Y %I:%M%p")
  end
end
