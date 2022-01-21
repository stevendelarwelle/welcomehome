class RentRoll < ApplicationRecord

  def occupied(date)
    return 0 if move_in.nil? #neither occupied or leased in future
    if move_in.present? and move_out.present?
      return date.between?(move_in,move_out) ? 1:0
    end

    if move_in <= date
      #is occupied
      1
    else
      #already moved out
      0
    end

  end

  def leased(date)
    if move_in.nil? #neither occupied or leased
      0
    elsif move_in > date and move_out.nil? #leased because date is in future and no move out
      1
    else
      #occupied but thats already counted
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
