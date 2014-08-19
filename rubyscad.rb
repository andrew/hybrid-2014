require "rubyscad"

class MyShape

  include RubyScad

  def render()
    difference do
      union do
        cube(size: [30, 30, 30])
        cube(size: [60, 10, 10])
      end
      
      translate(v: [30, 30, 30]) do
        sphere(r: 20)
      end
    end
  end
end

MyShape.new.render
