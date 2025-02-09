Entity = Object:extend()

function Entity:new(x, y, image_path)
    self.x = x
    self.y = y
    self.image = love.graphics.newImage(image_path)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.last = {}
    self.last.x = self.x
    self.last.y = self.y
end

function Entity:update(dt)
    self.last.x = self.x
    self.last.y = self.y
end

function Entity:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

-- Corrigir o nome do método para "checkCollision"
function Entity:checkCollision(e)
    return self.x + self.width > e.x 
    and self.x < e.x + e.width 
    and self.y + self.height > e.y 
    and self.y < e.y + e.height
end

function Entity:wasVerticalyAligned(e)
  return self.last.y < e.last.y + e.height
  and self.last.y + self.height > e.last.y
end

function Entity:wasHorizontallyAligned(e)
    return self.last.x < e.last.x + e.width 
    and self.last.x + self.width > e.last.x
end

function Entity:resolveCollision(e)
    if self:checkCollision(e) then
        if self:wasVerticallyAligned(e) then
            if self.x + self.width / 2 < e.x + e.width / 2 then
                -- pusback = the right side of the player - the left side of the wall
                local pushback = self.x + self.width - e.x
                self.x = self.x - pushback
            else
                -- pusback = the right side of the wall - the left side of the player
                local pushback = e.x + e.width - self.x
                self.x = self.x + pushback
            end
        elseif self:wasHorizontallyAligned(e) then
            if self.y + self.height / 2 < e.y + e.height / 2 then
                -- pusback = the bottom side of the player - the top side of the wall
                local pushback = self.y + self.height - e.y
                self.y = self.y - pushback
            else
                -- pusback = the bottom side of the wall - the top side of the player
                local pushback = e.y + e.height - self.y
                self.y = self.y + pushback
            end
        end
    end
end
