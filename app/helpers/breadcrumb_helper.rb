module BreadcrumbHelper
  def ensure_navigation
    @navigation ||= []
  end

  def breadcrumb_add(title, url)
    ensure_navigation << { :title => title, :url => url }
  end

  def render_breadcrumb
    render :partial => 'shared/breadcrumb', :locals => { :nav => ensure_navigation }
  end
end