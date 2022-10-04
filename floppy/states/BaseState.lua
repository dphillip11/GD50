-- in theory using the base state stops void calls from the statemachine, somehow has failed me a few times, perhaps an inclusion error
BaseState = Class{}

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end