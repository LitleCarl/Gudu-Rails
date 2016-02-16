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

    appModule.controller('ProductStatisticController', ['$scope', '$routeParams', 'HttpService', function($scope, $routeParams, HttpService){
        var self = $scope;
        self.GoForDate = function(){
            if (self.SelectDate){
                window.location.href = "/management/statistics?date=" + self.SelectDate;
            }
        };
    }]);


    appModule.controller('ProductDetailController',['$scope', '$routeParams', '$compile', function($scope, $routeParams, $compile){
        $scope.hoverIn = function(e){
            var product_image_div =  $(e.currentTarget);
            product_image_div.find('.hover-btn').height('2em');
        };

        $scope.hoverOut = function(e){

            var product_image_div =  $(e.currentTarget);
            product_image_div.find('.hover-btn').height(0);
        };

        $scope.removeImage = function(e){
            var button =  $(e.currentTarget);
            button.parent().remove();
        };

        // 添加新的规格
        $scope.AddNewSpecificationRow = function(){

            var random_str_1 = 'a'+Math.random().toString(36).substring(7);
            var random_str_2 = 'b'+Math.random().toString(36).substring(7);
            var random_row_id = 'row-' + Math.random().toString(36).substring(7);

            var html_template = '<div class="row" id="row-id"> <div class="input-field col s4"> <input id="tesat" name="specification_values[]" placeholder="红" type="text" ><label for="tesat" class="active"> 规格</label> </div> <div class="input-field col s4"> <input id="tesst" name="specification_prices[]" placeholder="3.5" type="text"><label for="tesst" class="active"> 价格</label> </div> <div class="col s4"> <a class="btn-floating btn-large waves-effect waves-light red hover-btn" ng-click="RemoveSpecification(\'row-id\')">删</a> </div> </div>';
            var replace_rule_1 = new RegExp('tesat', 'g')
            var replace_rule_2 = new RegExp('tesst', 'g')
            var replace_rule_3 = new RegExp('row-id', 'g')

            html_template = html_template.replace(replace_rule_1, random_str_1);
            html_template = html_template.replace(replace_rule_2, random_str_2);
            html_template = html_template.replace(replace_rule_3, random_row_id);

            var specification_container = $(html_template);

            angular.element(document.getElementById('specification-container')).append($compile(html_template)($scope))
            //$('#specification-container').append(specification_container)
        };

        $scope.RemoveSpecification = function(id){
            angular.element(document.getElementById(id)).remove();
        }
    }]);
}