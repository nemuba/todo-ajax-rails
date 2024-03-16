I18n::Backend::Simple.include(I18n::Backend::Pluralization)
I18n::Backend::Simple.include(I18n::Backend::Fallbacks)

I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]

I18n.backend.class.send(:include, I18n::Backend::Fallbacks)
I18n.fallbacks.map(:"pt-BR" => [:pt])

I18n.default_locale = :"pt-BR"
