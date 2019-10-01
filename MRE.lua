local SCALE = 1
local FONT = [[Fonts\FRIZQT__.ttf]]
local COLOR = {
	[0] = {0, 0, 1},
	[1] = {1, 0, 0},
	[3] = {1, 1, 0},
}
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
frame:SetMovable(true)
frame:SetClampedToScreen(true)
frame:RegisterForDrag('LeftButton')
frame:SetScript('OnUpdate', function(self) self:EnableMouse(IsAltKeyDown() or self.dragging) end)
frame:SetScript('OnDragStart', function(self) self.dragging = true self:StartMoving() end)
frame:SetScript('OnDragStop', function(self) self.dragging = false self:StopMovingOrSizing() MRE_POSITION = {frame:GetCenter()} end)
frame:SetScript('OnEvent', function(_, event, arg1, arg2)
	if event == 'UNIT_POWER_UPDATE' and arg1 ~= 'player' then return end
	local fraction = UnitPower('player') / UnitPowerMax('player')
	for i, component in pairs(COLOR[UnitPowerType'player']) do
		text[({'r','g','b'})[i]] = component * fraction + (1 - fraction)
	end
	text:SetText(UnitPower('player'))
	frame:SetWidth(text:GetStringWidth())
	frame:ClearAllPoints()
	frame:SetPoint('CENTER', UIParent, 'BOTTOMLEFT', unpack(MRE_POSITION or {frame:GetCenter()}))
	text:SetTextColor(text.r, text.g, text.b)
end)
for _, event in pairs{'PLAYER_LOGIN', 'UNIT_POWER_UPDATE'} do
	frame:RegisterEvent(event)
end