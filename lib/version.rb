module Profiles
  class Version
    include Comparable

    attr :str, :type
    attr :major, :minor, :patch

    # http://semver.org/
    #java > 1.3.0: http://www.oracle.com/technetwork/java/javase/versioning-naming-139433.html
    def <=>(anOther)
      return major <=> anOther.major unless (major <=> anOther.major) == 0
      return minor <=> anOther.minor unless (minor <=> anOther.minor) == 0
      return patch <=> anOther.patch unless (patch <=> anOther.patch) == 0
    end

    def match(anOther)
      return true if anOther.major == '*'
      return true if (major <=> anOther.major) == 0 && anOther.minor == '*'
      return major <=> anOther.major unless (major <=> anOther.major) == 0
      return minor <=> anOther.minor unless (minor <=> anOther.minor) == 0
      return true
    end

    def unify
      if major

        return major << '.' << minor
      else
        return 'Unknown'
      end
    end

    def initialize(str, type=nil)
      @type = type
      # auto match type of version
      # define language and only use this schema
      # define wildcard
      @str = str
      arr = /^((\*|\d+)\.)?((\*|\d+)\.)?(\*|\d+)$/.match(@str)[0].split('.')
      @major = arr[0]
      @minor = arr[1]

    rescue
      # ignore
    end

    def latest?
      result = Runtime.where(name: type).first
      latest = result['version'] unless result.nil?
      return true unless /#{@str}/.match(latest).nil?
      false
    end

    def self.latest language
      result = Runtime.where(name: language).first
      return result['version'] unless result.nil?
      'unknown'
    end

    def inspect
      @str
    end
  end
end
