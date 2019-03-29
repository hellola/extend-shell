module ExtendConfig
  def self.window_manager_renderer
    renderer_class =
      if OS.mac?
        Rails.application.config.ext['window_manager']['mac_renderer']
      elsif OS.windows?
        Rails.application.config.ext['window_manager']['windows_renderer']
      elsif OS.linux?
        Rails.application.config.ext['window_manager']['linux_renderer']
      end
    eval "#{renderer_class}Renderer.new"
  end
end
