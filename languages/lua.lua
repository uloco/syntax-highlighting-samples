-- line comment
--[[ block
     comment ]]
local socket = require("socket")
Global = "mutable global"

local Vec = {}
Vec.__index = Vec

function Vec.new(x, y)
  return setmetatable({ x = x or 0.0, y = y or 0xFF, tags = { "a", 'b\n\65', [3] = nil } }, Vec)
end

function Vec:len()
  return math.sqrt(self.x ^ 2 + self.y ^ 2)
end

Vec.__add = function(a, b) return Vec.new(a.x + b.x, a.y + b.y) end
Vec.__tostring = function(self) return ("<%d,%d>"):format(self.x, self.y) end

local function sum(first, ...)
  local rest = { ... }
  local total, count = first, select("#", ...)
  for i = 1, count, 1 do total = total + rest[i] end
  return total, count, #rest
end

local raw = [[long
string]]
local nested = [==[has ]] inside]==]
local nums = { 3, 0xFF, 1e3, 0.5e-2, 3.14 }
local bits = ((0xF0 & 0x0F) | (1 << 4)) ~ (7 >> 1) // 2

local function classify(n)
  if n > 100 and not (n % 2 == 0) then
    return "big-odd"
  elseif n == 0 or n == nil then
    return "zero"
  else
    return "other" .. tostring(n)
  end
end

local i = 0
while i < 3 do i = i + 1 end
repeat i = i - 1 until i <= 0

for k, v in pairs({ alpha = true, beta = false }) do
  if k == "beta" then goto continue end
  io.write(k, "=", tostring(v), "\n")
  ::continue::
end

for idx, item in ipairs({ "x", "y" }) do
  print(string.upper(item):rep(idx), os.clock(), table.concat({ item }, ","))
end

local ok, err = pcall(function() error({ code = 42 }) end)
if not ok then print(type(err), err.code) end

local co = coroutine.create(function(a)
  local b = coroutine.yield(a * 2)
  return b
end)
print(coroutine.resume(co, 21), coroutine.status(co))

local v = Vec.new(1.5, 2) + Vec.new(3, 4)
local label = (#raw > 4) and "long" or "short"
print(tostring(v), v:len(), classify(nums[2]), label, nested, bits, Global, socket, sum(1, 2, 3))
