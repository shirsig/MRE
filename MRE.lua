local SCALE = 1
local FONT = [[Fonts\FRIZQT__.ttf]]
local COLOR = {
	MANA = {0, 0, 1},
	RAGE = {1, 0, 0},
	ENERGY = {1, 1, 0},
}

MRE_TYPE = 'MANA'
local frame = CreateFrame('Frame', nil, UIParent)
frame:SetWidth(1)
frame:SetHeight(32 * SCALE)
frame:SetPoint('CENTER', 0, 0)
local text = frame:CreateFontString()
text:SetWidth(UIParent:GetWidth())
text:SetPoint('CENTER', 0, 0)
text:SetFont(FONT, 32)
text:SetJustifyH('CENTER')
text:SetTextHeight(32 * SCALE)
frame:EnableMouse(true)
frame:SetMovable(true)
frame:SetClampedToScreen(true)
frame:RegisterForDrag('LeftButton')
frame:SetScript('OnDragStart', function() this:StartMoving() end)
frame:SetScript('OnDragStop', function() this:StopMovingOrSizing() MRE_POSITION = {frame:GetCenter()} end)
frame:SetScript('OnEvent', function()
	if event ~= 'PLAYER_LOGIN' then
		if arg1 ~= 'player' then return end
		MRE_TYPE = gsub(gsub(event, 'UNIT_', ''), 'MAX', '')
	end
	local fraction = UnitMana('player') / UnitManaMax('player')
	for i, component in COLOR[MRE_TYPE] do
		text[({'r','g','b'})[i]] = component * fraction + (1 - fraction)
	end
	text:SetText(UnitMana('player'))
	frame:SetWidth(text:GetStringWidth())
	frame:ClearAllPoints()
	frame:SetPoint('CENTER', UIParent, 'BOTTOMLEFT', unpack(MRE_POSITION or {frame:GetCenter()}))
	text:SetTextColor(text.r, text.g, text.b)
end)
for _, event in {'PLAYER_LOGIN', 'UNIT_MANA', 'UNIT_MAXMANA', 'UNIT_RAGE', 'UNIT_MAXRAGE', 'UNIT_ENERGY', 'UNIT_MAXENERGY'} do
	frame:RegisterEvent(event)
end