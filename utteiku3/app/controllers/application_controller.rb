class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: :valid_api_request?

  private

  def valid_api_request?
    # FIXME need authentication for realworld application
    request.format.json?
  end
end
