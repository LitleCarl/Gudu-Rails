Response =
  Code: {
    SUCCESS: 200
  }

# 注入共享http模块
@InjectSharedHttpClient = (appModule) ->
  appModule.service 'HttpService', ($http) ->
    self = this
    self.UrlSet =
      kHostBaseUrl: 'http://192.168.2.72:3001'
      kCampusUrl: '/campuses.json'
      kCampusFindOneUrl: '/campuses/-id-.json'
      kStoresUrl: '/campuses/-id-/stores.json'

    # 组建URL
    BuildUrl = (path = '', param = {}, baseUrl = self.UrlSet['kHostBaseUrl'], replace = {}) ->
      url = "#{baseUrl}#{path}"

      for own key, value of replace
        url = url.replace(new RegExp(key, 'g'), value);
      for own key, value of param
        url = AddParameter(url, key, value, false)
      url

    # Url添加query数
    AddParameter = (url, parameterName, parameterValue, atStart) ->
      replaceDuplicates = true
      if url.indexOf('#') > 0
        cl = url.indexOf('#')
        urlhash = url.substring(url.indexOf('#'), url.length)
      else
        urlhash = ''
        cl = url.length
      sourceUrl = url.substring(0, cl)
      urlParts = sourceUrl.split('?')
      newQueryString = ''
      if urlParts.length > 1
        parameters = urlParts[1].split('&')
        i = 0
        while i < parameters.length
          parameterParts = parameters[i].split('=')
          if !(replaceDuplicates and parameterParts[0] == parameterName)
            if newQueryString == ''
              newQueryString = '?'
            else
              newQueryString += '&'
            newQueryString += parameterParts[0] + '=' + (if parameterParts[1] then parameterParts[1] else '')
          i++
      if newQueryString == ''
        newQueryString = '?'
      if atStart
        newQueryString = '?' + parameterName + '=' + parameterValue + (if newQueryString.length > 1 then '&' + newQueryString.substring(1) else '')
      else
        if newQueryString != '' and newQueryString != '?'
          newQueryString += '&'
        newQueryString += parameterName + '=' + (if parameterValue then parameterValue else '')
      urlParts[0] + newQueryString + urlhash

    @CheckStatusCode = (responseObject = {}) ->
      responseObject['status']?['code'] == Response.Code.SUCCESS


    # 加载学校列表
    @LoadCampuses = (keyword = '') ->
      promise = $http.get(BuildUrl(self.UrlSet['kCampusUrl'], {keyword: keyword})).then((response) ->
        # The then function here is an opportunity to modify the response
        # The return value gets picked up by the then in the controller.
        response.data
      )
      # Return the promise to the controller
      promise

    # 加载学校
    @LoadCampus = (campus_id) ->
      promise = $http.get(BuildUrl(self.UrlSet['kCampusFindOneUrl'], null, null, {'-id-': campus_id})).then((response) ->
        response.data
      )
      promise

    # 加载学校的商店
    @LoadCampusStores = (campus_id) ->
      promise = $http.get(BuildUrl(self.UrlSet['kStoresUrl'], null, null, {'-id-': campus_id})).then((response) ->
        response.data
      )
      promise
    return
  return
