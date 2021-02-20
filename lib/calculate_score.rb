class CalculateScore
  def initialize(player_shots)
    @shots = player_shots
    raise "Shots from multiple players" if @shots.map(&:player).uniq.size > 1
  end

  def calculate(shot)
    score = 0
    if shot.frame < 10 && shot.number == 1 && shot.pins == 10 && @shots.size - @shots.to_a.index(shot) == 3
      @subsequent_shots = @shots.select { |s| s.frame >= shot.frame }
      score = map_score(0..2) if shot.number == 1
    elsif shot.frame < 10 && shot.number == 1 && shot.pins == 10 && @shots.size - @shots.to_a.index(shot) < 3
      score = 0
    elsif shot.frame == 10 && shot.pins == 10
      @subsequent_shots = @shots.select { |s| s.frame >= shot.frame }
      score = map_score(0..2)
    elsif @shots.size > 1
      @frame_shots = @shots.select { |s| s.frame == shot.frame }
      score = map_frame_shots
      if score == 10
        @subsequent_shots = @shots.select { |s| s.frame >= shot.frame }
        if @subsequent_shots.size >= 3
          score = map_score(0..2)
        else
          score = 0
        end
      end
      score
    else
      score = shot.pins
    end
    score
  end

   private
   def map_frame_shots
     @frame_shots[0..2].map(&:pins).reduce(0, :+)
   end

   def map_score(range)
     @subsequent_shots[range].map(&:pins).reduce(0, :+)
   end
end
