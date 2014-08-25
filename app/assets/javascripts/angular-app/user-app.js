(function(){
	var app = angular.module('usersApp',[
		'angular-loading-bar',
	  'templates',
	  'ngRoute',
	  'ngResource',
	  'ngAnimate',
	  'titleService',
	  'messagesService',
	  'willPaginate',
	])
	//sends the authenticity token on all request
	app.config(["$httpProvider", function($httpProvider) {
	  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
	}]);
	app.config(['$routeProvider', '$locationProvider',
		function($routeProvider, $locationProvider){
			$routeProvider
				.when('/users', {
		      templateUrl: "users/index.html",
		      controller: 'UsersController',
		      title: 'Listado de usuarios'
		    }).when('/users/new', {
		      templateUrl: "users/new.html",
		      controller: 'newUserController',
		      title: 'Nuevo usuario'
		    })
		    .when('/users/:userId/edit', {
		      templateUrl: "users/edit.html",
		      controller: 'editUserController',
		      title: 'Editar usuario'
		    })
		  $locationProvider.html5Mode(true);  
	}]);
	app.run(['$rootScope','titleService','$location',
		function($rootScope,titleService,$location){
		$rootScope.$on("$routeChangeSuccess", function(event, currentRoute, previousRoute) {
		  titleService.setTitle(currentRoute.$$route.title)
		});
	}])
	
	app.factory('UserService',['$resource', function ($resource) {
    return $resource('/api/users/:userId/:reset_password.:format', {format: 'json'},
      {
      	query: {isArray: false},
      	create:{ method: 'POST' },
      	update:{ method:'PUT' },
      	reset_password:{ method: 'POST',
      				params: {userId: '@userId',reset_password: 'reset_password'}}
      }
    );
	}]);

	app.factory('PageService',[function(){
		var data = {}
		data.setPage = function(page){
			if(page != 1 && page != undefined){
				data.full_user_path = '/users?page=' + page 
			}else{
				data.full_user_path = '/users'
			}
		}
		return data;
	}]);
	app.controller('UsersController',
		['$scope', 'UserService','$location','$routeParams','PageService','messagesService',
	  function($scope, UserService, $location, $routeParams,PageService,messagesService){
	  	$scope.loaded_users = false;
	  	PageService.setPage($routeParams.page);
			UserService.query({page: $routeParams.page}).
				$promise.then(
	       	function(data) {
	          $scope.users = data.users;
	          $scope.willPaginateCollection = {
				      currentPage : data.current_page,
				      perPage : data.per_page,
				      totalPages: data.total_pages,
				      offset : data.offset,
				      totalEntries : 13,
				    };
				    $scope.loaded_users = true;
	        },function(error){
	        	messagesService.show_message(error.data.status, error.data.message);
	        }
      );
	    $scope.willPaginateConfig = {
	      previousLabel: 'Anterior',
	      nextLabel: 'Siguiente'
	    };
	    $scope.getPage = function(page){
	      if(page == 1){
	      	$location.path("/users");
	      }else{
	      	$location.path("/users").search('page', page);
	      }

	    };
	}]);



	app.controller('editUserController',
		['$scope', 'UserService','$location','$routeParams',
		'messagesService','PageService',function($scope, UserService,
		$location, $routeParams, messagesService, PageService){
			$scope.full_user_path = PageService.full_user_path
	  	$scope.loaded_user = false;
	  	$scope.abreviaciones = ['Odon.','Dr.','Dra.','Lic.','Obs.','Enf.']
			$scope.sexos = ['MASCULINO','FEMENINO']
			$scope.loading = false;
	  	UserService.get({userId: $routeParams.userId}).$promise.then(
       	function(user) {
          $scope.user = user;
          $scope.loaded_user =true;
        },function(error){
        	$location.path("/users");
        	messagesService.show_message(error.data.status, error.data.message);
        }
      );
			$scope.processUser = function() {
				console.log('weza')
				$scope.loading = true;
				var data = { user: $scope.user }
				UserService.update({ userId: $scope.user.id }, data).$promise.then(
	        function(value){        	
	        	$scope.loading = false;
	        	$location.path("/users");
	        	messagesService.show_message(value.status, value.message);
	        },
	        function(error){
	        	$scope.loading = false;
	        	$scope.errors = error.data.data.errors;
	        	messagesService.show_message(error.data.status, error.data.message);
	        }
	      )
			};
			$scope.reset_password = function(){
				UserService.reset_password({ userId: $scope.user.id }).$promise.then(
	        function(value){
	        	$location.path("/users");
	        	messagesService.show_message(value.status, value.message);
	        },
	        function(error){
	        	$location.path("/users");
	        	messagesService.show_message(error.data.status, error.data.message);
	        }
	      )
			}

	}]);

	app.controller('newUserController',
		['$scope', 'UserService','$location','messagesService','PageService',
	  function($scope, UserService, $location, messagesService,PageService){
	  	$scope.full_user_path = PageService.full_user_path
			$scope.abreviaciones = ['Odon.','Dr.','Dra.','Lic.','Obs.','Enf.']
			$scope.sexos = ['MASCULINO','FEMENINO']
			$scope.user = { apellido_paterno: ''}
			$scope.loading = false;
			$scope.processUser = function() {
				$scope.loading = true;
				var data = { user: $scope.user }
				UserService.create(data).$promise.then(
	        function(value){        	
	        	$scope.loading = false;
	        	$location.path("/users");
	        	messagesService.show_message(value.status, value.message);
	        },
	        function(error){
	        	$scope.loading = false;
	        	$scope.errors = error.data.data.errors;
	        	messagesService.show_message(error.data.status, error.data.message);
	        }
	      )
			}
	}]);

	app.animation('.reveal-animation', function() {
	  return {
	    enter: function(element, done) {
	      element.css('display', 'none');
	      element.fadeIn(1000, done);
	      return function() {
	        element.stop();
	      }
	    },
	    leave: function(element, done) {
	      element.fadeIn(1000, done)
	      return function() {
	        element.stop();
	      }
	    }
	  }
	})

	
	app.directive('colorPicker', function(){
		//usa el scope superior
		return{
			restrict: 'A',
			replace: true,
			template: '<select id="colorpicker" name="colorpicker-shortlist">\
								  <option value="#ffffff"></option>\
								  <option value="#69D2E7"></option>\
								  <option value="#A7DBD8"></option>\
								  <option value="#E0E4CC"></option>\
								  <option value="#F38630"></option>\
								  <option value="#FA6900"></option>\
								  <option value="#ECD078"></option>\
								  <option value="#D95B43"></option>\
								  <option value="#C02942"></option>\
								  <option value="#542437"></option>\
								  <option value="#53777A"></option>\
								  <option value="#556270"></option>\
								  <option value="#4ECDC4"></option>\
								  <option value="#C7F464"></option>\
								  <option value="#FF6B6B"></option>\
								  <option value="#C44D58"></option>\
								  <option value="#547980"></option>\
								  <option value="#45ADA8"></option>\
								  <option value="#9DE0AD"></option>\
								  <option value="#CBE86B"></option>\
								  <option value="#FF4E50"></option>\
								  <option value="#FC913A"></option>\
								  <option value="#F9D423"></option>\
								  <option value="#EDE574"></option>\
								</select>',
			link: function(scope, element, attr) {
				var el = $('select[id="colorpicker"]');
				el.simplecolorpicker('selectColor', '#ffffff').
				on('change', function() {
					var scolor = el.val();
					scope.user.color = scolor;
					scope.$apply();
				});
				scope.$watch('loaded_user', function() {
					if(scope.user.color){
			  		el.simplecolorpicker('selectColor', scope.user.color)
			  	}
			  });
			}					
		}
	});


	app.directive('ngConfirmClick', [
    function(){
      return {
        link: function (scope, element, attr) {
          var msg = attr.ngConfirmClick || "Estas seguro?";
          var clickAction = attr.confirmedClick;
          element.bind('click',function (event) {
              if ( window.confirm(msg) ) {
                  scope.$eval(clickAction)
              }
          });
        }
      };
    }])	

	angular.module('titleService', []).factory('titleService',
	  ['$document', function($document) {
	  var suffix, title;
	  suffix = title = "Clinicas Libres";
	  return {
	    setSuffix: function(s) {
	      return suffix = s;
	    },
	    getSuffix: function() {
	      return suffix;
	    },
	    setTitle: function(t) {
	      if (suffix !== "") {
	        title = t + ' | ' + suffix;
	      } else {
	        title = t;
	      }
	      $document.prop('title', title);
	    },
	    getTitle: function() {
	      $document.prop('title');
	    }
	  };
	}]);
	angular.module('messagesService', []).factory('messagesService', function(){
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