﻿------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Rage Winterchill"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Winterchill",
	
	decay = "Death & Decay on You",
	decay_desc = "Warn for Death & Decay on You.",
	decay_trigger = "You are afflicted by Death & Decay.",
	decay_message = "Death & Decay on YOU!",

	icebolt = "Icebolt",
	icebolt_desc = "Icebolt warnings.",
	icebolt_trigger = "Icebolt hits ([^%s]+)",
	icebolt_message = "Icebolt on %s!",
	
	icon = "Icon",
	icon_desc = "Place a Raid Icon on the player afflicted by Icebolt (requires promoted or higher).",
} end )

L:RegisterTranslations("frFR", function() return {
	decay = "Mort & dcomposition sur vous",
	decay_desc = "Prviens quand la Mort & dcomposition est sur vous.",
	decay_trigger = "Vous subissez les effets de Mort & dcomposition.",
	decay_message = "Mort & dcomposition sur VOUS !",

	icebolt = "Eclair de glace",
	icebolt_desc = "Avertissements concernant l'Eclair de glace.",
	icebolt_trigger = "Eclair de glace touche ([^%s]+)",
	icebolt_message = "Eclair de glace sur %s !",

	icon = "Icne",
	icon_desc = "Place une icne de raid sur le dernier joueur affect par l'Eclair de glace (ncessite d'tre promu ou mieux).",
} end )

L:RegisterTranslations("koKR", function() return {
	decay = "당신에 죽음과 부패",
	decay_desc = "당신에 걸린 죽음과 부패를 알립니다.",
	decay_trigger = "당신은 죽음과 부패에 걸렸습니다.",
	decay_message = "당신에 죽음과 부패!",

	icebolt = "얼음 화살",
	icebolt_desc = "얼음 화살 경고.",
	icebolt_trigger = "^([^|;%s]*)(.*)얼음 화살에 걸렸습니다.", -- "Icebolt hits ([^%s]+)",
	icebolt_message = "%s에 얼음 화살!",
	
	icon = "전술 표시",
	icon_desc = "얼음 화살에 걸린 플레이어에 전술 표시를 지정합니다 (승급자 이상 권한 요구).",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Hyjal Summit"]
mod.enabletrigger = boss
mod.toggleoptions = {"decay", -1, "icebolt", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "WinterchillBolt", 5)
	
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "WinterchillBolt" and rest and self.db.profile.icebolt then
		self:Message(L["icebolt_message"]:format(rest), "Important", nil, "Alert")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	local player = select(3, msg:find(L["icebolt_trigger"]))
	if player then
		if player == L2["you"] then
			player = UnitName("player")
		end
		self:Sync("WinterchillBolt " .. player)
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE(msg)
	if self.db.profile.decay and msg == L["decay_trigger"] then
		self:Message(L["decay_message"], "Personal", true, "Alarm")
	end
end