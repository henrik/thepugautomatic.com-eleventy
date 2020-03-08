#! /usr/bin/env ruby

# Henrik Nyh <http://henrik.nyh.se> 2006-09-27
# Free to modify and redistribute non-commercially with due credit.

# Turns integer strings into Swedish words. Handles units up to and including "centiljard", per <http://sv.wikipedia.org/wiki/R%C3%A4kneord#Lista_.C3.B6ver_r.C3.A4kneord>.

class Array
	def singles; slice(0); end
	def tens; slice(1); end
	def hundreds; slice(2);	end
	def tens?
		tens and tens.nonzero?
	end
	def hundreds?
		hundreds and hundreds.nonzero?
	end
	def contain_positive_integers?
		(1..9).any? {|int| self.include? int}
	end
end

class Integer
	SINGLES = %w{noll ett två tre fyra fem sex sju åtta nio}
	TEENS = %w{tio elva tolv tretton fjorton femton sexton sjutton arton nitton}
	TENS = %w{_ _ tjugo trettio fyrtio femtio sextio sjuttio åttio nittio}
	HUNDREDS, GOOGOLS, CENTILLIONS, CENTILLIARDS = %w{hundra googoler centiljoner centiljarder}
	CUBES = %w{tusen}
	%w{m b tr kvadr kvint sext sept okt non dec undec duodec tredec quattuordec quindec sexdec septendec octodec novemdec vigint}.each do |prefix|
		CUBES << "#{prefix}iljoner" << "#{prefix}iljarder"
	end
	
	def to_swedish
		Integer.to_swedish(self)
	end
	def self.to_swedish(string)
		number = string.to_s.scan(/\d/).map {|n| n.to_i}.reverse  # "00123" becomes [3,2,1,0,0]
		number.pop while number.size > 1 and number.last.zero?

		return nil if number.empty?
		return SINGLES[0] if number == [0]

		output = below_thousand(number)

		CUBES.each_with_index do |name,index|
			exponent = (index + 1) * 3
			case exponent
			when 99  # special treatment for sexdeciljard since 10^100 is googol
				output += unit(number, name, 99, 1)
				output += unit(number, GOOGOLS, 100, 2)
			when 123  # vigintiljard spans 10^123 - 10^599
				output += unit(number, name, 123..599)
			else
				output += unit(number, name, exponent)
			end
		end

		output += unit(number, CENTILLIONS, 600)
		output += unit(number, CENTILLIARDS, 603..-1)

		output = output.reverse.join(" ")

		# Fix singular determiners 
		output.gsub!(/\bett (\w+)er/, 'en \1')
		output.gsub!(/ett (\w+er)/, 'en \1')

		output
	end
	
	private  # Helper methods

	def self.below_thousand(number)  # Turns e.g. [3,2,1] (for 123) into words
		return [] unless number[0,3].contain_positive_integers?
		output = []
		if number.tens == 1
			output << TEENS[number.singles]
		else
			output << SINGLES[number.singles] unless number.singles.zero?
			output << TENS[number.tens] if number.tens?
		end
		output << HUNDREDS << SINGLES[number.hundreds] if number.hundreds?
		[output.reverse.join]
	end

	def self.unit(number, unit, exponent_or_range, places=3)  # The amount of a unit, ranging over part of the number
		list = if exponent_or_range.is_a?(Range) then number[exponent_or_range] else number[exponent_or_range,places] end
		return [] unless list and list.contain_positive_integers?
		[unit, to_swedish(list.reverse)]
	end
end

if __FILE__ == $0
	# Test run
	puts Integer.to_swedish("21_000")
	puts Integer.to_swedish("21_000_000")	
	puts 0.to_swedish
	puts Integer.to_swedish("000foo0001")
	puts Integer.to_swedish("1,024,908,267,229")
	puts Integer.to_swedish("1.#{"0"*1_205}1")
end