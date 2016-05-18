class ProfileUsersController < ApplicationController
  before_action :set_profile_user, only: [:show, :edit, :update, :destroy]

  def current_user_profile_edit
    @profile_user = ProfileUser.find_or_create_by user: current_user
    render :edit
  end

  # GET /profile_users
  # GET /profile_users.json
  def index
    @profile_users = ProfileUser.all
    departments_names = Department.all.collect {|d| d.department_name}
    @promotions = Promotion.all.collect {
        |p|
      [
          "#{p.start_date} - #{p.end_date} #{departments_names[p.id_department- 1]}",
          p.id
      ]
    }
  end

  # GET /profile_users/1
  # GET /profile_users/1.json
  def show
  end

  # GET /profile_users/new
  def new
    @profile_user = ProfileUser.new
    departments_names = Department.all.collect {|d| d.department_name}
    @promotions = Promotion.all.collect {
        |p|
      [
          "#{p.start_date} - #{p.end_date} #{departments_names[p.id_department- 1]}",
          p.id
      ]
    }

  end

  # GET /profile_users/1/edit
  def edit
  end

  # POST /profile_users
  # POST /profile_users.json
  def create
    @profile_user = ProfileUser.new(profile_user_params, locked_state: 0)
    respond_to do |format|
      if @profile_user.save
        format.html do
          if @profile_user.user == current_user
            redirect_to :profile, notice: 'Profile user was successfully created.'
          else
            redirect_to @profile_user, notice: 'Profile user was successfully created.'
          end
        end
        format.json { render :show, status: :created, location: @profile_user }
      else
        format.html { render :new }
        format.json { render json: @profile_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profile_users/1
  # PATCH/PUT /profile_users/1.json
  def update
    respond_to do |format|
      if @profile_user.update(profile_user_params)
        format.html do
          if @profile_user.user == current_user
            redirect_to :profile, notice: 'Profile user was successfully created.'
          else
            redirect_to @profile_user, notice: 'Profile user was successfully created.'
          end
        end
        format.json { render :show, status: :ok, location: @profile_user }
      else
        format.html { render :edit }
        format.json { render json: @profile_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profile_users/1
  # DELETE /profile_users/1.json
  def destroy
    @profile_user.destroy
    respond_to do |format|
      format.html { redirect_to profile_users_url, notice: 'Profile user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def lock_profile
    @profile_user.locked_state = true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile_user
      @profile_user = ProfileUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_user_params
      params.require(:profile_user).permit(:first_name, :last_name, :company_name, :industry_domain, :location, :phone_number, :languages_spoken, :skills, :diplomas, :promotion_id)
    end
end
