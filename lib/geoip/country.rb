module GeoIP
  class Country
    def self.open(*flags)
      db = new(*flags)
      if block_given?
        yield db
        db.close
      else
        return db
      end
    end

    def initialize(*flags)
      @ptr = C.GeoIP_open_type(:country, C.flags_to_i(flags))
    end
    
    def to_ptr
      @ptr
    end
    
    def close
      C.GeoIP_delete(@ptr)
    end
    
    def country_code_by_addr(addr)
      C.GeoIP_country_code_by_addr(@ptr, addr.to_s)
    end
    
    def country_code_by_name(name)
      C.GeoIP_country_code_by_name(@ptr, name)
    end
    
    def country_code3_by_addr(addr)
      C.GeoIP_country_code3_by_addr(@ptr, addr.to_s)
    end
    
    def country_code3_by_name(name)
      C.GeoIP_country_code3_by_name(@ptr, name)
    end
    
    def country_name_by_addr(addr)
      C.GeoIP_country_name_by_addr(@ptr, addr.to_s)
    end
    
    def country_name_by_name(name)
      C.GeoIP_country_name_by_name(@ptr, name)
    end
    
    def country_name_by_ipnum(n)
      C.GeoIP_country_name_by_ipnum(@ptr, n)
    end
    
    def country_code_by_ipnum(n)
      C.GeoIP_country_code_by_ipnum(@ptr, n)
    end
    
    def country_code3_by_ipnum(n)
      C.GeoIP_country_code3_by_ipnum(@ptr, n)
    end
  end
end
