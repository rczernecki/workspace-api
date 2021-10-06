class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  # self.verbose_query_logs = true
  self.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
end
