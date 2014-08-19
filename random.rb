require "rubyscad"

class MyShape

  include RubyScad

  def random
    (rand*10).round
  end

  def random_coords
    [random, random, random]
  end

  def random_shape
    [:random_cube, :random_sphere, :random_cylinder].sample
  end

  def random_cube
    cube(size: random_coords)
  end

  def random_sphere
    sphere(r: random)
  end

  def random_cylinder
    cylinder(r: random, h: random)
  end

  def render
    difference do
      30.times do
        translate(v: random_coords) do
          send(random_shape)
        end
      end
    end
  end
end

MyShape.new.render

`/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD ruby.scad --render -o preview.png && open preview.png`
