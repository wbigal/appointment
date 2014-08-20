module UsersHelper	
  def banned?(bool)
    bool ? 'Deshabilitado' : 'Habilitado'
  end
  def options_for_abreviacion
  	%w[Odon. Dr. Dra. Lic. Obs. Enf.]
  end
  def color_picker_colors
  	%w[#69D2E7 #A7DBD8 #E0E4CC #F38630 #FA6900
  		 #ECD078 #D95B43 #C02942 #542437 #53777A #556270
			 #4ECDC4 #C7F464 #FF6B6B #C44D58 #547980 #45ADA8
			 #9DE0AD #CBE86B #FF4E50 #FC913A #F9D423 #EDE574]
  end
end