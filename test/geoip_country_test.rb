require 'test/unit'
require 'ipaddr'
require 'geoip'

class GeoIPCountryTest < Test::Unit::TestCase
  UNITED_STATES_IP = '199.223.122.118'
  LOCAL_IP = '127.0.0.1'

  def setup
    @db = GeoIP::Country.open
  end

  def teardown
    @db.close
  end

  def test_country_code_by_addr
    assert_equal "US", @db.country_code_by_addr(UNITED_STATES_IP),
      "Lookup by IP String failed"

    assert_equal "US", @db.country_code_by_addr(IPAddr.new(UNITED_STATES_IP)),
      "Lookup by IPAddr failed"

    assert_nil @db.country_code_by_addr(LOCAL_IP)
  end

  def test_country_code3_by_addr
    assert_equal "USA", @db.country_code3_by_addr(UNITED_STATES_IP),
      "Lookup by IP String failed"

    assert_equal "USA", @db.country_code3_by_addr(IPAddr.new(UNITED_STATES_IP)),
      "Lookup by IPAddr failed"

    assert_nil @db.country_code3_by_addr(LOCAL_IP)

  end

  def test_country_name_by_addr
    assert_equal "United States",
      @db.country_name_by_addr(UNITED_STATES_IP),
      "Lookup by IP String failed"

    assert_equal "United States",
      @db.country_name_by_addr(IPAddr.new(UNITED_STATES_IP)),
      "Lookup by IPAddr failed"

    assert_nil @db.country_name_by_addr(LOCAL_IP)
  end
end
