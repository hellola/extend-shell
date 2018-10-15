class OperatingSystem < ApplicationRecord
  has_many :hotkeys
  has_many :aliases
  has_many :functions
  has_many :environments

  def self.find_or_create_for_current
    OperatingSystem.find_or_create_by(name: get_current)
  end

  def self.get_current
    os_info = `cat /etc/*-release`
    info = Util::hashify_linux_style(os_info)
    info['ID_LIKE']
  end
end
