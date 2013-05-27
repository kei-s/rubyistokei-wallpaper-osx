require 'fileutils'
require 'capybara-webkit'

module Rubyistokei
  SITE_URL = 'http://rubyistokei.herokuapp.com/'
  module Wallpaper
  end
end

class Rubyistokei::Wallpaper::OSX
  class << self
    def run(option = {})
      dir = File.expand_path("../../tmp", __FILE__)
      cleanup(dir) unless option[:no_cleanup]
      file = take_screenshot(dir)
      set_wallpaper(file)
    end

    private
    def take_screenshot(dir)
      driver = Capybara::Webkit::Driver.new('rubyistokei-wallpaper')
      driver.visit Rubyistokei::SITE_URL
      driver.find_css('.tokei-text span[style="visibility: visible;"]')
      sleep 2
      file = File.expand_path("screenshot-#{Time.now.strftime('%m%d%H%M')}.png", dir)
      driver.save_screenshot(file)
      file
    end

    def set_wallpaper(file)
      `osascript -e 'tell application "Finder" to set desktop picture to "#{file}" as POSIX file'`
    end

    def cleanup(dir)
      FileUtils.rm Dir.glob(File.join(dir,'screenshot-*.png'))
    end
  end
end
