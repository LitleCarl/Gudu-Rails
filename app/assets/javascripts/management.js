//= require jquery.js
//= require lodash
//= require materialize
//= require angular
//= require angular-route
//= require 'mobile/v1/modules/SharedHttp'
//= require 'mobile/v1/controllers/Controllers.js'
//= require 'mobile/v1/jquery/iScroll.js'

//进度条
//= require nprogress
//= require nprogress-angular

$(document).ready(function() {
    $('select').material_select();

    $('.button-collapse').sideNav({
            menuWidth: 200, // Default is 240
            edge: 'left', // Choose the horizontal origin
            closeOnClick: true // Closes side-nav on <a> clicks, useful for Angular/Meteor
        }
    );

    var notice = $('#notice');
    if (notice.length > 0){
        Materialize.toast(notice.html(), 6000);
    }

    var alert = $('#alert');
    if (alert.length > 0){
        Materialize.toast(alert.html(), 6000);
    }
});

var globalModule = angular.module('GlobalAngularModule', ['ngRoute', 'nprogress-rails']);

// 加载Http管理器
InjectSharedHttpClient(globalModule);
// 加载控制器
ImportControllers(globalModule);

globalModule.config(['$routeProvider',
    function($routerProvider){
        $routerProvider
            .when('/', {
            controller: 'SelectCampusController', templateUrl: 'SelectCampusTemplate.html'
            })
            .when('/campuses/:id', {
                controller: 'StoreListController', templateUrl: 'StoreListTemplate.html'
            })
            .otherwise({redirectTo: '/'})
    }]
);

