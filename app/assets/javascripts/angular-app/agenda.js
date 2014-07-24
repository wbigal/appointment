(function(){
	var app = angular.module('agenda',['angular-loading-bar', 'ngAnimate']);

	app.factory('currentEventService', function($rootScope){
		var evento = {};
		evento.updateEvento = function(id, doctor, paciente, motivo, fecha){
        this.id = id;
        this.doctor = doctor;
        this.paciente = paciente;
        this.motivo = motivo;
        this.fecha = fecha;
        $rootScope.$broadcast("valuesUpdated");
    }
    evento.resetEvento = function(){
    	this.id = null;
      this.doctor = null;
      this.paciente = null;
      this.motivo = null;
      this.fecha = null;
  		$rootScope.$broadcast("resetedEvent");    	
  	}
    return evento;
	});

	app.controller('EventController',
								['$http','$scope','currentEventService','messagesService',
								function($http, $scope, currentEventService, messagesService){
		var eventCtrl = this;
		$scope.evento = currentEventService;
		$scope.on_selected_event = false;
		$scope.$on('valuesUpdated', function() {
			$scope.evento = currentEventService;
			$scope.on_selected_event = true;
      $scope.$apply();//this is used bcs is triggered by a jquery code, specific de calendar select
    });
    $scope.$on('resetedEvent', function() {
			$scope.evento = currentEventService;
			$scope.on_selected_event = false;
    });
    eventCtrl.deleteEvent = function(evento_id){
    	$http.delete('/api/eventos/' +evento_id+ '.json').
    		success(function(data, status, headers){    			
    			$('#calendar').fullCalendar('removeEvents', evento_id);
    			currentEventService.resetEvento();
		  		$scope.on_selected_event = false;
		  		messagesService.show_message(data.status, data.message);		  		
	    	}).
	    	error(function(data, status, headers) {
		      messagesService.show_message(data.status, data.message);
		    }); 
    };
	}]);

	app.controller('FilterFormController',
								['$http','currentEventService','messagesService',
								function($http, currentEventService, messagesService){
		var filterForm = this;
		filterForm.doctors = [];
		filterForm.selected_doctor = {};
		filterForm.isLoading = false;
		$http.get('/api/doctors.json').success(function(data){
 			filterForm.doctors = data;
    });
    filterForm.loadCalendar = function(selected_doctor){
    	currentEventService.resetEvento();    	
			filterForm.isLoading = true;
    	if (selected_doctor == undefined || selected_doctor	 == null) {
			  filterForm.selected_doctor = {id:null, full_name: 'Agenda de todos los doctores'};
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
				minTime: '06:00:00',
				lang: 'es',
				axisFormat: 'h:mma',
				firstDay: 1,
				lazyFetching: false,
				defaultView: 'agendaWeek',
				selectable: true,
				selectHelper: true,
				select: function(start, end) {
					var view = $('#calendar').fullCalendar('getView');
					if(view.name == 'month'){
						messagesService.show_message('unprocesable',
						'No se puede crear un evento de esta manera, cambie a la vista semana o día.');
					}
					else{
						if (filterForm.selected_doctor.id) {							
							$('#styledModal').modal('show');
							eventData = {
								title: 'wevooo',
								start: start,
								end: end
							};
							$('#calendar').fullCalendar('renderEvent', eventData, true); // stick? = true
						}else{
							messagesService.show_message('unprocesable',
								'El evento solo puede ser creado para un doctor. Seleccione uno y filtre su agenda.');
							$('#calendar').fullCalendar('unselect');
						}
					}					
				},
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
		    eventClick: function(evento, jsEvent, view) {
		    	currentEventService.updateEvento(evento.id, evento.doctor,evento.paciente,
		    												evento.motivo, evento.start.format('LLL'));
	      }				
			});
    };        
  }]);
	

	app.factory('messagesService', function(){
		var hawl = {};
		hawl.show_message = function(type, message){
			switch(type){
    		case 'error':
    			$.howl ({
						type: 'danger',
						title: 'Error',
						content: message,
						iconCls: 'fa fa-times-circle',
					});    			
    			break;
    		case 'success':
	    		$.howl ({
						type: 'success',
						title: 'Ok',
						content: message,
						iconCls: 'fa fa-check-square-o',
					});
    			break;
    		case 'unprocesable':
    			$.howl ({
						type: 'danger',
						title: 'No procede',
						content: message,
						iconCls: 'fa fa-ban',
					});
    	}
		};
		return hawl;
	});


})();
