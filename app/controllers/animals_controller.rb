class AnimalsController < ApplicationController
  before_action :set_animal, only: [:show, :edit, :update, :destroy]

  # GET /animals
  def index
    @animals = Animal.all
  end

  # GET /animals/1
  def show
  end

  # GET /animals/new
  def new
    @animal = Animal.new
  end

  # GET /animals/1/edit
  def edit
  end

  # POST /animals
  def create
    @animal = Animal.new(animal_params)

    if @animal.save
      redirect_to @animal, notice: 'Animal was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /animals/1
  def update
    if @animal.update(animal_params)
      redirect_to @animal, notice: 'Animal was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /animals/1
  def destroy
    @animal.destroy
    redirect_to animals_url, notice: 'Animal was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_animal
      @animal = Animal.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def animal_params
      params.require(:animal).permit(:email, :role)
    end
end
