class Activity < ApplicationRecord
  belongs_to :activity_group

  scope :for_today, -> { where('time_activated between ? and ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day) }
  scope :for_last_hour, -> {where('time_activated between ? and ?', DateTime.now - 1.hour, DateTime.now)  }
  scope :for_this_week, -> { where('time_activated between ? and ?', DateTime.now.beginning_of_week, DateTime.now.end_of_week) }

  def self.for_day(day)
    where('time_activated between ? and ?', day.beginning_of_day, day.end_of_day)
  end

  def self.except_idle
    idle = ActivityGroup.find_by(name: "idle")
    where.not(activity_group: idle)
  end

  def self.usage_per_group
    joins(:activity_group).
      select("activity_groups.name, sum(julianday(time_deactivated) - julianday(time_activated)) as duration").
      group("activity_groups.name").
      reject { |a| (a['duration'] || 0).zero? }.
      map { |a| [a['name'], (a['duration'] * 24 * 60 * 60).floor] }
  end

  def self.percentize(usage)
    total = usage.sum { |name, duration| duration }
    usage = usage.reject { |name, duration| duration.zero? }
    [total, usage.map { |name, duration| [name, ((duration / total) * 100).floor] }]
  end

  def self.latest_for_host(host)
    Activity.where(host: host).order(time_activated: :desc).first
  end

  def duration
    return 0 if time_deactivated.nil?
    time_deactivated - time_activated
  end

  def activity_group_name
    activity_group&.name
  end

  def same_as?(other)
    return -1 if other.nil?
    return -1 unless other.class == Activity
    title == other.title &&
      host == other.host &&
      application == other.application
  end
end
