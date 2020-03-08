# Preferences class for use in TextMate commands/bundles.
#
# Offers a hash interface for data that is persisted in a YAML file in the user's preference dir.
# See http://henrik.nyh.se/2007/06/preferences-class-for-textmate-commands for more information.
#
# By Henrik Nyh <http://henrik.nyh.se> 2007-06-27
# Free to modify and redistribute with credit.

class Preferences
  %w{yaml fileutils}.each { |lib| require lib }
  
  # Each preference id should be a singleton

  @@instances = {}

  class << self; private :new; end

  def self.[](id)
    raise(ArgumentError, "Preference id must match /\A[a-zA-Z0-9_]+\Z/.") unless id.to_s =~ /\A\w+\Z/
    @@instances[id.to_sym] ||= new(id)
  end
  
  def initialize(id)
    @id = id.to_s
  end
  
  # Singleton code ends
    
  def [](key)
    value = to_hash[key.to_sym]
  end
  
  def []=(key, value)
    merge!({key => value})
    value
  end
  
  def merge!(new_hash)
    symbolized_keys = new_hash.inject({}) { |h, (k, v)| h[k.to_sym] = v; h }
    @hash = to_hash.merge(symbolized_keys)
    persist!
  end
  
  def delete(key)
    key = key.to_sym
    value = self[key]
    @hash.delete(key)
    persist!
    value
  end
  
  def clear!
    File.delete(path) if File.exist?(path)
    flush_cache!
  end
    
  def flush_cache!
    @hash = nil
  end
  
  def to_hash
    @hash ||= YAML.load_file(path) rescue {}
  end
  
private

  def path
    "#{ENV['HOME']}/Library/Preferences/com.macromates.textmate.#{@id}.yaml"
  end
  
  def persist!
    File.open(path, "w") { |out| YAML.dump(@hash, out) }
    @hash
  end
  
end


# The rest is unit tests, which you don't have to include in your command or bundle.

if __FILE__ == $0
      
  require "test/unit"
  
  class TextMatePreferencesTest < Test::Unit::TestCase
    
    def assert_simultaneous(one, two)
      assert_equal one.to_i, two.to_i
    end
    
    def assert_stored(data, method = :assert_equal)
      Preferences[:test][:key] = data
      send(method, data, Preferences[:test][:key])  # From cache
      Preferences[:test].flush_cache!
      send(method, data, Preferences[:test][:key])  # Loaded from plist
    end
    
    def setup
      Preferences[:test].clear!
    end
    
    def teardown
      Preferences[:test].clear!
    end

    def test_is_singleton
      assert_equal     Preferences[:test], Preferences[:test]
      assert_not_equal Preferences[:test], Preferences[:test2]
    end
    
    def test_accepts_filenameable_preference_ids
      ['a', 'abcd', '1', 'ab34', '_', 'ab34_'].each do |id|
        assert_nothing_raised(ArgumentError) { Preferences[id] }
      end
    end
    
    def test_doesnt_accept_weird_preference_ids
      [nil, '', ' ', :' ', '!'].each do |id|
        assert_raise(ArgumentError) { Preferences[id] }
      end
    end
    
    def test_undefined_values_are_nil
      assert_equal nil, Preferences[:test][:foo]
    end
    
    def test_symbol_and_string_ids_and_keys_are_equivalent
      Preferences[:test][:foo] = "bar"
      assert_equal Preferences[:test][:foo], Preferences["test"]["foo"]
    end

    def test_can_persist_ints_floats_nil_bools_strings_symbols_nested_arrays_and_hashes
      data = [-1, 0, 1, 1.5, nil, true, false, [[["a"], "nested"], ["array!"]], {:foo => :bar}]
      assert_stored data
    end
    
    def test_can_persist_times
      # We need assert_simultaneous since assert_equal(Time.now, Time.now) is false
      assert_stored Time.now,  :assert_simultaneous
    end
    
    def test_can_delete
      Preferences[:test][:foo] = "foo"
      Preferences[:test][:bar] = "bar"
      assert_equal({:foo => "foo", :bar => "bar"}, Preferences[:test].to_hash)
      Preferences[:test].delete(:foo)
      Preferences[:test].flush_cache!
      assert_equal({:bar => "bar"}, Preferences[:test].to_hash)
    end
    
  end

end
