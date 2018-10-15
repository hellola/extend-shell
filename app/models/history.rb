class History < ApplicationRecord
  belongs_to :location
  scope :with_location, -> { joins(:location) }

  def self.list_all(path)
    History.with_location.where(locations: { path: path }).map { |h| h.render }
  end

  def render
    command
  end

  def self.create_from_raw(command, path, global_options)
    History.create(command: command.strip, location: Location.find_or_create_from_path(path))
  end

  def self.load_all(options = {})
    path = options[:path]
    History.with_location.where(locations: { path: path }).map { |h| h.render }
  end

  def to_s
    "#{command}\t#{location.path}\t#{created_at}"
  end

end
