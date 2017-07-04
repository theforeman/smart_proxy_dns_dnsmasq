require 'test_helper'
require 'smart_proxy_dns_dnsmasq/dns_dnsmasq_configuration'
require 'smart_proxy_dns_dnsmasq/dns_dnsmasq_plugin'

class DnsDnsmasqDefaultSettingsTest < Test::Unit::TestCase
  def test_default_settings
    Proxy::Dns::Dnsmasq::Plugin.load_test_settings({})
    assert_equal "/etc/dnsmasq.d/foreman.conf", Proxy::Dns::Dnsmasq::Plugin.settings[:config_path]
    assert_equal "systemctl restart dnsmasq", Proxy::Dns::Dnsmasq::Plugin.settings[:reload_cmd]
  end
end
