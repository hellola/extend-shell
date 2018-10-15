class Location < ApplicationRecord
  def dirname
    path&.split('/')&.last
  end

  def name
    return "all" if host.nil? && dirname.nil?
    "#{host} #{dirname}"
  end

  def self.find_or_create_from_path(path)
    has_many :aliases
    has_many :functions
    host = Util::hostname
    Location.find_or_create_by(host: host, path: path)
  end
end
