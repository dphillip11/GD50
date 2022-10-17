Glide = Class{}

function Glide:init(path, s, stop)
    self.stop = stop
    self.stopped = 0
    self.path = path
    self.t = 0
    self.interval = s
    self.x1 = path[1]
    self.x2 = path[2]
    self.pathCursor = 1
    self.dx = (self.x2 - self.x1)/self.interval
end

function Glide:update(dt)
    if self.t < self.interval then
        self.t = self.t + dt
        self.x1 = self.x1 + self.dx * dt
        return self.x1
    else 
        self.x1 = self.x2
        return self:finish(dt)
    end
end

function Glide:finish()
    if self.stop == 'false' then
        self.pathCursor = math.max(1, (self.pathCursor + 1 )% (table.getn(self.path) + 1))
        self.t = 0
        self.x1 = self.x2
        self.x2 = self.path[math.max(1, (self.pathCursor + 1) % (table.getn(self.path) + 1))]
        self.dx = (self.x2 - self.x1)/self.interval
        return self.x1
    else
        if self.pathCursor == #self.path - 1 then
            self.stopped=1
            return self.x1
        else
            self.pathCursor = self.pathCursor + 1
            self.t = 0
            self.x1 = self.x2
            self.x2 = self.path[self.pathCursor + 1]
            self.dx = (self.x2 - self.x1)/self.interval
            return self.x1
        end
    end
end


