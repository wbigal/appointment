json.current_page @users.current_page
json.per_page @users.per_page
json.total_pages @users.total_pages
json.offset @users.offset
json.users do
	json.array!(@users) do |user|
		json.id user.id
		json.dni user.dni
		json.full_name user.full_name
	  json.color user.color
	  json.superadmin booleano? user.superadmin
	  json.admin booleano? user.admin
	  json.doctor booleano? user.doctor
	  json.deshabilitado banned? user.deshabilitado
	end
end