StateMachine = Class{}

-- every statemachine has the following functions whether empty or not
function StateMachine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}
	self.states = states or {} -- [name] -> [function that returns states]
	self.current = self.empty
end

--changing state will perform entry and exit functions
function StateMachine:change(stateName, enterParams)
	assert(self.states[stateName]) -- state must exist!
	self.current:exit()
	self.current = self.states[stateName]()
	self.current:enter(enterParams)
end

--updating the state machine will call the update functin for the current state
function StateMachine:update(dt)
	self.current:update(dt)
end
-- calls current states render function
function StateMachine:render()
	self.current:render()
end