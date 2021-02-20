class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  def index
    @games = Game.all
  end

  def show
    @shot = @game.shots.build
    @scoreboard = ScoreCalculator.new(@game)
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        session[:frame] = session[:player] = session[:shot_number] = 1
        session[:game_over] = session[:strike] = session[:spare] = false
        format.html { redirect_to @game, notice: 'Welcome. Enjoy your game!' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @game.update(game_params)
        @scoreboard = ScoreCalculator.new(@game)
        last_shot    = @game.shots.last
        current_game = ::MainLogic.new(@game, session)
        current_game.update(last_shot)
        session.merge!(current_game.status)

        format.html { redirect_to @game, notice: 'Scores updated successfully.' }
        format.json { render :show, status: :ok, location: @game }
      else
        @shot = @game.shots.last
        @scoreboard = ScoreCalculator.new(@game)
        format.js { render 'errors' }
        format.html { render :show, alert: 'Scores were not successfully updated.' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game destroyed successfully.' }
      format.json { head :no_content }
    end
  end

  private
    def set_game
      @game = Game.find(params[:id])
    end

    def game_params
      params.require(:game).permit(:players, shots_attributes: [:number, :frame, :player, :pins])
    end
end
