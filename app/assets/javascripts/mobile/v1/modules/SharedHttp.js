// 注入共享http模块
function InjectSharedHttpClient(appModule){
    appModule.service('HttpService', function($http){
        this.loadCampuses = function() {
            // 在这里使用http
            var promise = $http.get('http://localhost:3000/campuses.json').then(function (response) {
                // The then function here is an opportunity to modify the response
                console.log(response);
                // The return value gets picked up by the then in the controller.
                return response.data;
            });
            // Return the promise to the controller
            return promise;
        };
    });
}