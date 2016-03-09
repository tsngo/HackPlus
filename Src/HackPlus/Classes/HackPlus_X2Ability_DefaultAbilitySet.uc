class HackPlus_X2Ability_DefaultAbilitySet extends X2Ability_DefaultAbilitySet;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	return Templates;
}

static function X2AbilityTemplate FinalizeHack()
{
	local X2AbilityTemplate                 Template;		
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local HackPlusConfig hackConfig;

	Template = super.FinalizeHack();

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

	return Template;
}

simulated function XComGameState FinalizeHackAbility_BuildGameState(XComGameStateContext Context)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_BaseObject TargetState;
	local XComGameState_InteractiveObject ObjectState;
	local XComGameState_Unit UnitState, TargetUnit;
	local XComGameStateContext_Ability AbilityContext;
	local HackPlusConfig hackConfig;
	local int rewardValue;
	local int userRewardChoice;

	History = `XCOMHISTORY;

	NewGameState = super.FinalizeHackAbility_BuildGameState(Context);
	hackConfig = new class'HackPlusConfig';

	AbilityContext = XComGameStateContext_Ability(Context);	
	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	TargetState = NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID);

	ObjectState = XComGameState_InteractiveObject(TargetState);
	if (ObjectState == none)
		TargetUnit = XComGameState_Unit(TargetState);	
	userRewardChoice = ObjectState == none ? TargetUnit.UserSelectedHackReward : ObjectState.UserSelectedHackReward;

	`RedScreen("Choice " $ userRewardChoice);
	if ((ObjectState != none && ObjectState.bHasBeenHacked) || TargetUnit.bHasBeenHacked) {
		rewardValue = userRewardChoice >= 2 ? hackConfig.getHackPointRewardOnSuccess() : hackConfig.getHackPointRewardEasyOnSuccess();
		`Redscreen("Success " $ rewardValue);
	}
	else {
		rewardValue = hackConfig.getHackPointRewardOnFail();
		`Redscreen("Fail " $ rewardValue);
	}

	if (hackConfig.getRandomizeReward()) {
		rewardValue = `SYNC_RAND(rewardValue);
		`Redscreen("Random " $ rewardValue);
	}

	if (rewardvalue <= 0)
		return NewGameState;

	// Apply award
	NewGameState.AddStateObject(UnitState);
	UnitState.SetBaseMaxStat(eStat_Hacking, UnitState.GetMaxStat(eStat_Hacking) + rewardValue);	

	return NewGameState;
}
