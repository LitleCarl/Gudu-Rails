
class Object
    def paginate(params = {})
      self.page(params[:page]).per(params[:limit])
    end
end

