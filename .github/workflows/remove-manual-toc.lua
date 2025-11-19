-- Pandoc Lua filter to insert TOC after cover page and remove manual TOC
-- This ensures: Cover page -> Page break -> Pandoc TOC -> Content

local in_manual_toc = false
local found_page_break = false
local cover_complete = false

-- Process the document to find page break and remove manual TOC
function Pandoc(doc)
  local new_blocks = {}
  local i = 1

  while i <= #doc.blocks do
    local block = doc.blocks[i]

    -- Check if this is a RawBlock with page break HTML
    if block.t == "RawBlock" and block.format == "html" then
      local html = block.text
      if html:match('page%-break%-after') then
        -- Found page break - keep it
        table.insert(new_blocks, block)

        -- Insert LaTeX page break and TOC
        table.insert(new_blocks, pandoc.RawBlock('latex', '\\newpage'))
        table.insert(new_blocks, pandoc.RawBlock('latex', '\\tableofcontents'))
        table.insert(new_blocks, pandoc.RawBlock('latex', '\\newpage'))

        -- Mark that we're now in manual TOC section
        in_manual_toc = true
        found_page_break = true
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
