# Defines methods used between project items
module Mixins::ProjectItem
  
  # Autowire associations with project and user
  def self.included(base)
    base.class_eval do 
      # add project dependencies
      belongs_to :project, :counter_cache => true

      # add owner dependencies
      belongs_to :owner, :class_name => "User", :foreign_key => "owner_id"
      
      attr_accessor :antispam
      
      # add activity creation for create/update
      after_save do |record|
        if record.project and record.project.is_submitted?
          Activity.create_from(record)
        end
      end
      
      # add activity creation on delete
      after_destroy do |record|
        if record.project and record.project.is_submitted?
          Activity.create_from(record)
        end
      end
    end    
  end
  
  # Define ownership method
  def owned_by?(user)
    return false unless user.is_a? User
    # return true if user owns the item || return true if user owns the project
    (self.owner_id == user.id) || (self.project and self.project.owned_by?(user))
  end
  
  # check if a project item is spam
  def is_spam?
    self.owner and self.owner.spammer?
  end
  
  
end