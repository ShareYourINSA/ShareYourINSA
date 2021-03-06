class ProfileController < ApplicationController

  # noinspection RailsParamDefResolve
  before_action :authenticate_user! # Because we must have a non nil current_user

  def show
    if params[:id]
      @profile_user = ProfileUser.find_or_create_by user_id: params[:id]
    else
      @profile_user = ProfileUser.find_or_create_by user: current_user
    end
    @posts = @profile_user.user.posts.order(:created_at).reverse
  end

  def edit
    @profile_user = ProfileUser.find_or_create_by user: current_user
  end

  def new_post
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to :profile, notice: t('post.saved')
    else
      redirect_to :profile, notice: t('post.error')
    end
  end

  def update
    @profile_user = ProfileUser.find_or_create_by user: current_user
    respond_to do |format|
      if @profile_user.update(profile_params)
        format.html { redirect_to :profile, notice: 'Profile user was successfully created.' }
        format.json { render :show, status: :ok, location: @profile_user }
      else
        format.html { render :edit }
        format.json { render json: @profile_user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def profile_params
    params.require(:profile_user).permit(
        :first_name, :last_name, :company_name, :industry_domain, :location, :phone_number, :languages_spoken,
        :skills, :diplomas, :promotion_id, :avatar)
  end

  def post_params
    params.require(:post).permit(:content, :title)
  end
end
