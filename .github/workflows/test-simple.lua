-- Ultra-simple test filter - just adds visible text
function Pandoc(doc)
  -- Add debug text at the very beginning
  local debug_text = pandoc.Para({pandoc.Strong({pandoc.Str("[LUA FILTER IS WORKING!]")})})
  table.insert(doc.blocks, 1, debug_text)
  return doc
end
