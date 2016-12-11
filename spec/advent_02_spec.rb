require "spec_helper"

class Advent02
  attr_reader :x, :y, :pad

  DEFAULT_PAD = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
  ]

  def initialize(pad = DEFAULT_PAD)
    @pad = pad

    # initialize at the '5'
    @x, @y = find('5')

    @code = []
  end

  def find(char)
    pad.each.with_index do |row, y|
      row.each.with_index do |button, x|
        return [x, y] if button == char
      end
    end
    fail "Could not find #{char} in #{pad}"
  end

  def call(input)
    input.split("\n").reject { |line| line.empty? }.each do |line|
      do_line(line)
    end
  end

  def do_line(line)
    line.chars.each do |char|
      move_finger(char)
    end

    @code << current_button
  end

  def code
    @code.join("")
  end

  def move_finger(character)
    dx, dy = case character
    when "U"
      [0, -1]
    when "D"
      [0, 1]
    when "R"
      [1, 0]
    when "L"
      [-1, 0]
    else
      fail "I don't know how to move #{character}"
    end

    if valid?(x + dx, y + dy)
      @x = x + dx
      @y = y + dy
    end
  end

  def valid?(x, y)
    x >= 0 && y >= 0 &&
      y < pad.size && x < pad[y].size &&
      !pad[y][x].nil?
  end

  def current_button
    pad[y][x]
  end
end

describe Advent02 do
  context "when called" do
    let(:service) { Advent02.new }
    before do
      service.call(input)
    end

    context "just once up" do
      let(:input) { "U" }

      describe "#code" do
        subject { service.code }
        it { is_expected.to eq("2") }
      end
    end

    context "twice up" do
      let(:input) { "U\nU" }

      describe "#code" do
        subject { service.code }
        it { is_expected.to eq("22") }
      end
    end

    context "up then right" do
      let(:input) { "U\nR" }

      describe "#code" do
        subject { service.code }
        it { is_expected.to eq("23") }
      end
    end

    context "sample input" do
      let(:input) { "ULL\nRRDDD\nLURDL\nUUUUD" }

      describe "#code" do
        subject { service.code }
        it { is_expected.to eq("1985") }
      end
    end

    context "sample input from a file" do
      let(:input) { File.open("spec/advent_02_sample.txt").read }

      describe "#code" do
        subject { service.code }
        it { is_expected.to eq("1985") }
      end
    end

    context "actual input" do
      let(:input) { File.open("spec/advent_02_input.txt").read }

      describe "#code" do
        subject { service.code }
        it { is_expected.to eq("14894") }
      end
    end
  end

  context "with a special pad" do
    let(:special_pad) { [
      [nil, nil, "1", nil, nil],
      [nil, "2", "3", "4", nil],
      ["5", "6", "7", "8", "9"],
      [nil, "A", "B", "C", nil],
      [nil, nil, "D", nil, nil],
    ] }

    let(:service) { Advent02.new(special_pad) }
    before do
      service.call(input)
    end

    context "just once up" do
      let(:input) { "U" }

      describe "#code" do
        subject { service.code }
        it { is_expected.to eq("5") }
      end
    end

    context "twice up" do
      let(:input) { "U\nU" }

      describe "#code" do
        subject { service.code }
        it { is_expected.to eq("55") }
      end
    end

    context "up then right" do
      let(:input) { "U\nR" }

      describe "#code" do
        subject { service.code }
        it { is_expected.to eq("56") }
      end
    end

    context "sample input" do
      let(:input) { "ULL\nRRDDD\nLURDL\nUUUUD" }

      describe "#code" do
        subject { service.code }
        it { is_expected.to eq("5DB3") }
      end
    end

    context "sample input from a file" do
      let(:input) { File.open("spec/advent_02_sample.txt").read }

      describe "#code" do
        subject { service.code }
        it { is_expected.to eq("5DB3") }
      end
    end

    context "actual input" do
      let(:input) { File.open("spec/advent_02_input.txt").read }

      describe "#code" do
        subject { service.code }
        it { is_expected.to eq("26B96") }
      end
    end
  end
end
