require 'gosu'

#ZORDER Constant Stuffs (Gaming 3D Dimension x,y,z )
module ZOrder
  BACKGROUND,STARS,PLAYER,UI = *0..3
end


#Main class
class Tutorial < Gosu::Window
  def initialize
    super 800,600 #resolution
    self.caption ="Thuta's Awesome Spaceship Game" #title of apps
   
    @background_image = Gosu::Image.new("/Users/thuta/Documents/Aptana_Studio_Workspace/Ruby/Assets/Images/Space.png", :tileable => true)
   
    @player= Player.new #mainPlayerClass initialiting
    @player.warp(400,300) #warp(x,y)
   
    @star_anim = Gosu::Image.load_tiles("/Users/thuta/Documents/Aptana_Studio_Workspace/Ruby/Assets/Images/star.png", 25, 25)
    @stars = Array.new
    
    @font = Gosu::Font.new(20)
    
  end
  
  def update
     if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT or Gosu::button_down? Gosu::KB_A
      @player.turn_left
    end
    
    if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT or Gosu::button_down? Gosu::KB_D
      @player.turn_right
    end
    
    if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_BUTTON_0 or Gosu::button_down? Gosu::KB_W
      @player.accelerate
    end
    
    if Gosu.button_down? Gosu::KB_DOWN or Gosu::button_down? Gosu::GP_BUTTON_1 or Gosu::button_down? Gosu::KB_S
      @player.de_accelerate
    end
    
    @player.move
    @player.collect_stars(@stars)

    if rand(100) < 4 and @stars.size < 25
      @stars.push(Star.new(@star_anim))
    end
    
  end
  
  def draw
    
    @player.draw
    @background_image.draw(0,0,ZOrder::BACKGROUND)
    @stars.each { |star| star.draw }
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    
  end
  
  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close
    else
      super
    end
  end
  
end

#Player Class
class Player
  attr_reader :score
  
  def initialize
    @image = Gosu::Image.new("/Users/thuta/Documents/Aptana_Studio_Workspace/Ruby/Assets/Images/ship.png")
    @beep = Gosu::Sample.new("/Users/thuta/Documents/Aptana_Studio_Workspace/Ruby/Assets/Images/beep.wav")
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0
  end
  
  def warp(x,y)
    @x,@y = x,y 
  end
  
  def turn_right
    @angle -= 4.5
  end
  
  def turn_left
    @angle += 4.5
  end
  
  def accelerate
    @vel_x += Gosu.offset_x(@angle,0.5)
    @vel_y += Gosu.offset_y(@angle,0.5)
  end
   
  def de_accelerate
    @vel_x -= Gosu.offset_x(@angle,0.5)
    @vel_y -= Gosu.offset_y(@angle,0.5)
  end
  
  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 800
    @y %= 600
    
    @vel_x *= 0.95
    @vel_y *= 0.95
  end
  
  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end
  
  def score
    @score
  end

  def collect_stars(stars)
    stars.reject! do |star|
      if Gosu.distance(@x, @y, star.x, star.y) < 35
        @score += 10
        @beep.play
        true
      else
        false
      end
    end
  end
  
end


#Star Class
class Star
  attr_reader :x,:y
  def initialize(animation)
    @animation = animation
    @color = Gosu::Color::BLACK.dup
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
    @x = rand * 800
    @y = rand * 600
  end
  
  def draw
    img = @animation[Gosu.milliseconds / 100 % @animation.size]
    img.draw(@x - img.width / 2.0, @y - img.height / 2.0,
        ZOrder::STARS, 1, 1, @color, :add)
  end
end


Tutorial.new.show

#reference https://github.com/gosu/gosu/wiki/Ruby-Tutorial