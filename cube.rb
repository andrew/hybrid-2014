require "rubyscad"
require 'twitter'
require 'yaml'

class Cube

  include RubyScad

  def initialize(numbers)
    @numbers = numbers
    if expected_total > numbers.length
      @numbers += Array.new(expected_total - numbers.length).map!{ rand(50) }
    end
    @position = 0
  end

  def tweet_count
    @numbers.length
  end

  def size
    30
  end

  def next_number
    n = @numbers[@position]
    @position += 1
    return n
  end

  def cycles
    Math.sqrt(tweet_count/5).ceil
  end

  def fraction
    size.to_f/cycles
  end

  def expected_total
    cycles*cycles*5
  end

  def render
    union do
      # main cube
      cube(size: [size, size, size])

      # top
      cycles.times do |h|
        cycles.times do |i|
          translate(v: [fraction*i, fraction*h, size]) do
            cube(size: [fraction-1, fraction-1, next_number])
          end
        end
      end

      4.times do |g|
        cycles.times do |h|
          cycles.times do |i|
            rotate(y:180, z:g*90) do
              translate(v: [(g <= 1 ? 0 : size), ([1,2].include?(g) ? -1 : 1)*fraction*(i+([1,2].include?(g) ? 1 : 0)),-fraction*(h+1)]) do
                cube(size: [next_number, fraction-1, fraction-1])
              end
            end
          end
        end
      end

    end
  end
end


client = Twitter::REST::Client.new do |config|
  config.consumer_key    = "mJe69sQZSCfDMLpWB3nhnw"
  config.consumer_secret = "EgQBFo2Kd183kpcS4URNYyHScO28UF8gdug6UPg"
end

tweets = client.search("#hybridconfcube", :result_type => "recent").take(125)
File.open('tweets.yaml', 'w') {|f| f.write(YAML.dump(tweets)) }

tweets = YAML.load(File.read('tweets.yaml'))

valid_tweets = tweets.select do |tweet|
  tweet.text.match(/\d+/)
end

numbers = valid_tweets.map{|tweet| tweet.text.match(/\d+/)[0].to_i }.map{|n| [n, 100].min.abs.round }

puts valid_tweets.map{|t| "@#{t.user.screen_name}"}.uniq.sort

puts "Average: #{numbers.instance_eval { reduce(:+) / size.to_f }}"
puts "Total: #{numbers.length}"

Cube.new(numbers).render

 `/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD cube.scad -o cube.stl`
`git add cube.stl && git commit -m 'New cube coming in!' && git push --quiet`
`open https://github.com/andrew/hybrid-2014/blob/master/cube.stl`
