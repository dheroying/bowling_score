class Shot < ApplicationRecord
  belongs_to :game
  validates :number, :frame, :player, :pins, numericality: true
  validate :number_of_pins

  def number_of_pins
    current_pins = pins.to_i
    if current_pins > 10
      errors.add(:pins, "can't be more than 10")
    elsif current_pins < 0
        errors.add(:pins, "cannot be less than zero")
    elsif frame < 10
      shots = current_player_frame
      existing_pins = shots.map(&:pins).reduce(0, :+)
      if (existing_pins + current_pins) > 10
        max = 10 - existing_pins
        errors.add(:pins, "can't be more than #{max}")
      end
    else
      shots = current_player_frame
      if shots.size > 1 && shots[0].pins < 10
        if (shots[0].pins + shots[1].pins) > 10
          errors.add(:pins, "can't be more than 10")
        end
      end
    end
  end

  private
  def current_player_frame
    Shot.where(game: game,
               player: player,
               frame: frame).order(:number)
  end
end
