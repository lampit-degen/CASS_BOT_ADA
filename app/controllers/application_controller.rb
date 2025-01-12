class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :hex_to_ascii

  def hex_to_ascii(hex_string)
    # Convert the hex string into an array of bytes and then to a string
    hex_string.scan(/../).map(&:hex).pack('C*')
  end
end
