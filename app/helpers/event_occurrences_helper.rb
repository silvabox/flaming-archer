module EventOccurrencesHelper
  def params_slug_to_time(key = :id)
    EventOccurrence.slug_to_time(params[key])
  end
end
