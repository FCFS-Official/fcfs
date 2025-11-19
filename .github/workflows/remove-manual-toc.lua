-- Pandoc Lua filter to insert TOC after cover page and remove manual TOC
-- This ensures: Cover page -> Page break -> Pandoc TOC -> Content

local in_manual_toc = false

-- Process the document to find page break and remove manual TOC
function Pandoc(doc)
  local new_blocks = {}
  local i = 1

  while i <= #doc.blocks do
    local block = doc.blocks[i]

    -- Debug: print block type
    io.stderr:write("Block " .. i .. ": " .. block.t .. "\n")
    if block.t == "Div" then
      io.stderr:write("  Div attributes: ")
      if block.attributes then
        for k, v in pairs(block.attributes) do
          io.stderr:write(k .. "=" .. v .. " ")
        end
      end
      io.stderr:write("\n")
    end
    if block.t == "RawBlock" then
      io.stderr:write("  Format: " .. block.format .. "\n")
      io.stderr:write("  Text: " .. block.text:sub(1, 50) .. "\n")
    end

    -- Check for Div element (HTML divs become Pandoc Divs)
    if block.t == "Div" and block.attributes and block.attributes.style then
      if block.attributes.style:match('page%-break%-after') then
        -- Found page break div - keep it as LaTeX page break
        table.insert(new_blocks, pandoc.RawBlock('latex', '\\newpage'))

        -- Insert TOC
        table.insert(new_blocks, pandoc.RawBlock('latex', '\\tableofcontents'))
        table.insert(new_blocks, pandoc.RawBlock('latex', '\\newpage'))

        -- Mark that we're now in manual TOC section
        in_manual_toc = true
        i = i + 1
        goto continue
      end
    end

    -- Check if this is RawBlock HTML (fallback)
    if block.t == "RawBlock" and block.format == "html" then
      if block.text:match('page%-break%-after') then
        -- Found page break - convert to LaTeX
        table.insert(new_blocks, pandoc.RawBlock('latex', '\\newpage'))

        -- Insert TOC
        table.insert(new_blocks, pandoc.RawBlock('latex', '\\tableofcontents'))
        table.insert(new_blocks, pandoc.RawBlock('latex', '\\newpage'))

        -- Mark that we're now in manual TOC section
        in_manual_toc = true
        i = i + 1
        goto continue
      end
    end

    -- If we're in manual TOC section, skip content until we hit the separator
    if in_manual_toc then
      -- Check for horizontal rule (---)
      if block.t == "HorizontalRule" then
        in_manual_toc = false
        i = i + 1
        goto continue
      end

      -- Skip this block (it's part of manual TOC)
      i = i + 1
      goto continue
    end

    -- Keep all other blocks
    table.insert(new_blocks, block)
    i = i + 1

    ::continue::
  end

  return pandoc.Pandoc(new_blocks, doc.meta)
end
