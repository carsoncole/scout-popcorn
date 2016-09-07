module ApplicationHelper
  def nice_date_time(datetime)
    datetime.strftime("%B %d, %Y %I:%M%p")
  end
end
