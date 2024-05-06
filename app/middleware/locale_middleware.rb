class LocaleMiddleware
    def initialize(app)
      @app = app
    end
  
    def call(env)
      accept_language = env['HTTP_ACCEPT_LANGUAGE']
      if accept_language.present?
        # Parse the Accept-Language header to get the preferred locale
        locale = parse_accept_language_header(accept_language)
        # Set the locale if it's a supported locale
        I18n.locale = locale if I18n.available_locales.map(&:to_s).include?(locale.to_s)
      end
      # Call the next middleware in the chain
      @app.call(env)
    end
  
    private
  
    def parse_accept_language_header(header)
      # Split the Accept-Language header by comma and extract the locales
      locales = header.to_s.scan(/([a-zA-Z\-]{2,10})(?:;q=([\d.]+))?/)
                        .map { |loc, q| [loc, (q || '1').to_f] }
                        .sort_by(&:last)
                        .map(&:first)
      puts locales
      # Return the first locale that is available in your application
      locales.detect { |loc| I18n.available_locales.map(&:to_s).include?(loc) } || I18n.default_locale
    end
  end
  
  