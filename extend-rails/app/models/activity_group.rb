class ActivityGroup < ApplicationRecord
  has_many :activities

  def self.scratch_group_lookup
    {
      "-tb-tennis-betting-" => ActivityGroup.find_or_create_by(name: "tennis"),
      "-tb-tennis-staging-" => ActivityGroup.find_or_create_by(name: "tennis"),
      "-es-extend-shell-" => ActivityGroup.find_or_create_by(name: "extend"),
    }
  end

  def self.determine_for_activity(name: name, activity:)
    if activity.application == "termite.Termite" &&
       activity.title.downcase.include?("scratch")
      title_parts = activity.title.split(" ")
      found = scratch_group_lookup[title_parts[2]]
      return found if found.present?
    end
    ActivityGroup.find_or_create_by(name: name)
  end

  def self.title_search(title)
    ActivityGroup.all
  end

  def merge_from(other)
    other.activities.update_all(activity_group_id: id)
    other.destroy
  end
end
