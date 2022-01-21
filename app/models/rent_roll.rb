class RentRoll < ApplicationRecord

  def occupied(date)
    return 0 if move_in.nil?
    if move_in.present? and move_out.present?
      return date.between?(move_in,move_out) ? 1:0
    end
    #we also dont need to check if its nil because we already did we also dont need to check move_out because we already did
    if move_in <= date
      1
    else
      0
    end

  end

  def leased(date)
    if move_in.nil?
      0
    elsif move_in > date and move_out.nil?
      1
    else
      0
    end

  end

  def status(date)
    if move_in.nil? && move_out.nil?
      "Vacant"
    else
      if move_in <= date and move_out.nil?
        'Current'
      elsif move_in >= date and move_out.nil?
        'Future'
      end
    end
  end
end
