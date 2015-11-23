class SignupController < BaseController
  skip_before_filter :authorize

  def index
    @signup = Signup.new
  end

  def create
    @signup = Signup.new(params[:signup])

    if @signup.save
      sign_in(@signup.user)
      redirect_to root_url
    else
      render :index
    end
  end
end
