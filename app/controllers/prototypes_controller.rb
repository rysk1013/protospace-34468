class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :destroy]
  before_action :access_restrictions, only: [:edit]
  before_action :set_prototype, only: [:show, :edit]

  def index
    @prototypes = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.create(prototype_params)
      
    if @prototype.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype)
    else
      @prototype = Prototype.find(params[:id])
      render :edit
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def access_restrictions
    prototype = Prototype.find(params[:id])
    unless current_user.id == prototype.user_id
      redirect_to action: :index
    end
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end
end
