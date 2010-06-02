require 'ffi'

module GeoIP
  module C
    extend FFI::Library
    ffi_lib 'GeoIP'
    
    class GeoIP < FFI::Struct
    end
    
    class GeoIPRegion < FFI::Struct
    end
    
    def flag_to_i(opt)
      case opt
      when Integer then opt
      when :standard then 0
      when :memory_cache then 1
      when :check_cache then 2
      when :index_cache then 4
      when :mmap_cache then 8
      end
    end
    module_function :flag_to_i
    
    def flags_to_i(flags)
      flags.inject(0) { |a,b| a & flag_to_i(b) }
    end
    module_function :flags_to_i

    enum :dbtype, [
      :country,      1,
      :city_rev1,    2,
      :region_rev1,  3,
      :isp,          4,
      :org,          5,
      :city,         6,
      :region,       7,
      :proxy,        8,
      :asnum,        9,
      :netspeed,    10,
      :domain,      11,
      :country_v6,  12,
    ]
    
    attach_function :GeoIP_setup_custom_directory, [:char], :void
    attach_function :GeoIP_open_type , [:dbtype, :int], :pointer
    attach_function :GeoIP_new, [:int], :pointer
    attach_function :GeoIP_open, [:string, :int], :pointer
    attach_function :GeoIP_db_avail, [:int], :int
    attach_function :GeoIP_delete, [:pointer], :void
    attach_function :GeoIP_country_code_by_addr, [:pointer, :string], :string
    attach_function :GeoIP_country_code_by_name, [:pointer, :string], :string
    attach_function :GeoIP_country_code3_by_addr, [:pointer, :string], :string
    attach_function :GeoIP_country_code3_by_name, [:pointer, :string], :string
    attach_function :GeoIP_country_name_by_addr, [:pointer, :string], :string
    attach_function :GeoIP_country_name_by_name, [:pointer, :string], :string
    attach_function :GeoIP_country_name_by_ipnum, [:pointer, :ulong], :string
    attach_function :GeoIP_country_code_by_ipnum, [:pointer, :ulong], :string
    attach_function :GeoIP_country_code3_by_ipnum, [:pointer, :ulong], :string
    
    attach_function :GeoIP_country_name_by_ipnum_v6, [:pointer, :uint32], :string
    attach_function :GeoIP_country_code_by_ipnum_v6, [:pointer, :uint32], :string
    attach_function :GeoIP_country_code3_by_ipnum_v6, [:pointer, :uint32], :string
  end
  
  class Country
    def self.open(*flags)
      db = new(*flags)
      if block_given?
        yield db
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
    
    def delete
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
