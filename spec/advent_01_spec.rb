require "spec_helper"

class Advent01
  attr_reader :x, :y, :dx, :dy
  attr_reader :previous_visits, :visited_twice

  NORTH = [0, -1]
  SOUTH = [0, 1]
  WEST = [-1, 0]
  EAST = [1, 0]

  def initialize
    @x = 0
    @y = 0
    @dx, @dy = NORTH
    @previous_visits = {}
  end

  def call(input)
    input.split(", ").each do |step|
      step(step)
    end

    distance_from_zero
  end

  def location
    "(#{x},#{y})"
  end

  def step(input)
    case input[0]
    when "R"
      rotate_right!
    when "L"
      rotate_left!
    else
      fail "Unknown rotation for #{input}"
    end

    move_forwards!(input[1..9].to_i)
  end

  def rotate_left!
    @dx, @dy = case [dx, dy]
    when NORTH
      WEST
    when WEST
      SOUTH
    when SOUTH
      EAST
    when EAST
      NORTH
    else
      fail "I don't know how to rotate left from #{dx}, #{dy}"
    end
  end

  def rotate_right!
    @dx, @dy = case [dx, dy]
    when NORTH
      EAST
    when EAST
      SOUTH
    when SOUTH
      WEST
    when WEST
      NORTH
    else
      fail "I don't know how to rotate right from #{dx}, #{dy}"
    end
  end

  def move_forwards!(steps)
    steps.times do
      @x += dx
      @y += dy
      if previous_visits.has_key?(location) && @visited_twice.nil?
        @visited_twice = distance_from_zero
      end

      previous_visits[location] = distance_from_zero
    end
  end

  def distance_from_zero
    x.abs + y.abs
  end

  def to_s
    "[x=#{x}, y=#{y}, dx=#{dx}, dy=#{dy}, distance=#{distance_from_zero}, visited_twice=#{visited_twice}]"
  end
end

describe Advent01 do
  let(:north) { Advent01::NORTH }
  let(:south) { Advent01::SOUTH }
  let(:west) { Advent01::WEST }
  let(:east) { Advent01::EAST }

  describe "#call" do
    examples = {
      "R1" => 1,
      "R1, R1, R1, R1" => 0,
      "L1, L1, L1, L1" => 0,
      "R2" => 2,
      "L2" => 2,
      "R4" => 4,
      "L4" => 4,

      # provided data
      "R2, L3" => 5,
      "R2, R2, R2" => 2,
      "R5, L5, R5, R3" => 12,

      # actual input
      "L1, L3, L5, L3, R1, L4, L5, R1, R3, L5, R1, L3, L2, L3, R2, R2, L3, L3, R1, L2, R1, L3, L2, R4, R2, L5, R4, L5, R4, L2, R3, L2, R4, R1, L5, L4, R1, L2, R3, R1, R2, L4, R1, L2, R3, L2, L3, R5, L192, R4, L5, R4, L1, R4, L4, R2, L5, R45, L2, L5, R4, R5, L3, R5, R77, R2, R5, L5, R1, R4, L4, L4, R2, L4, L1, R191, R1, L1, L2, L2, L4, L3, R1, L3, R1, R5, R3, L1, L4, L2, L3, L1, L1, R5, L4, R1, L3, R1, L2, R1, R4, R5, L4, L2, R4, R5, L1, L2, R3, L4, R2, R2, R3, L2, L3, L5, R3, R1, L4, L3, R4, R2, R2, R2, R1, L4, R4, R1, R2, R1, L2, L2, R4, L1, L2, R3, L3, L5, L4, R4, L3, L1, L5, L3, L5, R5, L5, L4, L2, R1, L2, L4, L2, L4, L1, R4, R4, R5, R1, L4, R2, L4, L2, L4, R2, L4, L1, L2, R1, R4, R3, R2, R2, R5, L1, L2" => 299,
    }

    examples.each do |input, output|
      it "with #{input} returns #{output}" do
        subject = Advent01.new
        result = subject.call(input)
        expect(result).to eq(output), "#{subject}"
      end
    end
  end

  describe "#visited_twice" do
    examples = {
      "R8, R4, R4, R8" => 4,

      # actual input
      "L1, L3, L5, L3, R1, L4, L5, R1, R3, L5, R1, L3, L2, L3, R2, R2, L3, L3, R1, L2, R1, L3, L2, R4, R2, L5, R4, L5, R4, L2, R3, L2, R4, R1, L5, L4, R1, L2, R3, R1, R2, L4, R1, L2, R3, L2, L3, R5, L192, R4, L5, R4, L1, R4, L4, R2, L5, R45, L2, L5, R4, R5, L3, R5, R77, R2, R5, L5, R1, R4, L4, L4, R2, L4, L1, R191, R1, L1, L2, L2, L4, L3, R1, L3, R1, R5, R3, L1, L4, L2, L3, L1, L1, R5, L4, R1, L3, R1, L2, R1, R4, R5, L4, L2, R4, R5, L1, L2, R3, L4, R2, R2, R3, L2, L3, L5, R3, R1, L4, L3, R4, R2, R2, R2, R1, L4, R4, R1, R2, R1, L2, L2, R4, L1, L2, R3, L3, L5, L4, R4, L3, L1, L5, L3, L5, R5, L5, L4, L2, R1, L2, L4, L2, L4, L1, R4, R4, R5, R1, L4, R2, L4, L2, L4, R2, L4, L1, L2, R1, R4, R3, R2, R2, R5, L1, L2" => 181,
    }

    examples.each do |input, output|
      it "with #{input} returns #{output}" do
        subject = Advent01.new
        subject.call(input)
        expect(subject.visited_twice).to eq(output), "#{subject}"
      end
    end
  end

  describe "#rotate" do
    it "does rotation to the left" do
      x = Advent01.new
      expect([x.dx, x.dy]).to eq(north)

      x.rotate_left!
      expect([x.dx, x.dy]).to eq(west)

      x.rotate_left!
      expect([x.dx, x.dy]).to eq(south)

      x.rotate_left!
      expect([x.dx, x.dy]).to eq(east)

      x.rotate_left!
      expect([x.dx, x.dy]).to eq(north)
    end

    it "does rotation to the right" do
      x = Advent01.new
      expect([x.dx, x.dy]).to eq(north)

      x.rotate_right!
      expect([x.dx, x.dy]).to eq(east)

      x.rotate_right!
      expect([x.dx, x.dy]).to eq(south)

      x.rotate_right!
      expect([x.dx, x.dy]).to eq(west)

      x.rotate_right!
      expect([x.dx, x.dy]).to eq(north)
    end
  end
end
