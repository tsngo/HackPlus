class HackPlus_X2Ability_SpecialistAbilitySet extends X2Ability_SpecialistAbilitySet;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	return Templates;
}

static function X2AbilityTemplate FinalizeIntrusion(name FinalizeName, bool bHaywire)
{

	local X2AbilityTemplate                 Template;		
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local HackPlusConfig hackConfig;

	Template = super.FinalizeIntrusion(FinalizeName, bHaywire);

	hackConfig = new class'HackPlusConfig';
	if (hackConfig.getFreeAction()) {
		// successfully completing the hack requires no action point
		ActionPointCost = new class'X2AbilityCost_ActionPoints';
		ActionPointCost.iNumPoints = 0;
		Template.AbilityCosts.Remove(0, Template.AbilityCosts.length);
		Template.AbilityCosts.AddItem(ActionPointCost);
	}

	if (hackConfig.getAlwaysSucceed()) {
		Template.AbilityToHitCalc = new class'HackPlus_X2AbilityToHitCalc_Hacking';
	}

	Template.BuildNewGameStateFn = class'HackPlus_X2Ability_DefaultAbilitySet'.static.FinalizeHackAbility_BuildGameState;
	Template.BuildVisualizationFn = class'HackPlus_X2Ability_DefaultAbilitySet'.static.FinalizeHackAbility_BuildVisualization;
	return Template;
}
