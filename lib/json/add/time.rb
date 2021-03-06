unless defined?(::JSON::JSON_LOADED) and ::JSON::JSON_LOADED
  require 'json'
end

# Time serialization/deserialization
class Time

  # Deserializes JSON string by converting time since epoch to Time
  def self.json_create(object)
    if usec = object.delete('u') # used to be tv_usec -> tv_nsec
      object['n'] = usec * 1000
    end
    if respond_to?(:tv_nsec)
      at(*object.values_at('s', 'n'))
    else
      at(object['s'], object['n'] / 1000)
    end
  end

  # Returns a hash, that will be turned into a JSON object and represent this
  # object.
  def as_json(*)
    {
      JSON.create_id => self.class.name,
      's'            => tv_sec,
      'n'            => respond_to?(:tv_nsec) ? tv_nsec : tv_usec * 1000
    }
  end

  # Stores class name (Time) with number of seconds since epoch and number of
  # microseconds for Time as JSON string
  def to_json(*args)
    as_json.to_json(*args)
  end
end
