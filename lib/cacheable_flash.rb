module CacheableFlash
  def self.included(base)
    base.around_filter :write_flash_to_cookie
  end

  def write_flash_to_cookie
    yield if block_given?
    cookie_flash = if cookies['flash']
      begin
        JSON.parse(cookies['flash'])
      rescue JSON::ParserError
        {}
      end
    else
      {}
    end

    flash.each do |key, value|
      if cookie_flash[key.to_s].blank?
        cookie_flash[key.to_s] = value
      else
        cookie_flash[key.to_s] << "<br/>#{value}"
      end
    end

    cookies['flash'] = cookie_flash.to_json
    flash.clear
  end
end
