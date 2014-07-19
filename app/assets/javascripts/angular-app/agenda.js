(function(){
	var app = angular.module('agenda',['angular-loading-bar']);

	app.controller('FilterFormController',['$http', function($http){
		var filterForm = this;
		filterForm.doctors = [];
		filterForm.selected_doctor = {};
		filterForm.isLoading = false;
		$http.get('/api/doctors.json').success(function(data){
 			filterForm.doctors = data;
    });
    filterForm.loadCalendar = function(selected_doctor){
			filterForm.isLoading = true;
    	if (selected_doctor == undefined || selected_doctor	 == null) {
			  filterForm.selected_doctor = {id:'', full_name: 'Agenda de todos los doctores'};
			}else{
				filterForm.selected_doctor = selected_doctor;
			}
    	$('#calendar').fullCalendar('destroy');	
			$('#calendar').fullCalendar({
				header: {
					left: 'prev,next today',
					center: 'title',
					right: 'month,agendaWeek,agendaDay'
				},
				defaultDate: $(this).data('serverdate'),
				firstDay: 1,
				editable: true,
				lazyFetching: false,
				defaultView: 'agendaWeek',
				loading: function (bool,view) { 
				  if (bool){
				  	filterForm.isLoading = true; 
				  	$("#calendar-container").mask('');
				  }
				  else{
				  	filterForm.isLoading = false;
				  	$("#calendar-container").unmask();
				  }
				},
				events: {
		        url: '/api/eventos',
		        type: 'GET',
		        data: function() { // a function that returns an object
		            return {
		                doctor_id: filterForm.selected_doctor.id,
		            };
		        },
		        error: function() {
		            alert('there was an error while fetching events!');
		        },
		    },				
			});
    };        
  }]);
})();
