class PeopleController < BaseController
  def index
    @people = Person.all
  end

  def show
    @person = Person.find(params[:id])
  end
end
