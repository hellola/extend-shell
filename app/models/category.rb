class Category < ApplicationRecord
  has_and_belongs_to_many :aliases
  has_and_belongs_to_many :functions
  has_and_belongs_to_many :hotkeys
end
