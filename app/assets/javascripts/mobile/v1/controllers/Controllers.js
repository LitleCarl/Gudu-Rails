// 导入视图控制器
function ImportControllers(appModule){
    appModule.controller('GlobalAngularController', ['$scope', '$http', function($scope, $http){
        var self = $scope;
        self.campus = {};

    }]);

    appModule.controller('SelectCampusController', ['$scope', '$http', 'HttpService', function($scope, $http, HttpService){
        var self = $scope;
        self.CampusList = [{name: 'cjx'}];

        HttpService.loadCampuses().then(
            function(responseObject){
                        $scope.CampusList = responseObject['data']['campuses'];
                        console.log('CampusList:', $scope.CampusList)
            }
        );

        // 下一步按钮是否可点
        self.couldGoNext = function(){
            return !_.isNil(self['campus_id'])
        };

        self.goToCampus = function(){
            if(self.couldGoNext()){

            }

        }
    }]);
}