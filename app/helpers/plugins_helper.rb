module PluginsHelper
  def install_plugin(plugin)
    if plugin.installed?(current_account)
      button_to_remote "Disable this plugin", :url => plugin_installation_path(plugin), :method => 'delete'
    else
      button_to_remote "Enable this plugin", :url => plugin_installation_path(plugin), :method => 'post'
    end
  end
  
  def install_plugins_source
    plugins = current_account.installed_plugins.map do |plugin|
      "
Talker.Plugin_#{plugin.id} = function(){ // #{plugin.name} by #{plugin.author.name}
  var plugin = this;
  
  try{
    #{plugin.source}
  } catch(e){
    Talker.error(e, \"#{plugin.name}\");
  }
}
"
    end
    
    plugins.join("\n")
  end
  
  # temporary... just for testing.
  def install_plugins
    plugins = current_account.installed_plugins.map do |plugin|
      "Talker.plugins.push(new Talker.Plugin_#{plugin.id}());"
    end
    
    plugins.join("\n")
  end
  
  def render_events(events)
   "$.each(#{escape_json @events.to_json}, function(){ Talker.Broadcaster.broadcastEvent(this); });"
  end
  
  def render_events_for_logs(events)
"
var talker_events = #{escape_json @events.to_json};

var loading_interval = window.setInterval(function(){
  Talker.Broadcaster.broadcastEvent(talker_events.shift())
  if (talker_events.length == 0){
    window.clearInterval(loading_interval);
  }
}, 0);
    "
  end
end
