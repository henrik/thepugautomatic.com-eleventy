# Makes ActiveRecord raise when an attempt is made to mass-assign an attribute
# protected by attr_protected/attr_accessible, instead of silently leaving that 
# attribute unchanged. This makes it far easier to spot dud assignments.
#
# In production, the error is logged, not raised, since the end user shouldn't
# pay for your sloppy code. :)

class ActiveRecord::ProtectedAttributeAssignmentError < ActiveRecord::ActiveRecordError; end

module WhinyProtectedAttributes
  
  def self.included(base)
    base.alias_method_chain :remove_attributes_protected_from_mass_assignment, :whine
  end
  
  def remove_attributes_protected_from_mass_assignment_with_whine(attributes)
    safe_attributes = remove_attributes_protected_from_mass_assignment_without_whine(attributes)
    removed_attributes = attributes.keys - safe_attributes.keys
    unless removed_attributes.empty?
      error_message = "Can't mass-assign these attributes: #{ removed_attributes.join(', ') }"
      if ENV['RAILS_ENV'] == 'production'
        logger.error error_message
      else
        raise ActiveRecord::ProtectedAttributeAssignmentError, error_message
      end
    end
    safe_attributes
  end
  
end

ActiveRecord::Base.send :include, WhinyProtectedAttributes
