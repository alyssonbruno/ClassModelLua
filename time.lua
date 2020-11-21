--[[
  Time Class
  author: Alysson Bruno <alyssonbruno@gmail.com>
  ]]
local ClassModel = require 'ClassModel'
local Class = MAKE_CLASS(ClassModel, 'Time')
local triggers ={}

--[[ init default values ]]--
local init = function (obj)
  local o = obj or {}
  Class.self.second = o.second or 0
  Class.self.minute = o.minute or 0
  Class.self.hour = o.hour  or 0
  Class.self.day = o.day or 0
  Class.self.year = o.year or 0
  Class.self.century = o.century or 0
  Class.self.milennia = o.milennia or 0
  Class.self.thousand_milennia = o.thousand_milennia or 0 
  Class.self.eons = o.eons or 0
  Class.self.factor = Class.init_values[2] or o.factor or 1
  return Class.self
end

local exec_triggers = function(time)
  if triggers[time] ~= nil then
    for index,fun in ipairs(triggers[time]) do
      if type(fun) == "function" then
        local remove = fun(Class.public.getpublicdata())
        if remove then triggers[time][index]=nil end
      end
    end
  end
end

local trigger_time = function (actual, next, limit)
  local this = Class.self
  local changed = false
  while this[actual] >=limit do
    this[actual] = this[actual] - limit
    this[next] = this[next] + 1 
    exec_triggers(next)
  end
  return changed
end

  -- public methods
Class.public.tick = function ()
  local this = Class.self
  this.second = this.second + 1*this.factor 
  exec_triggers('second')
  trigger_time('second', 'minute', 60) 
  trigger_time('minute', 'hour', 60)
  trigger_time('hour', 'day', 24)
  trigger_time('day', 'year', 365)
  trigger_time('year', 'century', 100)
  trigger_time('century', 'milennia', 10)
  trigger_time('milennia', 'thousand_milennia', 1000)
  trigger_time('thousand_milennia', 'eons', 100)
end

Class.public.registertrigger = function(time, trigger)
  local this = Class.self
  if triggers[time] == nil then
    triggers[time] = {}
  end
  table.insert(triggers[time], trigger)
end

Class.public.setnewfactor = function(newfactor)
  local this = Class.self
  if type(newfactor) == "number" then
    this.factor = newfactor
  end
  return this.factor
end
 
 local create = function (...)
  Class.init_values = {...}
  init(Class.init_values[1])
  return Class.public
end

return create