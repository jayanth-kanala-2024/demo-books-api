class LocaleController < ApplicationController
  def index
    render json: I18n.backend.send(:translations)[I18n.locale]
  end

  def greet
    render json: { navbar: I18n.t }
  end
end
