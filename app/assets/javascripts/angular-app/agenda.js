(function(){
	var app = angular.module('agenda',['angular-loading-bar', 'ngAnimate']);
	//sends the authenticity token on all request
	app.config([
	  "$httpProvider", function($httpProvider) {
	    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
	  }
	]);
	app.factory('currentEventService', function($rootScope){
		var evento = {};
		evento.updateEvento = function(id, doctor, paciente, motivo, fecha,jquery_generated){
        this.id = id;
        this.doctor = doctor;
        this.paciente = paciente;
        this.motivo = motivo;
        this.fecha = fecha;
        this.jquery_generated = jquery_generated;
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

	app.factory('newEventService', function($rootScope){
		var new_evento = {};
		new_evento.newEvento = function(start_time,end_time,doctor_id,doctor_name){
        this.doctor_id = doctor_id;
        this.doctor_name = doctor_name;
        this.start = start_time;
        this.end = end_time;
        this.formated_start = moment(start_time).format('LLL');
        this.formated_end = moment(end_time).format('LLL');
        this.paciente_id = null;
        this.paciente_name = null;
        this.motivo = null;
        this.id = null;
				$rootScope.$broadcast("newEventCreated");
    }
    return new_evento;
	});

	app.controller('newEventController',
								['$http','$scope','currentEventService','messagesService', 'newEventService',
								function($http, $scope, currentEventService,
												 messagesService, newEventService){						
		$scope.$on('newEventCreated', function() {
			$scope.new_evento = newEventService;
			currentEventService.resetEvento();
  		$scope.$apply();//this is used bcs is triggered by a jquery code, specific de calendar select
    	$('#newEventModal').modal('show');
    	$('#newEventModal').on('hidden.bs.modal', function (e) {
			  //para resetear los valores cuando se oculte el modal
			  $scope.new_evento = {}
    		$scope.errors = {}
    		$('#buscar_paciente').val('');
			});
    	$('#buscar_paciente').autocomplete({
	      serviceUrl: '/api/buscar/pacientes',
	      minChars: 3,
	      dataType: 'json',
	      onInvalidateSelection: function () {
	      	$scope.new_evento.paciente_name = null;
	        $scope.new_evento.paciente_id = null;
	        $('#buscar_paciente').val('');
	      },
	      onSelect: function (suggestion) {
	        $scope.new_evento.paciente_name = suggestion.value;
	        $scope.new_evento.paciente_id = suggestion.data;
	      },
	      transformResult: function(response) {
	        return {
	            suggestions: $.map(response, function(paciente) {
	                return { value: paciente.full_name,
	                       data: paciente.id,dni: paciente.dni };
	            })
	        };
	      },
	      showNoSuggestionNotice: true,
	      noSuggestionNotice: 'Sin resultados...'
		  });
    });
    $scope.createEvent = function(){
    	$scope.is_loading = true;
    	var data = { evento: $scope.new_evento }
    	$http.post('/api/eventos.json', data).
    		success(function(data, status, headers){
    			var created_event = data.data.evento
    			//oculta modal
    			$('#newEventModal').modal('hide');
    			//muestra mensage
    			messagesService.show_message(data.status, data.message);
    			//renderiza nuevo envento en calendario
    			$('#calendar').fullCalendar('renderEvent', created_event, false); // stick? = true
    			//muestrael nuevo evento creado en current_Event
    			currentEventService.updateEvento(created_event.id, created_event.doctor,
    												created_event.paciente, created_event.motivo,
    												moment(created_event.start).format('LLL'),
    												false);   			
    			//falta clear el input para autocomplete
    			$scope.is_loading = false;
	    	}).
	    	error(function(data, status, headers){
	    		if(status == '400'){
	    			messagesService.show_message(data.status, data.message);
	    		}
	    		else if(status == '422'){
	    			$scope.errors = data.data.errors;
	    		}
	    		else if(status == '401'){
	    			messagesService.show_message(data.status, data.message);
	    		}
	    		$scope.is_loading = false;
		  });
    }					
	}]);

	app.controller('EventController',
								['$http','$scope','currentEventService','messagesService',
								function($http, $scope, currentEventService, messagesService){
		var eventCtrl = this;
		$scope.evento = currentEventService;
		$scope.on_selected_event = false;
		$scope.$on('valuesUpdated', function() {
			$scope.evento = currentEventService;
			$scope.on_selected_event = true;
			if($scope.evento.jquery_generated){ // only triggered by non-angular events
      	$scope.$apply();//this is used bcs is triggered by a jquery code, specific de calendar select
    	};
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
								['$http','currentEventService','messagesService','newEventService',
								function($http, currentEventService, messagesService, newEventService){
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
			  filterForm.selected_doctor = {id:null, full_name: 'Agenda de todos los doctores',
			  															color:'black'};
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
				selectable: $('#calendar').data('selectable'),
				selectHelper: true,
				eventColor: filterForm.selected_doctor.color,
				select: function(start, end) {
					var view = $('#calendar').fullCalendar('getView');
					if(view.name == 'month'){
						messagesService.show_message('unprocesable',
						'No se puede crear un evento de esta manera. Cambie a la vista semana o día.');
					}
					else{
						if (filterForm.selected_doctor.id) {
							newEventService.newEvento(start.format(),end.format(),filterForm.selected_doctor.id,
							filterForm.selected_doctor.full_name);
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
		            messagesService.show_message('error', 'Something went wrong.');
		        },
		    },
		    eventClick: function(evento, jsEvent, view) {
		    	currentEventService.updateEvento(evento.id, evento.doctor,evento.paciente,
		    												evento.motivo, evento.start.format('LLL'), true);
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