--[[

luafixedtext - Fixed column text format in Lua.
BSD license.
by Sven Nilsen, 2012
http://www.cutoutpro.com

Version: 0.000 in angular degrees version notation
http://isprogrammingeasy.blogspot.no/2012/08/angular-degrees-versioning-notation.html

--]]

--[[
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies,
either expressed or implied, of the FreeBSD Project.
--]]

--[[

Fixed column text format is common in data sets for machine learning.
A fixed column text file format fills empty spaces like in the following example:

Cat                         3.300   25.600
Chimpanzee                 52.160  440.000
Chinchilla                   .425    6.400

Each column has a fixed width so a specification is necessary in addition to the data.

The fields are described using an array of column descriptors.
One column descriptor has 3 fields, one for type, one for name and one for width in characters.
There are only two types allowed, 'string' and 'number'.

local fields = {
  {"string", "name", 25},
  {"number", "body_weight_kg", 8},
  {"number", "brain_weight_g", 9}
}

--]]

-- Reads fixed column text format from file.
function fixedtext_ReadFile(filename, data, fields)
  local file = assert(io.open(filename, "r"))
  local start, info, field, type_str, name_str, size_str, sub_str
  for line in file:lines() do
    start = 1
    info = {}
    for i = 1, #fields do
      field = fields[i]
      type_str = field[1];
      name_str = field[2];
      size_str = field[3];
      
      sub_str = line:sub(start, start + size_str - 1)
      if type_str == "number" then sub_str = tonumber(sub_str) end
      
      info[name_str] = sub_str

      start = start + size_str;
    end
    
    data[#data + 1] = info
  end
  io.close(file)
end

-- Creates a string from an item and with an array of fields.
function fixedtext_ToString(item, fields)
  local str = ""
  local field
  local name_str, size_str
  for i = 1, #fields do
    field = fields[i]
    name_str = field[2]
    size_str = field[3]
    str = str .. string.format("%"..size_str.."s", item[name_str])
  end
  return str
end

