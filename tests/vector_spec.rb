# my_class_spec.rb
require 'rspec'
require_relative '../src/vector'

describe Vector do

  describe "Vector operations" do
    it "plus and minus" do
      v1 = Vector.new(1, 2)
      v2 = Vector.new(3, 4)

      expect((v1 + v2).x).to eq(4)
      expect((v1 + v2).y).to eq(6)

      expect((v1 - v2).x).to eq(-2)
      expect((v1 - v2).y).to eq(-2)
    end

    it "eq" do
      v1 = Vector.new(1, 2)
      v2 = Vector.new(1, 2)
      v3 = Vector.new(2, 1)
      v4 = Vector.new(5, 7)

      expect(v1 == v2).to eq(true)
      expect(v1 == v3).to eq(false)
      expect(v1 == v4).to eq(false)
    end
  end
end
