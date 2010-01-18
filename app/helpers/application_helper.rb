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
  def rulings_path(options = {})
    rulings_url(options.merge({:only_path => true}))
  end
  
  # TODO: remove once
  # https://rails.lighthouseapp.com/projects/8994/tickets/3730
  # is resolved.
  def rulings_url(options)
    url_for({:controller => :rulings, :action => :create}.merge(options))
  end
  
end
