require "spec_helper"

class Advent04
  attr_reader :sector_id_sum

  def initialize
    @sector_id_sum = 0
  end

  def call(input, looking_for = nil)
    returning_value = nil

    input.split("\n").reject(&:empty?).map do |line|
      room = RoomIdentifier.new(line)
      @sector_id_sum += room.sector_id if room.valid?

      room.do_rotate!

      returning_value = room.sector_id if room.room_name == looking_for
    end

    returning_value
  end
end

class RoomIdentifier
  attr_reader :id, :room_name, :sector_id, :checksum

  def initialize(id)
    @id = id

    @room_name, @sector_id, @checksum = /^([a-z\-]+)-([0-9]+)\[([a-z]+)\]$/.match(id).captures
    @sector_id = sector_id.to_f
  end

  def valid?
    checksum_for(room_name) == checksum
  end

  def checksum_for(name)
    name.chars.uniq.select { |char| /^[a-z]$/.match(char) }.map do |char|
      [char, name.count(char)]
    end.sort_by do |char, count|
      [-count, char]
    end.first(5).map do |char, count|
      char
    end.join("")
  end

  CHARS = ('a'..'z').to_a

  def rotate_by(n)
    @room_name = room_name.chars.map do |char|
      if char == "-"
        " "
      else
        i = (char.ord - 'a'.ord) + n
        CHARS[i % CHARS.length]
      end
    end.join("")
  end

  def do_rotate!
    rotate_by(sector_id.to_i)
  end
end

describe RoomIdentifier do
  subject(:room) { RoomIdentifier.new(id)}

  context "first example" do
    let(:id) { "aaaaa-bbb-z-y-x-123[abxyz]" }
    it { is_expected.to be_valid }
  end

  context "second example" do
    let(:id) { "a-b-c-d-e-f-g-h-987[abcde]" }
    it { is_expected.to be_valid }
  end

  context "third example" do
    let(:id) { "not-a-real-room-404[oarel]" }
    it { is_expected.to be_valid }
  end

  context "fourth example" do
    let(:id) { "totally-real-room-200[decoy]" }
    it { is_expected.to_not be_valid }
  end

  context "an encrypted name" do
    let(:id) { "qzmt-zixmtkozy-ivhz-343[ignored]" }

    context "#rotate_by(0)" do
      before { room.rotate_by(0) }

      it "unencrypts" do
        expect(room.room_name).to eq("qzmt zixmtkozy ivhz")
      end
    end

    context "#rotate_by(343)" do
      before { room.rotate_by(343) }

      it "unencrypts" do
        expect(room.room_name).to eq("very encrypted name")
      end
    end

    context "#do_rotate!" do
      before { room.do_rotate! }

      it "unencrypts" do
        expect(room.room_name).to eq("very encrypted name")
      end
    end
  end
end

describe Advent04 do
  let(:service) { Advent04.new }

  context "when called" do
    let(:looking_for) { nil }
    before do
      @result = service.call(input, looking_for)
    end

    subject { service.sector_id_sum }

    context "sample input" do
      let(:input) { File.open("spec/advent_04_sample.txt").read }
      let(:valid) { 1514 }

      it { is_expected.to eq(valid) }
    end

    context "actual input" do
      let(:input) { File.open("spec/advent_04_input.txt").read }
      let(:valid) { 409147 }

      it { is_expected.to eq(valid) }

      describe "when looking for the sector ID of the room where North Pole objects are stored" do
        let(:looking_for) { "northpole object storage" }

        it "finds the correct sector ID" do
          expect(@result).to eq(991)
        end
      end
    end
  end
end
