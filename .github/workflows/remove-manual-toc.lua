-- Pandoc Lua filter to insert TOC after cover page and remove manual TOC
-- This ensures: Cover page -> Page break -> Pandoc TOC -> Content

local in_manual_toc = false
local found_page_break = false

-- Image filter runs first - resize all images on title page (before first Header)
local seen_first_header = false
function Image(img)
  if not seen_first_header then
    -- We're still on the title page
    img.attributes.width = "70%"
  end
  return img
end

-- Header filter to track when we've left the title page
function Header(h)
  seen_first_header = true
  return h
end

-- Process the document to find page break and remove manual TOC
function Pandoc(doc)
  local new_blocks = {}
  local i = 1

  -- Add commands at the beginning to remove page number from title page
  table.insert(new_blocks, pandoc.RawBlock('latex', '\\thispagestyle{empty}'))

  while i <= #doc.blocks do
    local block = doc.blocks[i]

    -- Check for Div element (HTML divs become Pandoc Divs)
    if block.t == "Div" then
      local has_page_break = false

      -- Check if Div has style attribute with page-break-after
      if block.attributes and block.attributes.style then
        if block.attributes.style:match('page%-break%-after') then
          has_page_break = true
        end
      end

      -- Also check if Div is empty and might be the page break div
      if block.content and #block.content == 0 and block.attributes then
        -- Empty div with attributes might be our page break
        for k, v in pairs(block.attributes) do
          if tostring(v):match('page%-break') then
            has_page_break = true
          end
        end
      end

      if has_page_break then
        found_page_break = true
        -- Found page break div - insert page break
        table.insert(new_blocks, pandoc.RawBlock('latex', '\\newpage'))

        -- Insert TOC with proper formatting
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
        found_page_break = true
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

-- Return filter table with all functions
return {
  Image = Image,
  Header = Header,
  Pandoc = Pandoc
}
