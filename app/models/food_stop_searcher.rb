class FoodStopSearcher

  DOMAIN = "data.sfgov.org"
  DATASET_ID = "bbb8-hzi6"
  DAYS = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
  TIMES = ["Before 11 AM", "11 AM - 2 PM", "2 PM - 4 PM", "After 4 PM"]

  DEFAULT_LIMIT = 10

  def self.general( limit = DEFAULT_LIMIT )
    client.get(DATASET_ID, limit)
  end

  def self.search( opts = {} )
    unless opts.empty?
      time_filter = build_time_query( opts[:time_filter] || [] )
      day_filter  = build_day_query( opts[:day_filter] )
      text_match  = build_text_query( opts[:query] )

      where_query = build_and( text_match, day_filter, time_filter )

      query_hash = {}
      query_hash["$limit"] = opts[:limit] || DEFAULT_LIMIT
      query_hash["$where"] = where_query unless where_query.empty?

      client.get(DATASET_ID, query_hash)
    else
      general
    end
  end

  private
    def self.client
      @@client ||= SODA::Client.new({:domain => DOMAIN, :app_token => Rails.application.secrets.soda_app_token})
    end

    def self.build_day_query( days )
      days.nil? ? "" : "dayofweekstr in( '#{days.join("','")}' )"
    end

    def self.build_text_query( query )
      unless query.nil?
         "(applicant LIKE '%#{query}%' OR optionaltext LIKE '%#{query}%' OR applicant LIKE '%#{query.downcase}%' OR optionaltext LIKE '%#{query.downcase}%')"
      else
        ""
      end
    end

    def self.build_and(*args)
      args.inject { |q, a| q.empty? ? a : (q + " AND " + a) }
    end

    def self.build_time_query( times )
      (times.nil? || times.empty?) ? "" : "starttime in( '#{hours(times)}' )"
    end

    def self.hours( times )
      time_list = []
      time_list += %w( 6AM 7AM 8AM 9AM 10AM ) if times.include? "0"
      time_list += %w( 11AM 12PM 1PM ) if times.include? "1"
      time_list += %w( 2PM 3PM ) if times.include? "2"
      time_list += %w( 4PM 5PM 6PM 7PM 8PM 9PM 10PM 11PM ) if times.include? "3"
      time_list.join("','")
    end
end
