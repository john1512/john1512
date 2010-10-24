class Help < ActiveRecord::Base

  acts_as_indexed :fields => [:content]
  


end
