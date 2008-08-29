# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  # Restful Auth Plugin
  include AuthenticatedSystem
  
  # notify of exceptions
  include ExceptionNotifiable if defined? ExceptionNotifiable

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => '679db21358b0d645844f15fd7766b49b'  
  
  include Throttler
  
  before_filter do
    AppConfig.reload!
  end
  
  def check_spam(val)
    if [AppConfig.spam_answer].flatten.include? val.to_s.strip
      return true
    else
      return false
    end
  end
  
  # The following method make sure that you can use method's of Helper in controller
  def helper_controller
    Helper.instance
  end

  class Helper
    include Singleton
    include ActionView::Helpers::TextHelper
  end  
end
