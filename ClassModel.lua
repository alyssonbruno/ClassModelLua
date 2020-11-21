--[[
# ClassModel Class
  refs: http://lua-users.org/wiki/ObjectOrientationTutorial
  author: Alysson Bruno <alyssonbruno@gmail.com>
  
  This model of class for lua is make with function. One class can be a Child.
]]
MAKE_CLASS = function(dad, child)
  local this = { 
    self={},
    public={ Class=child},
    instance={},
    init_values={},
    owner=nil,
    super = require 'ClassModel'
  }
  table.insert(this.instance,this.public.Class)
  local s = dad()
  if s then
    table.insert(this.instance,s.Class)
    for key, data in pairs(s) do
      if not this.public[key] then
        this.public[key] = data
      end
    end
    this.self = s.getpublicdata()
  end
  return this
end

local Class = function (...)
  local super = nil -- for child class make require 'dadclass' -- inheritance implemantation
  local owner = nil -- composition implemantation
  local public = { Class='ClassModel'}
  local self = {}
  local init_values = {...}
  local instance = {}

  local init = function (obj)
    local self = obj or {}
    return self
  end


  --[[  Class Definition functions ]]--
  public.getpublicdata = function()
    return self
  end
  
  public.isinstanceof = function(class)
    for _,c in pairs(instance) do
      if c == class then
        return true
      end
    end
    return false
  end
  
  public.getowner = function() 
    return owner 
  end
  
  table.insert(instance,public.Class)
  
  -- composition
  local c = init_values[1]
  if (type(c) == 'function') or (c and c.isinstanceof and c.isinstanceof('ClassModel')) then
    owner = table.remove(init_values,1)
    c=nil
  end
  
  -- inheritance
  local s = super and super(init_values[1]) or false
  if s then
    table.insert(instance,s.Class)
    for key, data in pairs(s) do
      if not public[key] then
        public[key] = data
      end
    end
    self = init(s.getpublicdata())
    s=nil
  else
    self = init(init_values[1])
  end
  
  return public
end

local ClassExport = Class
return ClassExport