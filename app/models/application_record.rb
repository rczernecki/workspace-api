class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  # self.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
end
