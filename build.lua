--[[
   Configuration script for l3build from the spanish-mathml-intent package.
   At the moment the possible targets that can be passed are:
   * tag        : Update the version and date (package, spmmli-tool and its
                  man page), regenerate the .sty and .lua copies in sources/
                  and spmmli-tool.man1.pdf if groff is found
   * doc        : Generate the documentation [-q]
   * unpack     : Unpacks the source files [-q]
   * install    : Install the package locally, you can use
                  it in conjunction with [--full] [--dry-run]
   * uninstall  : Uninstall the package locally
   * clean      : Clean the directory tree and repo
   * ctan       : Generate the compressed package (.zip); it first checks that
                  the PDFs of sources/test-pkg are up to date
   * upload     : Upload the package to ctan, you must add
                  -F ctan.ann in conjunction with [--debug]
   * tagcheck   : Check version and date in files
   * testSE     : Compile and validate (mathml-SE) the files in /tagged-test
   * testAF     : Same files in mathml-SE and mathml-AF (ghosts removed by spmmli-tool)
   * example    : Same as testAF for sources/test-pkg, copying the PDFs
   * testpdf    : Same as example for the files in /tagged-test,
                  leaving the PDFs there (name.pdf and name-AF.pdf)
   * release    : It performs the checks before generating a public
                  release (on git and ctan), commits the PDFs that example
                  and ctan regenerate and creates the git tag.
   The targets testSE, testAF and example accept file names (with or
   without .tex) to run only those files, as l3build check does with the
   names of the tests: l3build testAF spintent-04 spintent-05
--]]

-- General package identification
module     = "spanish-mathml-intent"
pkgversion = "1.1"
pkgdate    = "2026-10-22"
ltxrelease = "2026-11-01"

-- Configuration of files for build and installation
maindir        = "."
sourcefiledir  = "./sources"
textfiledir    = "./sources"
sourcefiles    = {"**/*.dtx", "**/*.ins"}
installfiles   = {"**/*.sty", "**/*.lua"}
scriptmanfiles = {"spmmli-tool.1"}
docfiles       = {"spmmli-tool.man1.pdf"}
tdslocations   = {
  "tex/lualatex/spanishmathmlintent/spanish-mathml-intent.sty",
  "tex/lualatex/spanishmathmlintent/spintent.lua",
  "doc/lualatex/spanishmathmlintent/spanish-mathml-intent.pdf",
  "doc/lualatex/spanishmathmlintent/README.md",
  "doc/man/man1/spmmli-tool.1",
  "doc/man/man1/spmmli-tool.man1.pdf",
  "scripts/spanish-mathml-intent/spmmli-tool.lua",
  "source/lualatex/spanishmathmlintent/spanish-mathml-intent.dtx",
  "source/lualatex/spanishmathmlintent/spanish-mathml-intent.ins",
}

-- Unpacking files from spanish-mathml-intent.ins
unpackfiles = { "spanish-mathml-intent.ins" }
unpackopts  = "--interaction=batchmode"
unpackexe   = "luatex"

-- Regression tests (l3build check / save): the .lvt files in ./testfiles.
-- ltxrelease needs the development format, so the tests run with latex-dev.
testfiledir  = "./testfiles"
checkengines = { "luatex" }
stdengine    = "luatex"
checkformat  = "latex-dev"

-- The mathml-SE structure elements carry sequential ids (ID.00012, ...): one
-- node more or less would shift all the following ones and flood the diff,
-- so the ids are not compared.
function normalize_log_hook(line)
  return (string.gsub(line, 'id="ID%.%d+"', 'id="ID.NN"'))
end

-- Typesetting spintent documentation step by step :)

function docinit_hook()
  local errorlevel = (cp("*mylhmc.lua", sourcefiledir, typesetdir) + cp("*mylhmc.sty", sourcefiledir, typesetdir))
  if errorlevel ~= 0 then
    error("** Error!!: Can't copy mylhmc.lua and mylhmc.lua files from "..sourcefiledir.." to "..typesetdir)
    return errorlevel
  end
  -- Examples attached to the manual (last section of spanish-mathml-intent.dtx): what is
  -- in sources/test-pkg is copied as it is. Nothing is checked here; the
  -- ctan target does it (see check_example_pdfs)
  local exdir = sourcefiledir.."/test-pkg"
  if direxists(exdir) then
    cp("*.tex", exdir, typesetdir)
    cp("*.pdf", exdir, typesetdir)
  end
  return 0
end

function typeset(file)
  local file = jobname(sourcefiledir.."/spanish-mathml-intent.dtx")
  print("** Running: arara "..file..".dtx")
  local errorlevel = runcmd("arara "..file..".dtx", typesetdir, {"TEXINPUTS","LUAINPUTS"})
  if errorlevel ~= 0 then
    error("Error!!: Typesetting "..file..".dtx")
    return errorlevel
  end
  return 0
end

-- Configuration for ctan
ctanreadme = "CTANREADME.md"
ctanpkg    = "spanish-mathml-intent"
ctanzip    = ctanpkg.."-"..pkgversion
packtdszip = false

--  Configuration for package distribution in ctan
uploadconfig = {
  author       = "Pablo González L",
  uploader     = "Pablo González L",
  email        = "pablgonz@yahoo.com",
  pkg          = ctanpkg,
  version      = pkgversion,
  license      = "lppl1.3c",
  summary      = "Spanish MathML intent for accessible (tagged) PDF with LuaLaTeX",
  description  = "This package adds MathML intent to mathematics written in Spanish with LuaLaTeX. "
    .. "The intent attribute tells a screen reader which concept an expression is and how to speak it, "
    .. "so that NVDA with MathCAT reads the formulas correctly in accessible (tagged) PDF documents. "
    .. "Its commands typeset and tag numbers, units, money, dates and times, geometry, algebra and "
    .. "statistics, each with the Spanish reading it should have. "
    .. "It is aimed at primary and secondary school teachers.",
  topic        = { "spanish", "luatex", "accessible", "teaching", "maths", "tagged-pdf" },
  ctanPath     = "/macros/latex/contrib/" .. ctanpkg,
  repository   = "https://github.com/pablgonz/" .. module,
  bugtracker   = "https://github.com/pablgonz/" .. module .. "/issues",
  support      = "https://github.com/pablgonz/" .. module .. "/issues",
  note         = [[Uploaded automatically by l3build...]],
  announcement_file="ctan.ann",
  update       = true
}

-- Clean files (spanish-mathml-intent.pdf is versioned in git, so clean must not remove it)
cleanfiles = {ctanzip..".curlopt", ctanzip..".zip"}

-- Update package date and version
tagfiles = {
  "sources/spanish-mathml-intent.dtx",
  "spmmli-tool.1",
  "sources/CTANREADME.md",
  "ctan.ann"
}

-- Line length helper (80 chars layout)
local function os_message(text)
  local mymax = 77 - string.len(text) - string.len("done")
  if mymax < 1 then mymax = 1 end
  print(text .. " " .. string.rep(".", mymax) .. " done")
end

-- Helper para detectar si un ejecutable existe en el PATH (Windows y Linux)
local function has_cmd(cmd)
  local is_windows = package.config:sub(1, 1) == "\\"
  local null_dev = os_null or (is_windows and "NUL" or "/dev/null")
  local check = is_windows and ("where " .. cmd .. " > " .. null_dev .. " 2>&1")
                           or ("command -v " .. cmd .. " > " .. null_dev .. " 2>&1")
  local res = os.execute(check)
  return (res == true or res == 0)
end

-- Helper to safely read file content
local function read_file(filepath)
  local f = io.open(filepath, "r")
  if not f then return nil end
  local content = f:read("*all")
  f:close()
  return content
end

-- Set by update_tag when spmmli-tool.1 is rewritten, so that the PDF version of
-- the man page is regenerated (see tag_hook)
local man_changed = false

-- Update function with smart check (avoids redundant rewrites) --
-- revisa PRIMERO si el archivo ya tiene el tag/fecha correctos antes
-- de tocar el contenido; si coincide, no ejecuta ningun gsub.
function update_tag(file, content, tagname, tagdate)
  tagname = pkgversion
  tagdate = pkgdate

  -- ¿Este archivo ya esta al dia?
  local already_ok = nil

  if string.match(file, "spanish%-mathml%-intent%.dtx$") then
    local fver = string.match(content, "\\def\\fileversion{%s*v?(.-)%s*}")
    local fdate = string.match(content, "\\def\\filedate{%s*(.-)%s*}")
    local pkgd, pkgv = string.match(content, "\\ProvidesExplPackage%s*{spanish%-mathml%-intent}%s*{(.-)}%s*{(.-)}")
    local ltxr = string.match(content, "\\NeedsTeXFormat%s*{LaTeX2e}%s*%[(%d%d%d%d%-%d%d%-%d%d)%]")
    local luav, luad = string.match(content, "%-%s*v(%d+%.%d+%a*)%s*%[(%d%d%d%d%-%d%d%-%d%d)%]")
    local spv = string.match(content, 'local%s+SPITOOL_VERSION%s*=%s*"(.-)"')
    already_ok = (fver == tagname and fdate == tagdate and pkgv == tagname
      and pkgd == tagdate and ltxr == ltxrelease and luav == tagname and luad == tagdate
      and spv == tagname)

  elseif string.match(file, "spanish%-mathml%-intent%.sty$") then
    local pkgd, pkgv = string.match(content, "\\ProvidesExplPackage%s*{spanish%-mathml%-intent}%s*{(.-)}%s*{(.-)}")
    local ltxr = string.match(content, "\\NeedsTeXFormat%s*{LaTeX2e}%s*%[(%d%d%d%d%-%d%d%-%d%d)%]")
    already_ok = (pkgv == tagname and pkgd == tagdate and ltxr == ltxrelease)

  elseif string.match(file, "spintent%.lua$") then
    local luav, luad = string.match(content, "%-%s*v(%d+%.%d+%a*)%s*%[(%d%d%d%d%-%d%d%-%d%d)%]")
    already_ok = (luav == tagname and luad == tagdate)

  elseif string.match(file, "spmmli%-tool%.lua$") then
    local spv = string.match(content, 'local%s+SPITOOL_VERSION%s*=%s*"(.-)"')
    already_ok = (spv == tagname)

  elseif string.match(file, "spmmli%-tool%.1$") then
    local mand, manv = string.match(content, '%.TH%s+SPMMLI%-TOOL%s+1%s+"(%d%d%d%d%-%d%d%-%d%d)"%s+"spmmli%-tool%s+(.-)"')
    already_ok = (manv == tagname and mand == tagdate)

  elseif string.match(file, "CTANREADME%.md$") then
    local m_readmev, m_readmed = string.match(content, "Release%s+(v%d+%.%d+%a*)%s+\\%[(%d%d%d%d%-%d%d%-%d%d)\\%]")
    already_ok = (m_readmev == "v" .. tagname and m_readmed == tagdate)

  elseif string.match(file, "ctan%.ann$") then
    local annv = string.match(content, "v%d+%.%d+%a*")
    already_ok = (annv == "v" .. tagname)
  end

  if already_ok then
    print("** " .. file .. " is already up to date")
    return content
  end

  local original_content = content

  -- Substitutions in spanish-mathml-intent.dtx
  if string.match(file, "spanish%-mathml%-intent%.dtx$") then
    content = string.gsub(content, "\\def\\fileversion{%s*v?.-%s*}", "\\def\\fileversion{v" .. tagname .. "}")
    content = string.gsub(content, "\\def\\filedate{%s*.-%s*}", "\\def\\filedate{" .. tagdate .. "}")
    content = string.gsub(content, "(\\ProvidesExplPackage%s*{spanish%-mathml%-intent}%s*){[^}]+}%s*{[^}]+}", "%1{" .. tagdate .. "} {" .. tagname .. "}")
    content = string.gsub(content, "(\\NeedsTeXFormat{LaTeX2e})%[%d%d%d%d%-%d%d%-%d%d%]", "%1[" .. ltxrelease .. "]")
    content = string.gsub(content, "(%-%s*v)%d+%.%d+%a*%s*%[%d%d%d%d%-%d%d%-%d%d%]", "%1" .. tagname .. " [" .. tagdate .. "]")
    content = string.gsub(content, '(local%s+SPITOOL_VERSION%s*=%s*)"[^"]*"', '%1"' .. tagname .. '"')
  end

  -- Substitutions in spanish-mathml-intent.sty
  if string.match(file, "spanish%-mathml%-intent%.sty$") then
    content = string.gsub(content, "(\\ProvidesExplPackage%s*{spanish%-mathml%-intent}%s*){[^}]+}%s*{[^}]+}", "%1{" .. tagdate .. "} {" .. tagname .. "}")
    content = string.gsub(content, "(\\NeedsTeXFormat{LaTeX2e})%[%d%d%d%d%-%d%d%-%d%d%]", "%1[" .. ltxrelease .. "]")
  end

  -- Substitutions in spintent.lua
  if string.match(file, "spintent%.lua$") then
    content = string.gsub(content, "(%-%s*v)%d+%.%d+%a*%s*%[%d%d%d%d%-%d%d%-%d%d%]", "%1" .. tagname .. " [" .. tagdate .. "]")
  end

  -- Substitutions in spmmli-tool.lua
  if string.match(file, "spmmli%-tool%.lua$") then
    content = string.gsub(content, '(local%s+SPITOOL_VERSION%s*=%s*)"[^"]*"', '%1"' .. tagname .. '"')
  end

  -- Substitutions in spmmli-tool.1 (the man page): date and version of .TH
  if string.match(file, "spmmli%-tool%.1$") then
    content = string.gsub(content, '(%.TH%s+SPMMLI%-TOOL%s+1%s+)"%d%d%d%d%-%d%d%-%d%d"(%s+)"spmmli%-tool%s+[^"]*"',
      '%1"' .. tagdate .. '"%2"spmmli-tool ' .. tagname .. '"')
    man_changed = true
  end

  -- Substitutions in CTANREADME.md
  if string.match(file, "CTANREADME%.md$") then
    content = string.gsub(content, "Release v%d+%.%d+%a*%s*\\%[%d%d%d%d%-%d%d%-%d%d\\%]", "Release v" .. tagname .. " \\[" .. tagdate .. "\\]")
  end

  -- Substitutions in ctan.ann
  if string.match(file, "ctan%.ann$") then
    content = string.gsub(content, "v%d+%.%d+%a*", "v" .. tagname)
  end

  print("** " .. file .. " has been tagged with version " .. tagname .. " and date " .. tagdate)

  return content
end

-- Individual verification functions
local function check_dtx_tags()
  local content = read_file("sources/spanish-mathml-intent.dtx")
  if not content then return false end

  local fver = string.match(content, "\\def\\fileversion{%s*v?(.-)%s*}")
  local fdate = string.match(content, "\\def\\filedate{%s*(.-)%s*}")
  local pkgd, pkgv = string.match(content, "\\ProvidesExplPackage%s*{spanish%-mathml%-intent}%s*{(.-)}%s*{(.-)}")
  local ltxr = string.match(content, "\\NeedsTeXFormat%s*{LaTeX2e}%s*%[(%d%d%d%d%-%d%d%-%d%d)%]")
  local luav, luad = string.match(content, "%-%s*v(%d+%.%d+%a*)%s*%[(%d%d%d%d%-%d%d%-%d%d)%]")
  local spv = string.match(content, 'local%s+SPITOOL_VERSION%s*=%s*"(.-)"')

  if fver ~= pkgversion or fdate ~= pkgdate or pkgv ~= pkgversion or pkgd ~= pkgdate or ltxr ~= ltxrelease or luav ~= pkgversion or luad ~= pkgdate or spv ~= pkgversion then
    print("** Warning: Mismatches found in sources/spanish-mathml-intent.dtx")
    return false
  end
  os_message("Checking version, date, and LaTeX release in spanish-mathml-intent.dtx (and spmmli-tool)")
  return true
end

local function check_sty_tags()
  local content = read_file("sources/spanish-mathml-intent.sty")
  if not content then return true end

  local pkgd, pkgv = string.match(content, "\\ProvidesExplPackage%s*{spanish%-mathml%-intent}%s*{(.-)}%s*{(.-)}")
  local ltxr = string.match(content, "\\NeedsTeXFormat%s*{LaTeX2e}%s*%[(%d%d%d%d%-%d%d%-%d%d)%]")

  if pkgv ~= pkgversion or pkgd ~= pkgdate or ltxr ~= ltxrelease then
    print("** Warning: Mismatches found in sources/spanish-mathml-intent.sty")
    return false
  end
  os_message("Checking version, date, and LaTeX release in spanish-mathml-intent.sty")
  return true
end

local function check_lua_tags()
  local content = read_file("sources/spintent.lua")
  if not content then return true end

  local luav, luad = string.match(content, "%-%s*v(%d+%.%d+%a*)%s*%[(%d%d%d%d%-%d%d%-%d%d)%]")

  if luav ~= pkgversion or luad ~= pkgdate then
    print("** Warning: Mismatches found in sources/spintent.lua")
    return false
  end
  os_message("Checking version and date in spintent.lua")
  return true
end

local function check_spitool_tags()
  local ok = true
  local lua = read_file("sources/spmmli-tool.lua")
  if lua then
    local spv = string.match(lua, 'local%s+SPITOOL_VERSION%s*=%s*"(.-)"')
    if spv ~= pkgversion then
      print("** Warning: Mismatches found in sources/spmmli-tool.lua")
      ok = false
    else
      os_message("Checking version in spmmli-tool.lua")
    end
  end
  local man = read_file("spmmli-tool.1")
  if not man then
    print("** Warning: spmmli-tool.1 not found")
    return false
  end
  local mand, manv = string.match(man, '%.TH%s+SPMMLI%-TOOL%s+1%s+"(%d%d%d%d%-%d%d%-%d%d)"%s+"spmmli%-tool%s+(.-)"')
  if manv ~= pkgversion or mand ~= pkgdate then
    print("** Warning: Mismatches found in spmmli-tool.1")
    ok = false
  else
    os_message("Checking version and date in spmmli-tool.1")
  end
  return ok
end

local function check_readme_tags()
  local content = read_file("sources/CTANREADME.md")
  if not content then return false end

  local target_version = "v" .. pkgversion
  local m_readmev, m_readmed = string.match(content, "Release%s+(v%d+%.%d+%a*)%s+\\%[(%d%d%d%d%-%d%d%-%d%d)\\%]")

  if target_version ~= m_readmev or pkgdate ~= m_readmed then
    print("** Warning: Mismatches found in sources/CTANREADME.md")
    return false
  end
  os_message("Checking version and date in README.md")
  return true
end

-- Unified verification runner
local function check_all_tags()
  local ok_dtx = check_dtx_tags()
  local ok_sty = check_sty_tags()
  local ok_lua = check_lua_tags()
  local ok_spitool = check_spitool_tags()
  local ok_readme = check_readme_tags()
  return ok_dtx and ok_sty and ok_lua and ok_spitool and ok_readme
end

-- Regenerates the copies of the .sty and .lua files in sources/ from the .dtx
-- and the .ins, so that they carry what 'l3build tag' just wrote in the .dtx.
local function unpack_copies()
  local file = jobname(sourcefiledir .. "/spanish-mathml-intent.ins")
  local errorlevel = run(sourcefiledir, "luatex --interaction=batchmode " .. file .. ".ins > " .. os_null)
  if errorlevel ~= 0 then
    error("** Error!!: Failed to process " .. file .. ".ins with luatex")
  end
  rm(sourcefiledir, file .. ".log")
  os_message("Regenerated the .sty and .lua copies from " .. file .. ".ins")
end

-- 'l3build tag' does not run redundant checks after writing; it regenerates
-- the .sty and .lua copies in sources/ and, when spmmli-tool.1 was just tagged
-- (or the PDF is missing), the PDF version of the man page. groff -Tpdf needs
-- the full groff package (the pdf device); without it the PDF is left as it
-- is and a warning is printed.
function tag_hook(tagname)
  unpack_copies()
  local manpdf = maindir .. "/spmmli-tool.man1.pdf"
  if not (man_changed or not fileexists(manpdf)) then
    os_message("spmmli-tool.man1.pdf is up to date")
    return 0
  end
  if not has_cmd("groff") then
    print("** Warning: groff not found: spmmli-tool.man1.pdf was not regenerated")
    return 0
  end
  local tmpfile = "spmmli-tool.man1.pdf.tmp"
  local errorlevel = run(maindir, "groff -man -Tpdf spmmli-tool.1 > " .. tmpfile .. " 2> " .. os_null)
  if errorlevel ~= 0 then
    rm(maindir, tmpfile)
    print("** Warning: 'groff -man -Tpdf' failed (is the groff pdf device installed?): spmmli-tool.man1.pdf was not regenerated")
    return 0
  end
  rm(maindir, "spmmli-tool.man1.pdf")
  ren(maindir, tmpfile, "spmmli-tool.man1.pdf")
  os_message("Generated spmmli-tool.man1.pdf from spmmli-tool.1")
  return 0
end

-- Standalone audit target: l3build tagcheck
target_list.tagcheck = {
  desc = "Check version and date in files",
  help = "Reports every file whose version or date differs from build.lua.",
  func = function()
    if check_all_tags() then return 0 end
    return 1
  end,
}

-- Helper function to generate an isolated build environment --
local function system_temp_dir()
  local is_windows = package.config:sub(1, 1) == "\\"
  if is_windows then
    return os.getenv("TEMP") or os.getenv("TMP") or "C:\\Windows\\Temp"
  else
    return os.getenv("TMPDIR") or "/tmp"
  end
end

local function make_tmp_dir()
  -- Unified tag verification before unpacking
  if not check_all_tags() then
    error("** Error!!: Tag verification failed before preparing environment")
  end

  local sep = package.config:sub(1, 1)
  local base = system_temp_dir()
  local tmpname = os.tmpname()
  local unique = tmpname:match("([^/\\]+)$") or tostring(os.time())
  os.remove(tmpname) -- os.tmpname() a veces crea el archivo vacio; no hace falta

  tmpdir = base .. sep .. "spintent-build-" .. unique -- Global variable consumed by custom targets

  -- Create temporary directory
  local errorlevel = mkdir(tmpdir)
  if errorlevel ~= 0 then
    error("** Error!!: Could not create temporary directory " .. tmpdir)
  else
    os_message("Creating temporary directory " .. tmpdir)
  end

  -- Copy source files (.dtx and .ins)
  errorlevel = cp("*.dtx", sourcefiledir, tmpdir) + cp("*.ins", sourcefiledir, tmpdir)
  if errorlevel ~= 0 then
    error("** Error!!: Failed to copy source files to " .. tmpdir)
  else
    os_message("Copying spanish-mathml-intent.dtx and spanish-mathml-intent.ins to " .. tmpdir)
  end

  -- Unpack source files
  os_message("Unpacking source files in " .. tmpdir)
  local file = jobname("spanish-mathml-intent.ins")
  errorlevel = run(tmpdir, "luatex -interaction=batchmode " .. file .. ".ins > " .. os_null)
  if errorlevel ~= 0 then
    local f = io.open(tmpdir .. "/" .. file .. ".log", "r")
    if f then
      print(f:read("*all"))
      f:close()
    end
    cp(file .. ".log", tmpdir, maindir)
    cp(file .. ".ins", tmpdir, maindir)
    error("** Error!!: Unpacking failed with luatex")
  else
    os_message("Successfully unpacked " .. file .. ".ins")
    rm(tmpdir, file .. ".log")
  end
  return 0
end

-- Helpers shared by testSE, testAF and example. All of them work inside
-- the temporary directory created by make_tmp_dir() (global 'tmpdir').

-- Copy a file under another name (cp() cannot rename)
local function copy_as(from, to)
  local fin = io.open(from, "rb")
  if not fin then return false end
  local data = fin:read("*a")
  fin:close()
  local fout = io.open(to, "wb")
  if not fout then return false end
  fout:write(data)
  fout:close()
  return true
end

local function show_log(dir, name)
  local f = io.open(dir .. "/" .. name .. ".log", "r")
  if f then
    print(f:read("*all"))
    f:close()
  end
end

-- On errors the temporary directory is kept, so the logs can be inspected
local function fail(msg)
  print("** Temporary directory kept for inspection: " .. tmpdir)
  error(msg)
end

-- Keeps only the names given on the command line (l3build testAF name ...);
-- with no names all the files are kept. A name can be written with or
-- without the .tex extension.
local function select_samples(samples, srcdir)
  local wanted = options["names"]
  if not wanted or #wanted == 0 then
    return samples
  end
  local exists = {}
  for _, name in ipairs(samples) do exists[name] = true end
  local selected = {}
  for _, arg_name in ipairs(wanted) do
    local name = (arg_name:gsub("%.tex$", ""))
    if not exists[name] then
      error("** Error!!: " .. name .. ".tex not found in " .. srcdir)
    end
    table.insert(selected, name)
  end
  return selected
end

-- Names (without extension) of the .tex files in srcdir. Only plain file
-- names are accepted because they end up in shell commands.
local function list_samples(srcdir)
  if not direxists(srcdir) then
    error("** Error!!: Directory " .. srcdir .. " not found")
  end
  local samples = {}
  for file in lfs.dir(srcdir) do
    local name = file:match("^([%w%-_]+)%.tex$")
    if name then
      table.insert(samples, name)
    elseif file:match("%.tex$") then
      print("** Warning: skipping " .. file .. " (unsafe file name)")
    end
  end
  table.sort(samples)
  if #samples == 0 then
    error("** Error!!: No .tex files found in " .. srcdir)
  end
  return select_samples(samples, srcdir)
end

-- PDF validators (the ones that are installed)
local run_rnv, run_verapdf

local function announce_validators()
  run_rnv = has_cmd("rnv-wrapp") and has_cmd("show-pdf-tags")
  run_verapdf = has_cmd("verapdf")
  if run_rnv and run_verapdf then
    os_message("Validators detected: show-pdf-tags, rnv-wrapp & veraPDF")
  elseif run_rnv then
    os_message("Validators detected: show-pdf-tags & rnv-wrapp")
  elseif run_verapdf then
    os_message("Validator detected: veraPDF")
  end
end

local function validate_pdf(dir, pdf_file)
  if run_rnv then
    local cmd_rnv = "show-pdf-tags --xml " .. pdf_file .. " | rnv-wrapp"
    if run(dir, cmd_rnv .. " > " .. os_null) ~= 0 then
      print("\n[RNC Validation Error Output]:")
      run(dir, cmd_rnv)
      fail("** Error!!: Tag structure validation (rnv-wrapp) failed for " .. pdf_file)
    end
  end
  if run_verapdf then
    local cmd_vera = "verapdf --flavour ua2 --format text " .. pdf_file
    if run(dir, cmd_vera .. " > " .. os_null) ~= 0 then
      print("\n[PDF/UA-2 Validation Error Output]:")
      run(dir, cmd_vera)
      fail("** Error!!: veraPDF (PDF/UA-2) validation failed for " .. pdf_file)
    end
  end
  if run_rnv or run_verapdf then
    print("PASS")
  end
end

-- Compile dir/sample.tex with lualatex-dev and validate the PDF. With
-- 'ghost' the file is loaded with AFghost=true, so luamml also writes
-- sample-luamml-mathml.html with the ghost marks (sptmp) for spmmli-tool.
local function compile_sample(dir, sample, label, ghost)
  os_message("Compiling " .. sample .. ".tex " .. label)
  local cmd
  if ghost then
    cmd = 'lualatex-dev -interaction=nonstopmode "\\PassOptionsToPackage{AFghost=true}{spanish-mathml-intent}\\input{'
      .. sample .. '}" > ' .. os_null
  else
    cmd = "lualatex-dev -interaction=nonstopmode " .. sample .. ".tex > " .. os_null
  end
  if run(dir, cmd) ~= 0 then
    show_log(dir, sample)
    fail("** Error!!: lualatex-dev compilation failed for " .. sample .. ".tex (" .. label .. ")")
  end
  validate_pdf(dir, sample .. ".pdf")
end

-- Remove the temporary directory (and its af/ subdirectory, if any)
local function remove_tmp_dir()
  if direxists(tmpdir .. "/af") then
    cleandir(tmpdir .. "/af")
    lfs.rmdir(tmpdir .. "/af")
  end
  cleandir(tmpdir)
  lfs.rmdir(tmpdir)
  os_message("Removed temporary directory " .. tmpdir)
end

-- Check every .tex in srcdir as mathml-SE (sample.tex compiled as it is).
-- Nothing is copied out of the temporary directory.
local function check_se(srcdir)
  local samples = list_samples(srcdir)
  make_tmp_dir()
  announce_validators()

  for _, sample in ipairs(samples) do
    if cp(sample .. ".tex", srcdir, tmpdir) ~= 0 then
      fail("** Error!!: Could not copy " .. sample .. ".tex")
    end
    compile_sample(tmpdir, sample, "with mathml-SE", false)
    os_message("OK: " .. sample .. ".tex (mathml-SE)")
  end

  os_message("All " .. #samples .. " files passed in mathml-SE")
  remove_tmp_dir()
end

-- Check every .tex in srcdir in both forms: as written (mathml-SE, compiled
-- with AFghost=true) and, once spmmli-tool has removed the ghosts, in mathml-AF
-- mode using the cleaned MathML file. With copy_pdf the results are copied
-- to the main directory as sample.pdf (mathml-SE) and sample-AF.pdf (mathml-AF).
local function check_se_af(srcdir, copy_pdf)
  local samples = list_samples(srcdir)
  make_tmp_dir()

  if not fileexists(tmpdir .. "/spmmli-tool.lua") then
    fail("** Error!!: spmmli-tool.lua was not unpacked in " .. tmpdir)
  end
  announce_validators()

  -- The mathml-AF run happens in its own subdirectory, with the same file name
  local afdir = tmpdir .. "/af"
  if mkdir(afdir) ~= 0 then
    fail("** Error!!: Could not create " .. afdir)
  end
  if cp("*.sty", tmpdir, afdir) + cp("*.lua", tmpdir, afdir) ~= 0 then
    fail("** Error!!: Could not copy the package files to " .. afdir)
  end

  for _, sample in ipairs(samples) do
    if cp(sample .. ".tex", srcdir, tmpdir) ~= 0 then
      fail("** Error!!: Could not copy " .. sample .. ".tex")
    end

    -- 1. mathml-SE run with AFghost=true: writes sample-luamml-mathml.html
    compile_sample(tmpdir, sample, "with mathml-SE and AFghost=true", true)

    -- 2. spmmli-tool removes the ghosts: writes sample-mathml.html
    --    (nothing is written when the file has no ghosts)
    os_message("Removing ghosts from " .. sample .. "-luamml-mathml.html")
    if run(tmpdir, "texlua spmmli-tool.lua -o " .. sample .. "-luamml-mathml.html > " .. os_null) ~= 0 then
      fail("** Error!!: spmmli-tool failed for " .. sample .. "-luamml-mathml.html")
    end

    local clean_html = tmpdir .. "/" .. sample .. "-mathml.html"
    local af_html = afdir .. "/" .. sample .. "-mathml.html"
    if fileexists(clean_html) then
      -- Only the ghost marks (sptmp) must be gone: a raw U+2063 may be
      -- legitimate content of an intent
      if read_file(clean_html):find("sptmp", 1, true) then
        fail("** Error!!: Ghost marks (sptmp) left in " .. sample .. "-mathml.html")
      end
      copy_as(clean_html, af_html)
    else
      -- No ghosts: the luamml file is already the one to embed
      os_message("No ghosts in " .. sample .. ": using the luamml file as it is")
      copy_as(tmpdir .. "/" .. sample .. "-luamml-mathml.html", af_html)
    end

    -- 3. Same source with mathml-AF instead of mathml-SE
    local af_source, count = read_file(srcdir .. "/" .. sample .. ".tex"):gsub("mathml%-SE", "mathml-AF")
    if count == 0 then
      fail("** Error!!: 'mathml-SE' not found in " .. sample .. ".tex")
    end
    local fout = io.open(afdir .. "/" .. sample .. ".tex", "wb")
    if not fout then
      fail("** Error!!: Could not write " .. afdir .. "/" .. sample .. ".tex")
    end
    fout:write(af_source)
    fout:close()

    -- 4. mathml-AF run
    compile_sample(afdir, sample, "with mathml-AF", false)

    -- 5. Results: the PDFs are copied next to the .tex they come from
    if copy_pdf then
      if cp(sample .. ".pdf", tmpdir, srcdir) ~= 0
          or not copy_as(afdir .. "/" .. sample .. ".pdf", srcdir .. "/" .. sample .. "-AF.pdf") then
        fail("** Error!!: Failed to copy generated PDF files to " .. srcdir)
      end
      os_message("Copied " .. sample .. ".pdf and " .. sample .. "-AF.pdf to " .. srcdir)
    end
    os_message("OK: " .. sample .. ".tex (mathml-SE and mathml-AF)")
  end

  os_message("All " .. #samples .. " files passed in mathml-SE and mathml-AF")
  remove_tmp_dir()
end

-- Custom target: l3build testSE
-- Every .tex in ./tagged-test is compiled as mathml-SE and its PDF validated.
target_list.testSE = {
  desc = "Compile and validate (mathml-SE) the files in /tagged-test",
  help = "Accepts file names, with or without .tex: l3build testSE spintent-04",
  func = function()
    check_se("tagged-test")
    return 0
  end,
}

-- Custom target: l3build testAF
-- Every .tex in ./tagged-test is checked in both forms, mathml-SE and mathml-AF
-- (see check_se_af). Both PDFs are validated; nothing is copied out.
target_list.testAF = {
  desc = "Same files in mathml-SE and mathml-AF (ghosts removed by spmmli-tool)",
  help = "Accepts file names, with or without .tex: l3build testAF spintent-04",
  func = function()
    check_se_af("tagged-test", false)
    return 0
  end,
}

-- Custom target: l3build example
-- Same as testAF for the .tex files in sources/test-pkg, but the PDFs are
-- copied to the main directory: sample.pdf (mathml-SE) and sample-AF.pdf
-- (mathml-AF).
target_list.example = {
  desc = "Same as testAF for sources/test-pkg, copying the PDFs",
  help = "Accepts file names, with or without .tex: l3build example spintent-04",
  func = function()
    check_se_af(sourcefiledir .. "/test-pkg", true)
    return 0
  end,
}

-- Custom target: l3build testpdf
-- Same as example, but for the .tex files in ./tagged-test: the PDFs are
-- left in that directory as sample.pdf (mathml-SE) and sample-AF.pdf
-- (mathml-AF). Accepts file names like testAF.
target_list.testpdf = {
  desc = "Same as example for the files in /tagged-test (PDFs left there)",
  help = "Accepts file names, with or without .tex: l3build testpdf spintent-04",
  func = function()
    check_se_af("tagged-test", true)
    return 0
  end,
}

-- The PDFs attached to the manual are the ones that 'l3build example' leaves
-- in sources/test-pkg. Before packaging, check that all of them exist and
-- are not older than their .tex (target ctan and release only; doc copies
-- what is there without checking).
local function check_example_pdfs()
  local dir = sourcefiledir .. "/test-pkg"
  local stale = {}
  for _, sample in ipairs(list_samples(dir)) do
    local tex = lfs.attributes(dir .. "/" .. sample .. ".tex", "modification")
    for _, pdf in ipairs({ sample .. ".pdf", sample .. "-AF.pdf" }) do
      local mod = lfs.attributes(dir .. "/" .. pdf, "modification")
      if not mod then
        table.insert(stale, pdf .. " (missing)")
      elseif mod < tex then
        table.insert(stale, pdf .. " (older than " .. sample .. ".tex)")
      end
    end
  end
  if #stale > 0 then
    error("** Error!!: PDFs of sources/test-pkg out of date, run 'l3build example' first:\n   "
      .. table.concat(stale, "\n   "))
  end
  os_message("Checking PDFs of sources/test-pkg")
end

if options["target"] == "ctan" then
  check_example_pdfs()
end

-- Clean repo with Git
-- 'git clean -X' removes only the files ignored by .gitignore (build/, logs,
-- ...), so it needs no confirmation. Untracked files that are not ignored
-- (new files not yet added) are never removed: they are only listed.
-- With --dry-run it only lists. The lists come from 'git ls-files' (plain
-- paths): the messages of 'git clean' are translated and show badly here.
if options["target"] == "clean" then
  local function git_out(cmd)
    local f = io.popen(cmd .. " 2>&1", "r")
    if not f then return nil end
    local out = f:read("*a") or ""
    f:close()
    return out
  end

  local inside = git_out("git rev-parse --is-inside-work-tree")
  if not inside or not inside:match("^true") then
    os_message("Not a Git work tree: skipping git clean")
  else
    local preview = git_out("git ls-files --others --ignored --exclude-standard --directory")
    if not preview or preview:match("^%s*$") then
      os_message("Nothing to clean with Git")
    else
      print("** Ignored files and directories removed by git clean:")
      io.write(preview)
      if options["dry-run"] then
        os_message("Dry run: nothing removed")
      else
        os_message("Cleaning ignored repository files with Git")
        local res = os.execute("git clean -Xdfq")
        if res ~= 0 and res ~= true then
          error("** Error!!: git clean failed")
        end
      end
    end
    local kept = git_out("git ls-files --others --exclude-standard --directory")
    if kept and not kept:match("^%s*$") then
      print("** Untracked files NOT removed (add them or delete them by hand):")
      io.write(kept)
    end
  end
  -- No ponemos os.exit() para que l3build continúe limpiando el directorio build/
end

-- Capture shell output safely (e.g. for Git queries)
local function os_capture(cmd, raw)
  local f = io.popen(cmd, "r")
  if not f then return "" end

  local s = f:read("*a") or ""
  f:close()

  if raw then return s end

  s = string.gsub(s, "^%s+", "")
  s = string.gsub(s, "%s+$", "")
  s = string.gsub(s, "[\n\r]+", " ")
  return s
end

-- Target "release": performs pre-release checks for Git and CTAN
local function release_target()
  -- 1. Verify working branch is 'main'
  local gitbranch = os_capture("git symbolic-ref --short HEAD")
  if gitbranch == "main" then
    os_message("Checking git branch 'main'")
  else
    error("** Error!!: You must be on the 'main' branch (currently on '" .. gitbranch .. "')")
  end

  -- 2. Verify clean working directory (before generating any build files)
  local gitstatus = os_capture("git status --porcelain")
  if gitstatus == "" then
    os_message("Checking working directory status")
  else
    error("** Error!!: Uncommitted changes detected. Please commit all changes before release.")
  end

  -- 3. Verify local commits are pushed
  local gitpush = os_capture("git log --branches --not --remotes")
  if gitpush == "" then
    os_message("Checking pending commits")
  else
    error("** Error!!: There are unpushed local commits. Run 'git push' first.")
  end

  -- 4. Audit version/date consistency across all files
  if not check_all_tags() then
    error("** Error!!: Tag verification failed. Update build.lua or run 'l3build tag'")
  end

  -- 5. Test source extraction via luatex
  local file = jobname(sourcefiledir .. "/spanish-mathml-intent.ins")
  local errorlevel = run(sourcefiledir, "luatex --interaction=batchmode " .. file .. ".ins > " .. os_null)
  if errorlevel ~= 0 then
    error("** Error!!: Failed to process " .. file .. ".ins with luatex")
  else
    os_message("Unpacking " .. file .. ".ins with luatex")
  end

  -- 6. Build CTAN package archive if absent
  if fileexists(ctanzip .. ".zip") then
    os_message("Checking CTAN package " .. ctanzip .. ".zip")
  else
    -- The PDFs attached to the manual are regenerated first: the ctan
    -- target refuses to run if they are missing or older than their .tex
    os_message("Running 'l3build example' (PDFs of sources/test-pkg)")
    local exres = os.execute("l3build example > " .. os_null)
    if exres ~= 0 and exres ~= true then
      error("** Error!!: 'l3build example' failed (run it alone to see why); nothing was tagged or pushed")
    end
    os_message("Building CTAN package " .. ctanzip .. ".zip")
    local res = os.execute("l3build ctan > " .. os_null)
    if res ~= 0 and res ~= true then
      error("** Error!!: 'l3build ctan' failed; nothing was tagged or pushed")
    end
  end

  -- 7. Perform CTAN upload dry run. With --debug l3build posts the form to
  -- httpbin.org and always exits with status 1, so the check looks at the
  -- echoed form (package and version) instead of the exit status.
  os_message("Running dry-run upload check")
  local dryrun = os_capture("l3build upload -F ctan.ann --debug 2>&1", true)
  local okpkg = string.find(dryrun, '"pkg": "spanish-mathml-intent"', 1, true)
  local okver = string.find(dryrun, '"version": "' .. pkgversion .. '"', 1, true)
  if not (okpkg and okver) then
    error("** Error!!: dry-run upload check failed; nothing was tagged or pushed")
  end

  -- 8. Commit what 'l3build example' and 'l3build ctan' regenerated (the PDFs
  -- versioned in git), so that the tag points to the commit that matches the
  -- zip. The working directory was clean in step 2: only regenerated files
  -- can have changed.
  local regenerated = os_capture("git status --porcelain --untracked-files=no")
  if regenerated == "" then
    os_message("No regenerated files to commit")
  else
    local commit_msg = "Release v" .. pkgversion .. " [" .. pkgdate .. "]"
    local cres = os.execute("git add -u")
    if cres ~= 0 and cres ~= true then
      error("** Error!!: 'git add -u' failed; nothing was tagged or pushed")
    end
    cres = os.execute('git commit --quiet -m "' .. commit_msg .. '"')
    if cres ~= 0 and cres ~= true then
      error("** Error!!: 'git commit' failed; nothing was tagged or pushed")
    end
    os_message("Committing regenerated files: " .. commit_msg)
    cres = os.execute("git push --quiet")
    if cres ~= 0 and cres ~= true then
      error("** Error!!: 'git push' failed. The commit exists locally; push it manually.")
    end
    os_message("Pushing the commit to remote")
  end

  -- 9. Tag commit in Git (only after everything above succeeded)
  local tag_version = "v" .. pkgversion
  local tagongit = os_capture('git for-each-ref refs/tags --sort=-taggerdate --format="%(refname:short)" --count=1')
  os_message("Checking latest Git tag (latest: " .. (tagongit ~= "" and tagongit or "none") .. ")")

  local tag_cmd = string.format('git tag -a %s -m "Release %s %s"', tag_version, tag_version, pkgdate)
  res = os.execute(tag_cmd)
  if res ~= 0 and res ~= true then
    error("** Error!!: Could not create Git tag " .. tag_version .. ". Verify if it already exists.")
  else
    os_message("Creating Git tag " .. tag_version)
  end

  os_message("Pushing Git tags to remote")
  res = os.execute("git push --tags --quiet")
  if res ~= 0 and res ~= true then
    error("** Error!!: 'git push --tags' failed. The tag " .. tag_version .. " exists locally; push it manually.")
  end

  print("-----------------------------------------------------------------")
  print("** Pre-release checks completed successfully!")
  print("** Review '" .. ctanzip .. ".curlopt' and verify 'ctan.ann'")
  print("** To publish to CTAN, run manually: l3build upload")
  print("-----------------------------------------------------------------")
  return 0
end

target_list.release = {
  desc = "Checks before a public release (git and ctan), then tags and pushes",
  help = "Runs the checks, creates the git tag and pushes it; then run l3build upload by hand.",
  func = release_target,
}
