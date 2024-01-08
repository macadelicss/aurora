module CalControl
  class ConferenceProperties
    def initialize
      @allowed_conference_solution_types = []
    end

    def scrape(conference_props_data)
      if conference_props_data.key?("allowedConferenceSolutionTypes")
        @allowed_conference_solution_types = conference_props_data["allowedConferenceSolutionTypes"]
      end
    end
  end

  class Calendar
    attr_accessor :id, :summary, :time_zone, :conference_properties

    def initialize
      @id = ""
      @summary = ""
      @time_zone = ""
      @conference_properties = ConferenceProperties.new
    end

    def scrape(calendar_data)
      @id = calendar_data["id"] if calendar_data.key?("id")
      @summary = calendar_data["summary"] if calendar_data.key?("summary")
      @time_zone = calendar_data["timeZone"] if calendar_data.key?("timeZone")

      if calendar_data.key?("conferenceProperties")
        @conference_properties.scrape(calendar_data["conferenceProperties"])
      end
    end
  end

  class CalendarReminder
    attr_accessor :method, :minutes

    def initialize
      @method = ""
      @minutes = 0
    end

    def scrape(reminder_data)
      @method = reminder_data["method"] if reminder_data.key?("method")
      @minutes = reminder_data["minutes"] if reminder_data.key?("minutes")
    end
  end

  class CalendarPerson
    attr_accessor :email, :display_name, :self_flag

    def initialize
      @email = ""
      @display_name = ""
      @self_flag = nil
    end

    def scrape(person_data)
      @email = person_data["email"] if person_data.key?("email")
      @display_name = person_data["displayName"] if person_data.key?("displayName")
      @self_flag = person_data["self"] if person_data.key?("self")
    end
  end

  class CalendarTime
    attr_accessor :date_time, :time_zone

    def initialize
      @date_time = nil
      @time_zone = ""
    end

    def scrape(time_data)
      if time_data.key?("dateTime")
        begin
          @date_time = DateTime.parse(time_data["dateTime"])
        rescue ArgumentError
          @date_time = nil
        end
      end
      @time_zone = time_data["timeZone"] if time_data.key?("timeZone")
    end
  end

  class CalendarReminders
    attr_accessor :use_default, :overrides

    def initialize
      @use_default = 0
      @overrides = []
    end

    def scrape(reminders_data)
      @use_default = reminders_data["useDefault"] if reminders_data.key?("useDefault")

      if reminders_data.key?("overrides")
        reminders_data["overrides"].each do |reminder_data|
          reminder = CalendarReminder.new
          reminder.scrape(reminder_data)
          @overrides << reminder
        end
      end
    end
  end

  class CalendarEvent
    attr_accessor :id, :status, :html_link, :created, :updated, :summary, :description, :location,
                  :creator, :organizer, :start, :end, :recurring_event_id, :original_start_time,
                  :visibility, :ical_uid, :sequence, :guest_can_invite_others, :reminders, :event_type

    def initialize
      @id = ""
      @status = ""
      @html_link = ""
      @created = nil
      @updated = nil
      @summary = ""
      @description = ""
      @location = ""
      @creator = CalendarPerson.new
      @organizer = CalendarPerson.new
      @start = CalendarTime.new
      @end = CalendarTime.new
      @recurring_event_id = ""
      @original_start_time = CalendarTime.new
      @visibility = ""
      @ical_uid = ""
      @sequence = 0
      @guest_can_invite_others = nil
      @reminders = CalendarReminders.new
      @event_type = ""
    end

    def scrape(event_data)
      @id = event_data["id"] if event_data.key?("id")
      @status = event_data["status"] if event_data.key?("status")
      @html_link = event_data["htmlLink"] if event_data.key?("htmlLink")
      @created = DateTime.parse(event_data["created"]) rescue nil if event_data.key?("created")
      @updated = DateTime.parse(event_data["updated"]) rescue nil if event_data.key?("updated")
      @summary = event_data["summary"] if event_data.key?("summary")
      @description = event_data["description"] if event_data.key?("description")
      @location = event_data["location"] if event_data.key?("location")
      @creator.scrape(event_data["creator"]) if event_data.key?("creator")
      @organizer.scrape(event_data["organizer"]) if event_data.key?("organizer")
      @start.scrape(event_data["start"]) if event_data.key?("start")
      @end.scrape(event_data["end"]) if event_data.key?("end")
      @recurring_event_id = event_data["recurringEventId"] if event_data.key?("recurringEventId")
      @original_start_time.scrape(event_data["originalStartTime"]) if event_data.key?("originalStartTime")
      @visibility = event_data["visibility"] if event_data.key?("visibility")
      @ical_uid = event_data["iCalUID"] if event_data.key?("iCalUID")
      @sequence = event_data["sequence"] if event_data.key?("sequence")
      @guest_can_invite_others = event_data["guestsCanInviteOthers"] if event_data.key?("guestsCanInviteOthers")
      @reminders.scrape(event_data["reminders"]) if event_data.key?("reminders")
      @event_type = event_data["eventType"] if event_data.key?("eventType")
    end
  end

  class CalendarEvents
    attr_accessor :summary, :updated, :time_zone, :access_role, :default_reminders, :next_page_token, :items

    def initialize
      @summary = ""
      @updated = nil
      @time_zone = ""
      @access_role = ""
      @default_reminders = []
      @next_page_token = ""
      @items = []
    end

    def scrape(events_data)
      @summary = events_data["summary"] if events_data.key?("summary")
      @updated = DateTime.parse(events_data["updated"]) rescue nil if events_data.key?("updated")
      @time_zone = events_data["timeZone"] if events_data.key?("timeZone")
      @access_role = events_data["accessRole"] if events_data.key?("accessRole")

      if events_data.key?("defaultReminders")
        events_data["defaultReminders"].each do |reminder_data|
          reminder = CalendarReminder.new
          reminder.scrape(reminder_data)
          @default_reminders << reminder
        end
      end

      @next_page_token = events_data["nextPageToken"] if events_data.key?("nextPageToken")

      if events_data.key?("items")
        events_data["items"].each do |item_data|
          event = CalendarEvent.new
          event.scrape(item_data)
          @items << event
        end
      end
    end
  end
end
































=begin
# frozen_string_literal: true

module Parse
end




class ConferenceProperties < Parser
  attr_accessor :allowed_conference_solution_types

  def initialize
    @allowed_conference_solution_types = []
  end

  def scrape(conference_props_data)
    if types = conference_props_data["allowedConferenceSolutionTypes"]
      @allowed_conference_solution_types = types
    end
  end
end


class Calendar < Parser
  attr_accessor :id, :summary, :time_zone, :conference_properties

  def initialize
    @id = ""
    @summary = ""
    @time_zone = ""
    @conference_properties = ConferenceProperties.new
  end

  def scrape(calendar_data)
    @id = calendar_data["id"] || @id
    @summary = calendar_data["summary"] || @summary
    @time_zone = calendar_data["timeZone"] || @time_zone
    conference_props_data = calendar_data["conferenceProperties"]
    @conference_properties.scrape(conference_props_data) if conference_props_data
  end
end





class CalendarReminder < Parser
  attr_accessor :method, :minutes

  def initialize
    @method = ""
    @minutes = 0
  end

  def scrape(reminder_data)
    @method = reminder_data["method"] || @method
    @minutes = reminder_data["minutes"] || @minutes
  end
end


class CalendarPerson < Parser
  attr_accessor :email, :display_name, :self

  def initialize
    @email = ""
    @display_name = ""
    @self = nil
  end

  def scrape(person_data)
    @email = person_data["email"] || @email
    @display_name = person_data["displayName"] || @display_name
    @self = person_data["self"] unless person_data["self"].nil?
  end
end







class CalendarTime < Parser
  attr_accessor :date_time, :time_zone

  def initialize
    @date_time = nil # Initially set to nil
    @time_zone = ""
  end

  def scrape(time_data)
    if date_time_str = time_data["dateTime"]
      begin
        @date_time = get_datetime_utc(date_time_str)
      rescue ArgumentError
        @date_time = nil
      end
    end
    @time_zone = time_data["timeZone"] || @time_zone
  end
end








class CalendarReminders < Parser
  attr_accessor :use_default, :overrides

  def initialize
    @use_default = 0
    @overrides = []
  end

  def scrape(reminders_data)
    @use_default = reminders_data["useDefault"] || @use_default
    if overrides_data = reminders_data["overrides"]
      overrides_data.each do |reminder_data|
        reminder = CalendarReminder.new
        reminder.scrape(reminder_data)
        @overrides << reminder
      end
    end
  end
end



class CalendarEvent < Parser
  attr_accessor :id, :status, :html_link, :created, :updated, :summary, :description,
                :location, :creator, :organizer, :start, :end, :recurring_event_id,
                :original_start_time, :visibility, :ical_uid, :sequence,
                :guest_can_invite_others, :reminders, :event_type

  def initialize
    @id = ""
    @status = ""
    @html_link = ""
    @created = nil
    @updated = nil
    @summary = ""
    @description = ""
    @location = ""
    @creator = CalendarPerson.new
    @organizer = CalendarPerson.new
    @start = CalendarTime.new
    @end = CalendarTime.new
    @recurring_event_id = ""
    @original_start_time = CalendarTime.new
    @visibility = ""
    @ical_uid = ""
    @sequence = 0
    @guest_can_invite_others = nil
    @reminders = CalendarReminders.new
    @event_type = ""
  end

  def scrape(event_data)
    @id = event_data["id"] || @id
    @status = event_data["status"] || @status
    @html_link = event_data["htmlLink"] || @html_link

    begin
      @created = get_datetime_utc(event_data["created"]) if event_data["created"]
    rescue ArgumentError
      @created = nil
    end

    begin
      @updated = get_datetime_utc(event_data["updated"]) if event_data["updated"]
    rescue ArgumentError
      @updated = nil
    end

    @summary = event_data["summary"] || @summary
    @description = event_data["description"] || @description
    @location = event_data["location"] || @location
    @creator.scrape(event_data["creator"]) if event_data["creator"]
    @organizer.scrape(event_data["organizer"]) if event_data["organizer"]
    @start.scrape(event_data["start"]) if event_data["start"]
    @end.scrape(event_data["end"]) if event_data["end"]
    @recurring_event_id = event_data["recurringEventId"] || @recurring_event_id
    @original_start_time.scrape(event_data["originalStartTime"]) if event_data["originalStartTime"]
    @visibility = event_data["visibility"] || @visibility
    @ical_uid = event_data["iCalUID"] || @ical_uid
    @sequence = event_data["sequence"] || @sequence
    @guest_can_invite_others = event_data["guestsCanInviteOthers"] unless event_data["guestsCanInviteOthers"].nil?
    @reminders.scrape(event_data["reminders"]) if event_data["reminders"]
    @event_type = event_data["eventType"] || @event_type
  end
end






class CalendarEvents < Parser
  attr_accessor :summary, :updated, :time_zone, :access_role, :default_reminders, :next_page_token, :items

  def initialize
    @summary = ""
    @updated = nil # Initially set to nil
    @time_zone = ""
    @access_role = ""
    @default_reminders = []
    @next_page_token = ""
    @items = []
  end

  def scrape(events_data)
    @summary = events_data["summary"] || @summary

    begin
      @updated = get_datetime_utc(events_data["updated"]) if events_data["updated"]
    rescue ArgumentError
      @updated = nil
    end

    @time_zone = events_data["timeZone"] || @time_zone
    @access_role = events_data["accessRole"] || @access_role

    if reminders_data = events_data["defaultReminders"]
      reminders_data.each do |reminder_data|
        reminder = CalendarReminder.new
        reminder.scrape(reminder_data)
        @default_reminders << reminder
      end
    end

    @next_page_token = events_data["nextPageToken"] || @next_page_token

    if items_data = events_data["items"]
      items_data.each do |item_data|
        event = CalendarEvent.new
        event.scrape(item_data)
        @items << event
      end
    end
  end
end

=end
