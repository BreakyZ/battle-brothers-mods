local mod = ::HackflowsPerks <- {
    ID = "mod_hackflows_perks"
    Name = "Hackflow's Perks"
    Version = 1.5
    Updates = {
        nexus = "https://www.nexusmods.com/battlebrothers/mods/673"
        github = "https://github.com/Suor/battle-brothers-mods/tree/master/hackflows_perks"
        tagPrefix = "hackflows-perks-"
    }

    BoneInjuries = [
        "injury.broken_leg"
        "injury.broken_nose"
        "injury.broken_ribs"
        "injury.fractured_elbow"
        "injury.fractured_hand"
        "injury.fractured_ribs"
        "injury.fractured_skull"
        "injury.smashed_hand"
    ]
    function fleshOnBonesActive(_player) {
        local fleshOnTheBones = false;
        foreach (skill in _player.m.Skills.m.Skills) { // -> skills_container -> actual array
            if (skill.isGarbage()) continue;

            local id = skill.getID();
            if (id == "perk.hackflows.flesh_on_the_bones") fleshOnTheBones = true;
            if (this.BoneInjuries.find(id) != null) return false;
        }
        return fleshOnTheBones;
    }
}
local Str = ::std.Str, Text = ::std.Text;

::mods_registerMod(mod.ID, mod.Version, mod.Name);
::mods_queue(mod.ID, "stdlib, >mod_heal_repair_fix, >mod_reforged", function() {
    ::include("scripts/hp_rosetta_ru");

    // Hooks for Flesh on the Bones perk
    ::mods_hookExactClass("entity/tactical/actor", function (cls) {
        local setHitpoints = cls.setHitpoints;
        cls.setHitpoints = function (_h) {
            if (_h > this.m.Hitpoints && mod.fleshOnBonesActive(this)) {
                _h += _h - this.m.Hitpoints; // Double the addition
            }
            setHitpoints(_h);
        }
    })

    // Double Nine Lives too, it uses direct hitpoints assignment so the above won't work
    ::mods_hookExactClass("skills/perks/perk_nine_lives", function (cls) {
        local setSpent = cls.setSpent;
        cls.setSpent = function (_f) {
            if (!_f || !mod.fleshOnBonesActive(this.getContainer().getActor())) return setSpent(_f);

            local actor = this.getContainer().getActor();
            actor.m.Hitpoints = ::Math.min(actor.m.Hitpoints * 2, actor.getHitpointsMax());
            return setSpent(_f);
        }
    })

    ::mods_hookExactClass("entity/tactical/player", function (cls) {
        local getRosterTooltip = cls.getRosterTooltip;
        cls.getRosterTooltip = function () {
            local tooltip = getRosterTooltip();
            if (this.getHitpoints() >= this.getHitpointsMax()) return tooltip;
            if (!mod.fleshOnBonesActive(this)) return tooltip;

            foreach (line in tooltip) {
                if (!Str.startswith(line.text, "Light Wounds")) continue;

                local rate = ::Const.World.Assets.HitpointsPerHour * 2; // This perk doubles it
                if (("State" in ::World) && ::World.State != null)
                    rate *= ::World.Assets.m.HitpointsPerHourMult;

                local toHeal = this.getHitpointsMax() - this.getHitpoints();
                local days = ::Math.ceil(toHeal * 1.0 / rate / 24);
                line.text = format("Light Wounds (%i day%s)", days, Text.plural(days));
            }
            return tooltip;
        }
    })

    // Injury hint thinks there is only one reason to ignore injuries.
    // This is not true even without this mod. Cultist prophet also ignores them.
    ::mods_hookExactClass("skills/injury/injury", function (cls) {
        local addTooltipHint = cls.addTooltipHint;
        cls.addTooltipHint = function (_tooltip) {
            addTooltipHint(_tooltip);
            if (!mod.fleshOnBonesActive(this.getContainer().getActor())) return;

            foreach (line in _tooltip) {
                if (Str.endswith(line.text, "Iron Will effect"))
                    line.text = Str.replace(line.text, "Iron Will effect", "Flesh on the Bones")
            }
        }
    })

    // Add these perks to Reforged perk trees.
    // Do not use Stabilized: Reforged has its own medium armor perk.
    // Bloody Harvest is kind of superseded with Death Dealer, doesn't work with ranged though.
    // And Reforged has an unpolished version of Battle Flow.
    if (::mods_getRegisteredMod("mod_reforged")) {
        local groupToPerks = {
            "pg.rf_soldier":  [[0, "perk.hackflows.flesh_on_the_bones"]]
            "pg.rf_militia": [[0, "perk.hackflows.flesh_on_the_bones"]]
            "pg.rf_pauper": [[1, "perk.hackflows.flesh_on_the_bones"]]
            "pg.rf_vigorous": [[0, "perk.hackflows.flesh_on_the_bones"]]
            "pg.rf_agile": [[4, "perk.hackflows.balance"]]
            "pg.rf_power": [[5, "perk.hackflows.full_force"]]
            "pg.rf_medium_armor": [[4, "perk.hackflows.balance"]]
            "pg.rf_heavy_armor": [[5, "perk.hackflows.full_force"]] // ???
            "pg.rf_large": [[4, "perk.hackflows.full_force"]]
        }

        local add = ::DynamicPerks.PerkGroups.add;
        ::DynamicPerks.PerkGroups.add = function (_perkGroup) {
            add(_perkGroup);
            if (_perkGroup.getID() in groupToPerks) {
                local tree = _perkGroup.m.Tree;
                foreach (pair in groupToPerks[_perkGroup.getID()]) {
                    tree[pair[0]].push(pair[1])
                }
            }
        }
    }
})

::mods_queue(mod.ID, ">msu", function () {
     if (!("MSU" in getroottable())) return;
    ::include("scripts/i_hackflows_perks_hack_msu");
    ::HackMSU.setup(mod, mod.Updates)
});
