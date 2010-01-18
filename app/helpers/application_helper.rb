module ApplicationHelper
  
  # TODO: remove once
  # https://rails.lighthouseapp.com/projects/8994/tickets/3730
  # is resolved.
  def inquests_path(options = {})
    inquests_url(options.merge({:only_path => true}))
  end
  
  # TODO: remove once
  # https://rails.lighthouseapp.com/projects/8994/tickets/3730
  # is resolved.
  def inquests_url(options)
    url_for({:controller => :inquests, :action => :create}.merge(options))
  end
  
  # TODO: remove once
  # https://rails.lighthouseapp.com/projects/8994/tickets/3730
  # is resolved.
  def inquest_rulings_path(inquest, options = {})
    inquest_rulings_url(inquest, options.merge({:only_path => true}))
  end
  
  # TODO: remove once
  # https://rails.lighthouseapp.com/projects/8994/tickets/3730
  # is resolved.
  def inquest_rulings_url(inquest, options)
    url_for({:controller => :rulings, :action => :create, :inquest_id => inquest}.merge(options))
  end
  
end
