require 'CSV'
class RentReport

  def import_csv
    #imports csv file
    csv_text = File.read(Rails.root.join('public', 'local', 'units-and-residents.csv'))
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      row['move_in'] = row['move_in'].nil? ? '' : Date.strptime(row['move_in'], '%m/%d/%Y')
      row['move_out'] = row['move_out'].nil? ? '' : Date.strptime(row['move_out'], '%m/%d/%Y')
      RentRoll.create!(row.to_hash)
    end
  end

  def run_rpt(date)
    #runs the report
    occupied = 0
    leased = 0
    date = Date.strptime(date, '%m/%d/%Y')
    rent_roll = RentRoll.all.order(:unit,:move_in)
    rent_roll.each do |r|
      puts "Unit: #{r.unit} Floor Plan: #{r.floor_plan} Resident: #{r.resident} Resident Status: #{r.status(date)} Move In: #{r.move_in}  Move Out: #{r.move_out}"
    end

    rent_roll.each do |r|
      occupied += r.occupied(date)
      leased += r.leased(date)
    end

    puts "Occupied: #{occupied}"
    puts "Vacant: #{RentRoll.distinct.pluck(:unit).count - leased - occupied}"
    puts "Leased: #{leased + occupied}"

  end
end
#Business Rules
# Rent Roll Report
# A rent roll report lists units in order by unit number, and includes the following data:
#
# Unit number
# Floor Plan name
# Resident name
# Resident status (current or future)
# Move in date
# Move out date
# A rent roll is run for a given date. It includes current and future residents, as well as vacant units.
#
# This rent roll report will be viewed in the rails console, it can be an array of arrays or a formatted string.
#
# Key Statistics
# For a given date, users want to see the number of:
#
# Vacant units
# Occupied units
# Leased units (the count of the unique set of occupied units and units with future residents)