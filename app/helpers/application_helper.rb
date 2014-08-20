module ApplicationHelper
  def full_title(page_title)
    base_title = 'Clinicas Libres'
    if page_title.empty?
      return base_title
    else
      return "#{base_title} | #{page_title}"  
    end
  end

  def booleano?(bool)
    bool ? 'SI': 'NO'
  end
	#for devise
	def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
