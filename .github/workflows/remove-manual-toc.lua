-- Pandoc Lua filter to insert TOC after cover page and remove manual TOC
-- This ensures: Cover page -> Page break -> Pandoc TOC -> Content

local in_manual_toc = false
local found_page_break = false
local toc_inserted = false

function Div(elem)
  -- Check if this is the page break div
  if elem.attributes.style and elem.attributes.style:match("page%-break%-after") then
    found_page_break = true
    in_manual_toc = true

    -- After the page break, insert the Pandoc-generated TOC
    -- Use a placeholder that Pandoc will recognize
    local toc_placeholder = pandoc.RawBlock('latex', '\\tableofcontents\n\\newpage')

    return {elem, toc_placeholder}  -- Return both the page break and TOC
  end
  return elem
end

function Header(elem)
  -- If we're in the manual TOC section and find a header
  if in_manual_toc and elem.level == 2 then
    -- Check if this is the "Содержание" or other TOC headers
    local text = pandoc.utils.stringify(elem)
    if text == "Содержание" or text == "Table of Contents" or
       text == "Inhaltsverzeichnis" or text == "Spis treści" then
      return {}  -- Remove this header
    end
  end
  -- If we hit a level 1 header, we're past the TOC
  if elem.level == 1 then
    in_manual_toc = false
  end
  return elem
end

function BulletList(elem)
  -- Remove bullet lists in the manual TOC section
  if in_manual_toc then
    return {}
  end
  return elem
end

function HorizontalRule(elem)
  -- The --- separator marks the end of manual TOC
  if in_manual_toc and found_page_break then
    in_manual_toc = false
    return {}  -- Remove the separator itself
  end
  return elem
end

-- Return the filter functions
return {
  {Div = Div},
  {Header = Header},
  {BulletList = BulletList},
  {HorizontalRule = HorizontalRule}
}
