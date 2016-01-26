//= require jquery.js
//= require lodash
//= require materialize
//= require angular
//= require angular-route
//= require 'mobile/v1/modules/SharedHttp.js'
//= require 'mobile/v1/controllers/Controllers.js'

$(document).ready(function() {
    $('select').material_select();

    $('.button-collapse').sideNav({
            menuWidth: 240, // Default is 240
            edge: 'left', // Choose the horizontal origin
            closeOnClick: true // Closes side-nav on <a> clicks, useful for Angular/Meteor
        }
    );
});

var globalModule = angular.module('GlobalAngularModule', ['ngRoute']);

// 加载Http管理器
InjectSharedHttpClient(globalModule);
// 加载控制器
ImportControllers(globalModule);

globalModule.config(['$routeProvider',
    function($routerProvider){
        $routerProvider.when('/campuses', {
            controller: 'SelectCampusController', templateUrl: 'SelectCampusTemplate.html'
        }).otherwise({redirectTo: '/campuses'})
    }]
);

