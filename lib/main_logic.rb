class MainLogic
  attr_reader :player, :frame, :shot_number
  def initialize(game, session)
    @game   = game
    @player = 1
    @frame  = 1
    @shot_number = 1
    @strike = session[:strike] || false
    @spare  = session[:spare] || false
    @game_over = false
  end

  def status
    { player: @player, frame: @frame, shot_number: @shot_number, strike: @strike, spare: @spare, game_over: @game_over }
  end

  def update(last_shot)
    @last_shot = last_shot
    @player = last_shot.player
    @frame = last_shot.frame
    @shot_number = last_shot.number

    if !tenth_frame?
      @strike = false
      @spare = false

      if strike?
        @strike = true
        @shot_number = 1
        increment_player_or_frame
      elsif spare?
        @spare = true
        @shot_number = 1
        increment_player_or_frame
      elsif first_shot?
        @shot_number = 2
      elsif standard_frame_ended?
        @frame += 1
        @player = 1
        @shot_number = 1
      elsif second_shot?
        @player += 1
        @shot_number = 1
      end
    else # tenth frame
      if strike?
        @strike = true
        @shot_number += 1
      elsif second_strike?
        @strike = true
        @shot_number += 1
      elsif spare?
        @strike = false
        @spare = true
        @shot_number += 1
      elsif second_shot? && !@strike
        if last_player?
          @game_over = true
        else
          @player += 1 unless last_player?
          @shot_number = 1 unless last_player?
        end
      elsif third_shot?
        @strike = false
        @spare = false
        @shot_number = @shot_number
        @frame = @frame

        if last_player?
          @game_over = true
        else
          @player += 1 unless last_player?
          @shot_number = 1 unless last_player?
        end
      else
        @strike = false
        @spare = false
        @shot_number += 1
      end
    end
  end

  private
  def increment_player_or_frame
    last_player? ? (@frame += 1 && @player = 1) : @player += 1
  end

  def standard_frame_ended?
    @shot_number == 2 && last_player? && !tenth_frame?
  end

  def tenth_frame?
    @tenth_frame ||= @last_shot.frame == 10
  end

  def last_player?
    @last_shot.player.to_i == @game.players.to_i
  end

  def first_shot?
    @last_shot.number == 1
  end

  def third_shot?
    @third_shot ||= (@last_shot.number >= 3)
  end

  def second_shot?
    @last_shot.number == 2
  end

  def strike?
    first_shot? && max_scored?
  end

  def second_strike?
    @strike && second_shot? && max_scored?
  end

  def max_scored?
    @max_scored ||= @last_shot.pins == 10
  end

  def spare?
    @shots ||= @game.shots.where(player: @player, frame: @frame)
    if @shots.size > 1 && !third_shot?
      @shots[0..1].map(&:pins).reduce(0, :+) == 10
    else
      false
    end
  end
end
