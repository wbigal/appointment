module UsersHelper	
  def banned?(bool)
    bool ? 'Deshabilitado' : 'Habilitado'
  end
  def options_for_abreviacion
  	%w[Odon. Dr. Dra. Lic. Obs. Enf.]
  end
end