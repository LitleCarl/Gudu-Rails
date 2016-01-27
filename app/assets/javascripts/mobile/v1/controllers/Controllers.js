// 导入视图控制器
var EventName = {
    // 选择了新的学校
  kSelectCampusEvent: 'kSelectCampusEvent'
};

function ImportControllers(appModule){

    appModule.controller('GlobalAngularController', ['$scope', '$http', function($scope, $http){
        var self = $scope;
        self.campus = null;

        // 接受子控制器选择新的校区
        $scope.$on(EventName.kSelectCampusEvent, function(event, data) {
            self.campus = data;
        });

    }]);

    appModule.controller('SelectCampusController', ['$scope', '$http', 'HttpService', function($scope, $http, HttpService){
        var self = $scope;
        self.search_text = '';

        // 下一步按钮是否可点
        self.couldGoNext = function(){
            return !_.isNil(self['campus_id'])
        };

        // 搜索学校
        self.SearchCampus = function(){

            HttpService.LoadCampuses(self.search_text).then(
                function(responseObject){
                    $scope.CampusList = responseObject['data']['campuses'];
                }
            );
        }
    }]);

    appModule.controller('StoreListController', ['$scope', '$routeParams', 'HttpService', function($scope, $routeParams, HttpService){
        var self = $scope;
        var campus_id = $routeParams.id;

        HttpService.LoadCampusStores(campus_id).then(
            function(responseObject){
                if (HttpService.CheckStatusCode(responseObject)){
                    self.StoreList = responseObject['data']['stores'];

                }
            }
        );

        HttpService.LoadCampus(campus_id).then(
            function(responseObject){
                if (HttpService.CheckStatusCode(responseObject)){
                    var campus = responseObject['data']['campus'];
                    self.$emit(EventName.kSelectCampusEvent, campus);
                }
            }
        );
    }]);

    appModule.controller('OrderQueryController', ['$scope', '$routeParams', 'HttpService', function($scope, $routeParams, HttpService){
        var self = $scope;
        self.GoForDate = function(){
          if (self.SelectDate){
              window.location.href = "/management/orders?date=" + self.SelectDate;
          }
        };
    }])
}