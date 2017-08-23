module ::Proxy::Dns::Dnsmasq
  class PluginConfiguration
    def load_classes
      require 'dns_common/dns_common'
      require 'smart_proxy_dns_dnsmasq/dns_dnsmasq_main'
    end

    BACKENDS = %i(openwrt default).freeze
    def load_dependency_injection_wirings(container_instance, settings)
      backend = settings[:backend] || :default
      backend = backend.to_s.downcase.to_sym

      unless BACKENDS.include? backend
        raise ::Proxy::Error::ConfigurationError, "Unknown DNS backend #{backend}, available backends are; #{BACKENDS}"
      end

      begin
        require "smart_proxy_dns_dnsmasq/backend/#{backend}"
      rescue LoadError, e
        raise ::Proxy::Error::ConfigurationError, e, "Failed to load #{backend} backend"
      end

      klass = case backend
              when :openwrt
                ::Proxy::Dns::Dnsmasq::Openwrt
              when :default
                ::Proxy::Dns::Dnsmasq::Default
              end

      container_instance.dependency :dns_provider, (lambda do
        klass.new(
          settings[:config_path],
          settings[:reload_cmd],
          settings[:dns_ttl]
        )
      end)
    end
  end
end
