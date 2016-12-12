require "spec_helper"

class Advent03
  attr_reader :valid_triangles

  def initialize
    @valid_triangles = 0
  end

  def call(input)
    input.split("\n").reject { |line| line.empty? }.each do |line|
      check_triangle(line)
    end
  end

  def check_triangle(line)
    @valid_triangles += 1 if Triangle.new(line).valid?
  end
end

class Advent03Vertical < Advent03
  def call(input)
    input.split("\n").reject { |line| line.empty? }.each_slice(3) do |line1, line2, line3|
      bits1 = line1.split(" ").map(&:to_f)
      bits2 = line2.split(" ").map(&:to_f)
      bits3 = line3.split(" ").map(&:to_f)

      (0..2).each do |idx|
        check_triangle([bits1[idx], bits2[idx], bits3[idx]].join(" "))
      end
    end
  end
end

class Triangle
  attr_reader :a, :b, :c

  def initialize(string)
    @a, @b, @c = string.strip.split(" ").map(&:to_f)
  end

  def valid?
    (a + b) > c && (a + c) > b && (b + c) > a
  end
end

describe Advent03 do
  context "valid triangles" do
    let(:examples) { [
      "3 4 5",
      "5 4 3",
      "3 5 4",
      "6 8 10",
      "8 6 10",
      " 6 8 10",
      " 8  6  10",
    ] }

    it "are all valid" do
      examples.each do |example|
        expect(Triangle.new(example)).to be_valid
      end
    end
  end

  context "invalid triangles" do
    let(:examples) { [
      "3 4 50",
      "5 4 30",
      "3 5 40",
      "6 8 100",
      "8 6 100",
      " 8 6 100",
      "8  6 100",
      "  8   6  100 ",
    ] }

    it "are all invalid" do
      examples.each do |example|
        expect(Triangle.new(example)).to_not be_valid
      end
    end
  end

  let(:service) { Advent03.new }

  context "when called" do
    before do
      service.call(input)
    end

    subject { service.valid_triangles }

    context "some valid, some invalid" do
      let(:input) { "3 4 5\n5 4 3\n10 1 1\n10 1 2" }
      let(:valid) { 2 }

      it { is_expected.to eq(valid) }
    end

    context "all valid" do
      let(:input) { "3 4 5\n5 4 3" }
      let(:valid) { 2 }

      it { is_expected.to eq(valid) }
    end

    context "all valid with lots of whitespace" do
      let(:input) { "    3  4  5 \n      5 4  3" }
      let(:valid) { 2 }

      it { is_expected.to eq(valid) }
    end

    context "all invalid" do
      let(:input) { "3 4 50\n50 4 3" }
      let(:valid) { 0 }

      it { is_expected.to eq(valid) }
    end

    context "all invalid with lots of whitespace" do
      let(:input) { " 3 4  50 \n 50 4  3\n" }
      let(:valid) { 0 }

      it { is_expected.to eq(valid) }
    end

    context "sample input" do
      let(:input) { File.open("spec/advent_03_sample.txt").read }
      let(:valid) { 2 }

      it { is_expected.to eq(valid) }
    end

    context "actual input" do
      let(:input) { File.open("spec/advent_03_input.txt").read }
      let(:valid) { 869 }

      it { is_expected.to eq(valid) }
    end

    context "when input is actually vertical" do
      let(:service) { Advent03Vertical.new }

      context "all valid triangles" do
        let(:input) {
          "3  4  5\n" +
          "4  5  3\n" +
          "5  3  4"
        }
        let(:valid) { 3 }

        it { is_expected.to eq(valid) }
      end

      context "sample input" do
        let(:input) { File.open("spec/advent_03_sample.txt").read }
        let(:valid) { 1 }

        it { is_expected.to eq(valid) }
      end

      context "actual input" do
        let(:input) { File.open("spec/advent_03_input.txt").read }
        let(:valid) { 1544 }

        it { is_expected.to eq(valid) }
      end
    end
  end
end
