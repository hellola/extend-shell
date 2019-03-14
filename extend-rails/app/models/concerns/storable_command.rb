module StorableCommand
  extend ActiveSupport::Concern

  included do
    belongs_to :location
    belongs_to :operating_system
    scope :with_location, -> { joins(:location) }
    has_and_belongs_to_many :categories
    after_initialize :init

    def init
      default_location = Location.find_or_create_by(path: nil, host: nil)
      self.location_id ||= default_location
    end

    def self.for_path(path)
      joins(:location).where('locations.path = ? OR locations.path = \'\' OR locations.path IS NULL', path)
    end

    def self.for_os(os)
      where('operating_systems.name = ?', os)
    end

    def self.load_all(options = {})
      path = options[:path]
      os = OperatingSystem.get_current
      categories = options[:categories]
      storables = self.joins(:location).joins(:operating_system).with_possible_categories(categories).for_path(path).for_os('all').order(:name)
      os_only_storables = self.joins(:location).joins(:operating_system).with_possible_categories(categories).for_path(path).for_os(os).order(:name)
      storables = self.remove_duplicate_os(storables, os_only_storables)
      results = storables.map { |a| a.render }
      results.reject { |a| a.nil? || a.empty? }
    end

    def self.load_names(options = {})
      path = options[:path]
      type = options.fetch(:type, nil)
      os = OperatingSystem.get_current
      categories = options[:categories]
      storables = self.joins(:location).joins(:operating_system).with_possible_categories(categories).for_path(path).for_os('all')
      storables = storables.where(hotkey_type: type) if type.present?
      storables = storables.order(:name)
      os_only_storables = self.joins(:location).joins(:operating_system).with_possible_categories(categories).for_path(path).for_os(os)
      os_only_storables = os_only_storables.where(hotkey_type: type) if type.present?
      os_only_storables = os_only_storables.order(:name)
      storables = self.remove_duplicate_os(storables, os_only_storables)
      storables.map do |a|
        second = ",#{a.full_key}" if a.respond_to?(:full_key)
        "#{a.shortcut}-#{a.name}#{second}"
      end
    end

    def self.remove_duplicate_os(storables, os_only_storables)
      # if an os_specific storable exists, don't use the generic one
      os_only_names = os_only_storables.map { |s| s.name }
      os_filtered_storables = os_only_storables.to_a
      storables.each do |storable|
        os_filtered_storables << storable unless os_only_names.include? storable.name
      end
      os_filtered_storables
    end

    def self.list_all(categories = nil)
      storables = with_possible_categories(categories).order(:name)
      storables = storables.map do |a|
        a.to_s
      end
      return storables
    end

    def apply_global_options(options)
      os_specific = options.fetch(:'os-only', false)
      if os_specific
        self.operating_system = OperatingSystem.find_or_create_for_current
      else
        self.operating_system = OperatingSystem.find_or_create_by(name: 'all')
      end
    end

    def self.with_possible_categories(categories = nil)
      if !categories.nil?
        cats = categories.split(' ')
        storables = self.joins(:categories).where(categories: { name:  cats })
      else
        storables = self.all
      end
      storables
    end

  end


end
