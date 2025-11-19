-- Pandoc Lua filter to remove manual table of contents from PDF generation
-- This filter removes the section between the page break div and the separator

local in_manual_toc = false
local found_page_break = false

function Div(elem)
  -- Check if this is the page break div
  if elem.attributes.style and elem.attributes.style:match("page%-break%-after") then
    found_page_break = true
    in_manual_toc = true
    return elem  -- Keep the page break
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
