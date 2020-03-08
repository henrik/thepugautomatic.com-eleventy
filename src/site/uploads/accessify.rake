excluded_setters  = %w[id [] attributes]
excluded_suffixes = %w[count ids] 

usage = "Specify model like 'rake accessify MODEL=user'."

desc "Outputs an attr_accessible statement with all setters except for those that typically are not for mass assigment, like *_count, *_ids and {created,updated}_{at,on}. #{usage} Note that this task is only meant to save the effort of typing in attributes manually; it does not make any security decisions for you. Read through the generated list of attributes very carefully and remove those that should not be available to mass assignment."
task :accessify => :environment do

  begin
    model = ENV['MODEL'].downcase.classify.constantize
  rescue
    raise "No such model! #{usage}"
  end

  methods = (model.instance_methods - Object.instance_methods).grep(/=$/).map(&:chop)
  columns = model.column_names
  setters = methods | columns
  setters.reject! do |setter|
    setter.match(/_#{ Regexp.union(*excluded_suffixes) }$/) || 
    setter.match(/(created|updated)_(at|on)/) || 
    excluded_setters.include?(setter)
  end
  setters = setters.sort.map(&:to_sym).map(&:inspect).join(', ')
  puts "attr_accessible #{ setters }"
  
end
