print("============= JSONEncode")
local HttpService = game:GetService("HttpService")
for _, chi in ipairs(game:GetDescendants()) do
	local success, m = pcall(function()
		return HttpService:JSONEncode(chi.Name)
	end)
	if not success then
		print(chi.Name, m)
		chi.Name = "NotConvertJson"
	end
end

print("start module")
local IgnoreStrArr = {
	"Cannot require a RobloxScript module from a non RobloxScript context",
	"Requested module experienced an error while loading",
	"Module code did not return exactly one value"
}
local IgnoreModuleNameArr = {
	"AtomicBinding", "PlayerModule", "CameraModule", "ControlModule", "ChatScript"
}
local function isIgnoreModule(module)
	return table.find(IgnoreModuleNameArr, module.Name)
end

local GameChildrens = {workspace,game.ReplicatedStorage,game.Players,game.Lighting,game.ReplicatedFirst,game.StarterGui,game.StarterPlayer,game.SoundService}

--local LongTimeNameArr = {"TycoonButtonClient", "TycoonDropperClient", "TycoonUI", "TycoonUpdate", 
--	"Boosts", "Dash"}
local TabModuleData = {}
local AllModuleData = {}
local function initTabModuleData()
	for _, inst in ipairs(GameChildrens) do
		for _, module in ipairs(inst:GetDescendants()) do
			if module.ClassName == "ModuleScript" then
				if isIgnoreModule(module) then
					continue
				end
				if module.Parent then
					if isIgnoreModule(module.Parent) then
						continue
					end
					if module.Parent.Parent then
						if isIgnoreModule(module.Parent.Parent) then
							continue
						end
					end
				end

				task.spawn(function() -- 如果moduel里有wait，那么会一直等待
					local success, m = pcall(function()
						return require(module)
					end)
					if not success then
						print(m)
					end
					if typeof(m) == "table" then
						TabModuleData[m] = true
					end
					AllModuleData[module] = m
				end)
			end
		end
	end
	task.wait(5)
end

local TabData = {}
local function initTable(name, tab, moduleName)
	if TabData[tab] == true then
		--print("same tab:", moduleName, name, tab)
		return {}
	end
	TabData[tab] = true
	local newTab = {}
	for key, val in pairs(tab) do
		key = tostring(key)
		local typeStr = typeof(val)
		if typeStr == "string" then
		elseif typeStr == "number" then
		elseif typeStr == "boolean" then
		elseif typeStr == "table" then
			if key == "__index" then -- or key == "parent" or key == "parentUI" then
				continue
			end
			if TabModuleData[val] == true then
				--warn("module require module:", moduleName, key)
				continue
			end
			val = initTable(key, val, moduleName)
		elseif typeStr == "function" then
			val = typeStr
		elseif typeStr == "RBXScriptConnection" then
			val = typeStr
		elseif typeStr == "RBXScriptSignal" then
			val = typeStr
		elseif typeStr == "Instance" then
			val = typeStr
		elseif typeStr == "ColorSequence" then
			val = typeStr
		elseif typeStr == "Color3" then
			val = typeStr
		elseif typeStr == "BrickColor" then
			val = typeStr
		elseif typeStr == "Vector2" then
			val = typeStr
		elseif typeStr == "Vector3" then
			val = typeStr
		elseif typeStr == "CFrame" then
			val = typeStr
		elseif typeStr == "Region3" then
			val = typeStr
		elseif typeStr == "UDim" then
			val = typeStr
		elseif typeStr == "UDim2" then
			val = typeStr
		elseif typeStr == "EnumItem" then
			val = val.Name
		elseif typeStr == "NumberRange" then
			val = typeStr
		elseif typeStr == "NumberSequence" then
			val = typeStr
		elseif typeStr == "OverlapParams" then
			val = typeStr
		elseif typeStr == "TweenInfo" then
			val = typeStr
		elseif typeStr == "thread" then
			val = typeStr
		elseif typeStr == "Random" then
			val = typeStr
		elseif typeStr == "userdata" then
			val = typeStr
		elseif typeStr == "Font" then
			val = typeStr
		elseif typeStr == "ColorSequenceKeypoint" then
			val = typeStr
		else
			warn("val unknow typeof:", typeStr)
			val = typeStr
		end
		newTab[key] = val
	end
	return newTab
end

--===========================
local function printUnionOperation()
	local num = 0
	for _, chi in ipairs(game:GetDescendants()) do
		if chi.ClassName == "UnionOperation" then
			num+=1
		end
	end
	print("UnionOperation Num:", num)
end
printUnionOperation()

local PropertyData = {
	BasePart = {"Anchored","CFrame","CanCollide","CastShadow","Color","Material","Reflectance","Size","Transparency"},
	LayerCollector = {"Enabled","ResetOnSpawn","ZIndexBehavior"},
	GuiObject = {"Active","AnchorPoint","AutomaticSize","BackgroundColor3","BackgroundTransparency","BorderColor3","BorderMode","BorderSizePixel","ClipsDescendants","LayoutOrder","Position","Rotation","Size","SizeConstraint","Visible","ZIndex"},
	UIGridStyleLayout = {"FillDirection","HorizontalAlignment","SortOrder","VerticalAlignment"},
	Attachment = {"CFrame", "Visible"},
	Motor = {"CurrentAngle","DesiredAngle","MaxVelocity"},
	JointInstance = {"C0","C1","Enabled","Part0","Part1"},
	Light = {"Brightness","Color","Enabled","Shadows"},
	PostEffect = {"Enabled"},
	BackpackItem = {"TextureId"},
	Model = {"LevelOfDetail","ModelStreamingMode", "PrimaryPart", "WorldPivot"}, -- PrimaryPart
	DataModelMesh = {"Offset","Scale", "VertexColor"},
	FileMesh = {"MeshId", "TextureId"},
	Clothing = {"Color3"},
	Accoutrement = {"AttachmentPoint"},
	Constraint = {"Attachment0","Attachment1","Color","Enabled","Visible"},
	BaseWrap = {"CageMeshId","CageOrigin","ImportOrigin"},
	PoseBase = {"EasingDirection", "EasingStyle", "Weight"},
	AnimationClip = {"Loop", "Priority"},
	SoundEffect = {"Enabled", "Priority"},
	PVAdornment = {"Adornee"},
	InstanceAdornment = {"Adornee"},
	GuiBase3d = {"Color3","Transparency","Visible"},
	ControllerBase = {"Active", "BalanceRigidityEnabled", "MoveSpeedFactor"},
	HandleAdornment = {"AdornCullingMode","AlwaysOnTop","CFrame","SizeRelativeOffset","ZIndex",},
	SlidingBallConstraint = {"ActuatorType", "LimitsEnabled", "LinearResponsiveness", "LowerLimit", "MotorMaxAcceleration", "MotorMaxForce", "Restitution", "ServoMaxForce", "Size", "Speed", "TargetPosition", "UpperLimit", "Velocity"},
}
local InstData = {
	PathfindingModifier = {Properties = {"Label", "PassThrough"}},
	GroundController = {
		Inherited = {"ControllerBase"},
		Properties = {"AccelerationLean","AccelerationTime","BalanceMaxTorque","BalanceSpeed","DecelerationTime","Friction","FrictionWeight","GroundOffset","StandForce","StandSpeed","TurnSpeedFactor",}
	},

	StringValue = {Properties = {"Value"}},
	IntValue = {Properties = {"Value"}},
	NumberValue = {Properties = {"Value"}},
	BoolValue = {Properties = {"Value"}},
	CFrameValue = {Properties = {"Value"}},
	Color3Value = {Properties = {"Value"}},
	Vector3Value = {Properties = {"Value"}},
	ObjectValue = {Properties = {"Value"}},
	BrickColorValue = {Properties = {"Value"}},
	Vector3Curve = {},
	FloatCurve = {}, -- Properties = {"Length"}
	EulerRotationCurve = {Properties = {"RotationOrder"}},
	-- 脚本
	BindableEvent = {},
	BindableFunction = {},
	LocalScript = {Properties = {"Enabled"}},
	ModuleScript = {},
	RemoteEvent = {},
	UnreliableRemoteEvent = {},
	RemoteFunction = {},
	Script = {Properties = {"Enabled", "RunContext"}},
	--3D 界面
	ClickDetector = {Properties = {"CursorIcon", "MaxActivationDistance"}},
	DragDetector = {Properties = {"CursorIcon", "MaxActivationDistance", "ActivatedCursorIcon", "ApplyAtCenterOfMass", "Axis", "DragFrame", "DragStyle", "Enabled", "GamepadModeSwitchKeyCode", "KeyboardModeSwitchKeyCode", "MaxDragAngle", "MaxDragTranslation", "MaxForce", "MaxTorque", "MinDragAngle", "MinDragTranslation", "Orientation", "PermissionPolicy", "ReferenceInstance", "ResponseStyle", "Responsiveness", "RunLocally"}},
	ProximityPrompt = {Properties = {"ActionText","ClickablePrompt","Enabled","Exclusivity","GamepadKeyCode","HoldDuration","KeyboardKeyCode","MaxActivationDistance","ObjectText","RequiresLineOfSight","RootLocalizationTable","Style","UIOffset"}},
	Decal = {Properties = {"Color3","Texture","Transparency","ZIndex","Face"}},
	SurfaceAppearance = {Properties = {"AlphaMode","ColorMap","MetalnessMap","NormalMap","RoughnessMap"}},
	Texture = {Properties = {"OffsetStudsU","OffsetStudsV","StudsPerTileU","StudsPerTileV","Color3","Texture","Transparency","ZIndex","Face"}},
	-- GUI
	ScreenGui = {
		Inherited = {"LayerCollector"},
		Properties = {"DisplayOrder","IgnoreGuiInset"}
	},
	BillboardGui = {
		Inherited = {"LayerCollector"},
		Properties = {"Active","Adornee","AlwaysOnTop","Brightness","ClipsDescendants","DistanceLowerLimit","DistanceStep","DistanceUpperLimit","ExtentsOffset","ExtentsOffsetWorldSpace","LightInfluence","MaxDistance","Size","SizeOffset","StudsOffset","StudsOffsetWorldSpace"}--PlayerToHideFrom
	},
	SurfaceGui = {
		Inherited = {"LayerCollector"},
		Properties = {"AlwaysOnTop","Brightness","CanvasSize","ClipsDescendants","LightInfluence","MaxDistance","PixelsPerStud","SizingMode","ToolPunchThroughDistance","ZOffset","Active","Adornee","Face"}
	},
	Frame = {
		Inherited = {"GuiObject"},
		Properties = {"Style"}
	},
	ScrollingFrame = {
		Inherited = {"GuiObject"},
		Properties = {"AutomaticCanvasSize","BottomImage","CanvasPosition","CanvasSize","ElasticBehavior","HorizontalScrollBarInset","MidImage","ScrollBarImageColor3","ScrollBarImageTransparency","ScrollBarThickness","ScrollingDirection","ScrollingEnabled","TopImage","VerticalScrollBarInset","VerticalScrollBarPosition"}
	},
	ViewportFrame = {
		Inherited = {"GuiObject"},
		Properties = {"Ambient","CurrentCamera","ImageColor3","ImageTransparency","LightColor","LightDirection"}
	},
	TextLabel = {
		Inherited = {"GuiObject"},
		Properties = {"FontFace","LineHeight","MaxVisibleGraphemes","RichText","Text","TextColor3","TextDirection","TextScaled","TextSize","TextStrokeColor3","TextStrokeTransparency","TextTransparency","TextTruncate","TextWrapped","TextXAlignment","TextYAlignment"}
	},
	TextButton = {
		Inherited = {"GuiObject"},
		Properties = {"AutoButtonColor","Modal","Style","FontFace","LineHeight","MaxVisibleGraphemes","RichText","Text","TextColor3","TextDirection","TextScaled","TextSize","TextStrokeColor3","TextStrokeTransparency","TextTransparency","TextTruncate","TextWrapped","TextXAlignment","TextYAlignment"}
	},
	TextBox = {
		Inherited = {"GuiObject"},
		Properties = {"ClearTextOnFocus","CursorPosition","MultiLine","PlaceholderColor3","PlaceholderText","SelectionStart","ShowNativeInput","TextEditable","FontFace","LineHeight","MaxVisibleGraphemes","RichText","Text","TextColor3","TextDirection","TextScaled","TextSize","TextStrokeColor3","TextStrokeTransparency","TextTransparency","TextTruncate","TextWrapped","TextXAlignment","TextYAlignment"}
	},
	ImageLabel = {
		Inherited = {"GuiObject"},
		Properties = {"Image","ImageColor3","ImageRectOffset","ImageRectSize","ImageTransparency","ResampleMode","ScaleType","SliceCenter","SliceScale","TileSize"}
	},
	ImageButton = {
		Inherited = {"GuiObject"},
		Properties = {"HoverImage","PressedImage","AutoButtonColor","Modal","Style","Image","ImageColor3","ImageRectOffset","ImageRectSize","ImageTransparency","ResampleMode","ScaleType","SliceCenter","SliceScale","TileSize"}
	},
	CanvasGroup = {
		Inherited = {"GuiObject"},
		Properties = {"GroupColor3", "GroupTransparency"}
	},
	UIAspectRatioConstraint = {
		Properties = {"AspectRatio","AspectType","DominantAxis"}
	},
	UICorner = {
		Properties = {"CornerRadius"}
	},
	UIGradient = {
		Properties = {"Color","Enabled","Offset","Rotation","Transparency"}
	},
	UIPadding = {
		Properties = {"PaddingBottom","PaddingLeft","PaddingRight","PaddingTop"}
	},
	UIScale = {
		Properties = {"Scale"}
	},
	UIStroke = {
		Properties = {"ApplyStrokeMode","Color","Enabled","LineJoinMode","Thickness","Transparency"}
	},
	UISizeConstraint = {
		Properties = {"MaxSize", "MinSize"}
	},
	UITextSizeConstraint = {
		Properties = {"MaxTextSize", "MinTextSize"}
	},
	UIGridLayout = {
		Inherited = {"UIGridStyleLayout"},
		Properties = {"CellPadding","CellSize","FillDirectionMaxCells","StartCorner"}
	},
	UIListLayout = {
		Inherited = {"UIGridStyleLayout"},
		Properties = {"Padding"}
	},
	UIPageLayout = {
		Inherited = {"UIGridStyleLayout"},
		Properties = {"Animated","Circular","EasingDirection","EasingStyle","GamepadInputEnabled","Padding","ScrollWheelInputEnabled","TouchInputEnabled","TweenTime"}
	},
	UITableLayout = {
		Inherited = {"UIGridStyleLayout"},
		Properties = {"FillEmptySpaceColumns","FillEmptySpaceRows","MajorAxis","Padding"}
	},
	-- 部件
	Part = {
		Inherited = {"BasePart",},
		Properties = {"Shape",}
	},
	MeshPart = {
		Inherited = {"BasePart",},
		Properties = {"MeshId", "TextureID", "RenderFidelity", "CollisionFidelity"} --Enum.RenderFidelity.Precise Enum.CollisionFidelity.Box
	},
	CornerWedgePart = {
		Inherited = {"BasePart",}
	},
	WedgePart = {
		Inherited = {"BasePart"}
	},
	TrussPart = {
		Inherited = {"BasePart"},
		Properties = {"Style"}
	},
	UnionOperation = {
		Inherited = {"BasePart"},
		Properties = {"RenderFidelity","SmoothingAngle","UsePartColor","CollisionFidelity"}
	},
	IntersectOperation	 = {
		Inherited = {"BasePart"},
		Properties = {"RenderFidelity","SmoothingAngle","UsePartColor","CollisionFidelity", "FluidFidelity"}
	},
	-- 动画
	Animation = {Properties = {"AnimationId"}},
	AnimationController = {},
	Animator = {Properties = {"PreferLodEnabled"}},
	Bone = {
		Inherited = {"Attachment"},
		Properties = {"Transform"}
	},
	Motor = {Inherited = {"Motor", "JointInstance"}},
	Motor6D = {Inherited = {"Motor", "JointInstance"}},
	VelocityMotor = {
		Inherited = {"JointInstance"},
		Properties = {"CurrentAngle", "DesiredAngle", "Hole", "MaxVelocity"}
	},
	FaceControls = {Properties = {"Corrugator","LeftBrowLowerer","LeftInnerBrowRaiser","LeftNoseWrinkler","LeftOuterBrowRaiser","RightBrowLowerer","RightInnerBrowRaiser","RightNoseWrinkler","RightOuterBrowRaiser","TongueDown","TongueOut","TongueUp","JawDrop","JawLeft","JawRight","EyesLookDown","EyesLookLeft","EyesLookRight","EyesLookUp","LeftCheekRaiser","LeftEyeClosed","LeftEyeUpperLidRaiser","RightCheekRaiser","RightEyeClosed","RightEyeUpperLidRaiser","ChinRaiser","ChinRaiserUpperLip","FlatPucker","Funneler","LeftCheekPuff","LeftDimpler","LeftLipCornerDown","LeftLipCornerPuller","LeftLipStretcher","LeftLowerLipDepressor","LeftUpperLipRaiser","LipPresser","LipsTogether","LowerLipSuck","MouthLeft","MouthRight","Pucker","RightCheekPuff","RightDimpler","RightLipCornerDown","RightLipCornerPuller","RightLipStretcher","RightLowerLipDepressor","RightUpperLipRaiser","UpperLipSuck"}},
	Pose = {
		Inherited = {"PoseBase"},
		Properties = {"CFrame"}
	},
	NumberPose = {
		Inherited = {"PoseBase"},
		Properties = {"Value"}
	},
	KeyframeMarker = {Properties = {"Value"}},
	Keyframe = {Properties = {"Time"}},
	KeyframeSequence = {
		Inherited = {"AnimationClip"},
		Properties = {"AuthoredHipHeight"}
	},
	AnimationRigData = {},
	CurveAnimation = {
		Inherited = {"AnimationClip"}
	},
	-- 光
	PointLight = {
		Inherited = {"Light"},
		Properties = {"Range"}
	},
	SpotLight = {
		Inherited = {"Light"},
		Properties = {"Angle", "Face", "Range"}
	},
	SurfaceLight = {
		Inherited = {"Light"},
		Properties = {"Angle", "Face", "Range"}
	},
	-- 后期处理效果
	BloomEffect = {
		Inherited = {"PostEffect"},
		Properties = {"Intensity", "Size", "Threshold"}
	},
	BlurEffect = {
		Inherited = {"PostEffect"},
		Properties = {"Size"}
	},
	ColorCorrectionEffect = {
		Inherited = {"PostEffect"},
		Properties = {"Brightness","Contrast","Saturation","TintColor"}
	},
	DepthOfFieldEffect = {
		Inherited = {"PostEffect"},
		Properties = {"FarIntensity","FocusDistance","InFocusRadius","NearIntensity"}
	},
	SunRaysEffect = {
		Inherited = {"PostEffect"},
		Properties = {"Intensity","Spread"}
	},
	-- 环境
	Atmosphere = {Properties = {"Color","Decay","Density","Glare","Haze","Offset"}},
	Clouds = {Properties = {"Color","Cover","Density","Enabled"}},
	Sky = {Properties = {"CelestialBodiesShown","MoonAngularSize","MoonTextureId","SkyboxBk","SkyboxDn","SkyboxFt","SkyboxLf","SkyboxRt","SkyboxUp","StarCount","SunAngularSize","SunTextureId"}},
	-- 交互
	Team = {Properties = {"AutoAssignable","TeamColor"}},
	Tool = {
		Inherited = {"BackpackItem", "Model"},
		Properties = {"CanBeDropped","Enabled","Grip","ManualActivationOnly","RequiresHandle","ToolTip"}
	},
	Seat = {
		Inherited = {"BasePart"},
		Properties = {"Disabled", "Shape"}
	},
	SpawnLocation = {
		Inherited = {"BasePart"},
		Properties = {"AllowTeamChangeOnTouch","Duration","Enabled","Neutral","TeamColor", "Shape"}
	},
	VehicleSeat = {
		Inherited = {"BasePart"},
		Properties = {"Disabled","HeadsUpDisplay","MaxSpeed","Steer","SteerFloat","Throttle","ThrottleFloat","Torque","TurnSpeed"}
	},
	-- 世界
	WorldModel = {Inherited = {"Model"}},
	Actor = {Inherited = {"Model"}},
	-- 网格
	BlockMesh = {Inherited = {"DataModelMesh"}},
	FileMesh = {
		Properties = {"MeshId", "TextureId"},
		Inherited = {"DataModelMesh"}
	},
	CylinderMesh = {
		Inherited = {"DataModelMesh"}
	},
	SpecialMesh = {
		Inherited = {"DataModelMesh", "FileMesh"},
		Properties = {"MeshType"}
	},
	CharacterMesh = {Properties = {"BaseTextureId","BodyPart","MeshId","OverlayTextureId"}},
	-- 本地化
	LocalizationTable = {Properties = {"SourceLocaleId"}},
	-- 未分类
	Folder = {},
	Configuration = {},
	Model = {Inherited = {"Model"}},
	Weld = {Inherited = {"JointInstance"}},
	Snap = {Inherited = {"JointInstance"}},
	ManualWeld = {Inherited = {"JointInstance"}},
	HumanoidDescription = {Properties = {"BackAccessory","BodyTypeScale","ClimbAnimation","DepthScale","Face","FaceAccessory","FallAnimation","FrontAccessory","GraphicTShirt","HairAccessory","HatAccessory","Head","HeadColor","HeadScale","HeightScale","IdleAnimation","JumpAnimation","LeftArm","LeftArmColor","LeftLeg","LeftLegColor","MoodAnimation","NeckAccessory","Pants","ProportionScale","RightArm","RightArmColor","RightLeg","RightLegColor","RunAnimation","Shirt","ShouldersAccessory","SwimAnimation","Torso","TorsoColor","WaistAccessory","WalkAnimation","WidthScale"}},
	Camera = {Properties = {"CFrame","CameraSubject","CameraType","DiagonalFieldOfView","FieldOfView","FieldOfViewMode","Focus","HeadLocked","HeadScale","MaxAxisFieldOfView","VRTiltAndRollEnabled"}},
	Workspace = {
		Inherited = {"Model"},
		Properties = {"AirDensity","AllowThirdPartySales","ClientAnimatorThrottling","CurrentCamera","DistributedGameTime","FallenPartsDestroyHeight","GlobalWind","Gravity","InterpolationThrottling","Retargeting","StreamingEnabled"}
	},
	Lighting = {Properties = {"Ambient","Brightness","ClockTime","ColorShift_Bottom","ColorShift_Top","EnvironmentDiffuseScale","EnvironmentSpecularScale","ExposureCompensation","FogColor","FogEnd","FogStart","GeographicLatitude","GlobalShadows","OutdoorAmbient","ShadowSoftness","TimeOfDay"}},
	Players = {Properties = {"CharacterAutoLoads", "RespawnTime"}},
	StarterGui = {Properties = {"ScreenOrientation","ShowDevelopmentGui"}},
	StarterPlayer = {Properties = {"HealthDisplayDistance","NameDisplayDistance","CameraMaxZoomDistance","CameraMinZoomDistance","CameraMode","DevCameraOcclusionMode","DevComputerCameraMovementMode","DevComputerMovementMode","DevTouchCameraMovementMode","DevTouchMovementMode","EnableMouseLockOption","CharacterMaxSlopeAngle","CharacterWalkSpeed","LoadCharacterAppearance","UserEmotesEnabled","CharacterJumpHeight","CharacterJumpPower","CharacterUseJumpPower","AutoJumpEnabled"}},
	SoundService = {Properties = {"AmbientReverb","DistanceFactor","DopplerScale","RespectFilteringEnabled","RolloffScale"}},
	ReplicatedStorage = {},
	Terrain = {},
	TerrainRegion = {Properties = {"SizeInCells"}},
	PathfindingLink = {Properties = {"Attachment0","Attachment1","IsBidirectional","Label"}},
	Handles = {
		Inherited = {"GuiBase3d"},
		Properties = {"Adornee", "Style"} -- Faces
	},
	SelectionSphere = {
		Inherited = {"PVAdornment", "GuiBase3d"},
		Properties = {"SurfaceColor3", "SurfaceTransparency"}
	},
	SphereHandleAdornment = {
		Inherited = {"HandleAdornment", "PVAdornment", "GuiBase3d"},
		Properties = {"Radius"}
	},
	CylinderHandleAdornment = {
		Inherited = {"HandleAdornment", "PVAdornment", "GuiBase3d"},
		Properties = {"Angle", "Height", "InnerRadius", "Radius"}
	},
	WireframeHandleAdornment = {
		Inherited = {"HandleAdornment", "PVAdornment", "GuiBase3d"},
		Properties = {"Scale"}
	},
	ConeHandleAdornment = {
		Inherited = {"HandleAdornment", "PVAdornment", "GuiBase3d"},
		Properties = {"Height", "Radius"}
	},
	ImageHandleAdornment = {
		Inherited = {"HandleAdornment", "PVAdornment", "GuiBase3d"},
		Properties = {"Image", "Size"}
	},
	SelectionBox = {
		Inherited = {"InstanceAdornment", "GuiBase3d"},
		Properties = {"LineThickness", "SurfaceColor3", "SurfaceTransparency"}
	},
	-- 效果
	ParticleEmitter = {
		Properties = {"Brightness","Color","LightEmission","LightInfluence","Orientation","Size","Squash","Texture","Transparency","ZOffset","Shape","ShapeInOut","ShapePartial","ShapeStyle","FlipbookFramerate","FlipbookIncompatible","FlipbookLayout","FlipbookMode","FlipbookStartRandom","Drag","LockedToPart","TimeScale","VelocityInheritance","WindAffectsDrag","EmissionDirection","Enabled","Lifetime","Rate","RotSpeed","Rotation","Speed","SpreadAngle","Acceleration"}
	},
	Highlight = {
		Properties = {"Adornee","DepthMode","Enabled","FillColor","FillTransparency","OutlineColor","OutlineTransparency"}
	},
	Beam = {
		Properties = {"Attachment0","Attachment1","Brightness","Color","CurveSize0","CurveSize1","Enabled","FaceCamera","LightEmission","LightInfluence","Segments","Texture","TextureLength","TextureMode","TextureSpeed","Transparency","Width0","Width1","ZOffset"}
	},
	Fire = {
		Properties = {"Color","Enabled","Heat","SecondaryColor","Size","TimeScale"}
	},
	Smoke = {
		Properties = {"Color","Enabled","Opacity","RiseVelocity","Size","TimeScale"}
	},
	Sparkles = {
		Properties = {"Enabled","SparkleColor","TimeScale"}
	},
	Trail = {
		Properties = {"Attachment0","Attachment1","Brightness","Color","Enabled","FaceCamera","Lifetime","LightEmission","LightInfluence","MaxLength","MinLength","Texture","TextureLength","TextureMode","Transparency","WidthScale"}
	},
	WrapLayer = {
		Inherited = {"BaseWrap"},
		Properties = {"AutoSkin","BindOffset","Enabled","Order","Puffiness","ReferenceMeshId","ReferenceOrigin","ShrinkFactor"}
	},
	WrapTarget = {
		Inherited = {"BaseWrap"},
		Properties = {"Stiffness"}
	},
	ForceField = {Properties = {"Visible"}},
	-- 虚拟形象
	BodyColors = {
		Properties = {"HeadColor3","LeftArmColor3","LeftLegColor3","RightArmColor3","RightLegColor3","TorsoColor3"}
	},
	Pants = {
		Inherited = {"Clothing"},
		Properties = {"PantsTemplate"}
	},
	Shirt = {
		Inherited = {"Clothing"},
		Properties = {"ShirtTemplate"}
	},
	ShirtGraphic = {
		Properties = {"Color3", "Graphic"}
	},
	Accessory = {
		Inherited = {"Accoutrement"},
		Properties = {"AccessoryType"}
	},
	Humanoid = {Properties = {"AutoJumpEnabled","AutoRotate","AutomaticScalingEnabled","BreakJointsOnDeath","CameraOffset","DisplayDistanceType","DisplayName","Health","HealthDisplayDistance","HealthDisplayType","HipHeight","Jump","JumpHeight","JumpPower","MaxHealth","MaxSlopeAngle","NameDisplayDistance","NameOcclusion","PlatformStand","RequiresNeck","RigType","Sit","UseJumpPower","WalkSpeed"}},
	--音效
	Sound = {
		NotSaveArr = {PlaybackRegionsEnabled = true},
		Properties = {"Looped","PlaybackSpeed","Volume","SoundGroup","SoundId","RollOffMaxDistance","RollOffMinDistance","RollOffMode",}
	},
	SoundGroup = {Properties = {"Volume"}},
	DistortionSoundEffect = {
		Inherited = {"SoundEffect"},
		Properties = {"Level"}
	},
	EqualizerSoundEffect = {
		Inherited = {"SoundEffect"},
		Properties = {"HighGain","LowGain","MidGain"}
	},
	ReverbSoundEffect = {
		Inherited = {"SoundEffect"},
		Properties = {"DecayTime","Density","Diffusion","DryLevel","WetLevel"}
	},
	CompressorSoundEffect = {
		Inherited = {"SoundEffect"},
		Properties = {"Attack","GainMakeup","Ratio","Release","SideChain","Threshold"}
	},
	EchoSoundEffect = {
		Inherited = {"SoundEffect"},
		Properties = {"Delay","DryLevel","Feedback","WetLevel"}
	},
	PitchShiftSoundEffect = {
		Inherited = {"SoundEffect"},
		Properties = {"Octave"}
	},
	ChorusSoundEffect = {
		Inherited = {"SoundEffect"},
		Properties = {"Depth", "Mix", "Rate"}
	},
	TremoloSoundEffect = {
		Inherited = {"SoundEffect"},
		Properties = {"Depth", "Duty", "Frequency"}
	},
	--约束
	Attachment = {Inherited = {"Attachment"}},
	WeldConstraint = {
		Properties = {"Enabled","Part0","Part1"}
	},
	RodConstraint = {
		Inherited = {"Constraint"},
		Properties = {"Length","LimitAngle0","LimitAngle1", "LimitsEnabled", "Thickness"}
	},
	HingeConstraint = {
		Inherited = {"Constraint"},
		Properties = {"ActuatorType","AngularResponsiveness","AngularSpeed", "AngularVelocity", "LimitsEnabled", "LowerAngle", "MotorMaxAcceleration", "MotorMaxTorque", "Radius", "Restitution", "ServoMaxTorque", "TargetAngle", "UpperAngle"}
	},
	RopeConstraint = {
		Inherited = {"Constraint"},
		Properties = {"Length","Restitution","Thickness", "WinchEnabled", "WinchForce", "WinchResponsiveness", "WinchSpeed", "WinchTarget"}
	},
	PlaneConstraint = {
		Inherited = {"Constraint"},
	},
	RigidConstraint = {Inherited = {"Constraint"}},
	AlignOrientation = {
		Inherited = {"Constraint"},
		Properties = {"AlignType","CFrame","LookAtPosition","MaxAngularVelocity","MaxTorque","Mode","PrimaryAxis","PrimaryAxisOnly","ReactionTorqueEnabled","Responsiveness","RigidityEnabled","SecondaryAxis"}
	},
	AlignPosition = {
		Inherited = {"Constraint"},
		Properties = {"ApplyAtCenterOfMass","ForceLimitMode","ForceRelativeTo","MaxAxesForce","MaxForce","MaxVelocity","Mode","Position","ReactionForceEnabled","Responsiveness","RigidityEnabled"}
	},
	BallSocketConstraint = {
		Inherited = {"Constraint"},
		Properties = {"LimitsEnabled","MaxFrictionTorque","Radius","Restitution","TwistLimitsEnabled","TwistLowerAngle","TwistUpperAngle","UpperAngle"}
	},
	PrismaticConstraint = {
		Inherited = {"Constraint", "SlidingBallConstraint"},
	},
	CylindricalConstraint = {
		Inherited = {"Constraint", "SlidingBallConstraint"},
		Properties = {"AngularActuatorType","AngularLimitsEnabled","AngularResponsiveness","AngularRestitution","AngularSpeed","AngularVelocity","InclinationAngle","LowerAngle","MotorMaxAngularAcceleration", "MotorMaxTorque", "RotationAxisVisible", "ServoMaxTorque", "TargetAngle", "UpperAngle"}
	},
	BodyGyro = {Properties = {"CFrame","D","MaxTorque","P"}},
	BodyPosition = {Properties = {"D","MaxForce","P","Position"}},
	RocketPropulsion = {Properties = {"CartoonFactor", "MaxSpeed", "MaxThrust", "MaxTorque", "Target", "TargetOffset", "TargetRadius", "ThrustD", "ThrustP", "TurnD", "TurnP"}},
	VectorForce = {
		Inherited = {"Constraint"},
		Properties = {"ApplyAtCenterOfMass","Force","RelativeTo"}
	},
	BodyForce = {Properties = {"Force"}},
	LinearVelocity = {
		Inherited = {"Constraint"},
		Properties = {"ForceLimitMode","ForceLimitsEnabled","LineDirection","LineVelocity","MaxAxesForce","MaxForce","MaxPlanarAxesForce","PlaneVelocity","PrimaryTangentAxis","RelativeTo","SecondaryTangentAxis","VectorVelocity","VelocityConstraintMode"}
	},
	SpringConstraint = {
		Inherited = {"Constraint"},
		Properties = {"Coils","Damping","FreeLength","LimitsEnabled","MaxForce","MaxLength","MinLength","Radius","Stiffness","Thickness"}
	},
	AngularVelocity = {
		Inherited = {"Constraint"},
		Properties = {"AngularVelocity", "MaxTorque", "ReactionTorqueEnabled", "RelativeTo"}
	},
	NoCollisionConstraint = {
		Properties = {"Enabled", "Part0", "Part1"}
	},
	IntConstrainedValue = {
		Properties = {"ConstrainedValue", "MaxValue", "MinValue", "Value"},
	},
	BodyVelocity = {
		Properties = {"MaxForce", "P", "Velocity"},
	},
	BodyAngularVelocity = {
		Properties = {"AngularVelocity", "MaxTorque", "P"},
	},
	TerrainDetail = {
		Properties = {"ColorMap", "Face", "MaterialPattern", "MetalnessMap", "NormalMap", "RoughnessMap", "StudsPerTile"},
	},
	IKControl = {
		Properties = {"ChainRoot", "Enabled", "EndEffector", "EndEffectorOffset", "Offset", "Pole", "Priority", "SmoothTime", "Target", "Type", "Weight"},
	},
	Hat = {
		Properties = {"AttachmentPoint"},
	},
	MaterialVariant = {
		Properties = {"BaseMaterial","ColorMap","CustomPhysicalProperties","MaterialPattern","MetalnessMap","NormalMap","RoughnessMap","StudsPerTile",},
	},
	Dialog = {
		Properties = {"BehaviorType","ConversationDistance","GoodbyeChoiceActive","GoodbyeDialog","InUse","InitialPrompt","Purpose","Tone","TriggerDistance","TriggerOffset",},
	},
	DialogChoice = {
		Properties = {"GoodbyeChoiceActive","GoodbyeDialog","ResponseDialog","UserDialog"},
	},
}

local HttpService = game.HttpService

local GUIDData = {}
local function setGUID(inst)
	if GUIDData[inst] == nil then
		GUIDData[inst] = HttpService:GenerateGUID(false)
	end
	return GUIDData[inst]
end

local function saveVal(val, data, key)
	if val == nil then return end

	local typeStr = typeof(val)
	if typeStr == "number" then
		if val == math.huge then
			val = "INF"
		end
	elseif typeStr == "string" then
	elseif typeStr == "boolean" then
	elseif typeStr == "Vector2" then
		local x = val.X
		if x == math.huge then
			x = "INF"
		end
		local y = val.Y
		if y == math.huge then
			y = "INF"
		end
		val = {X=x, Y=y}
	elseif typeStr == "Vector3" then
		local x = val.X
		if x == math.huge then
			x = "INF"
		end
		local y = val.Y
		if y == math.huge then
			y = "INF"
		end
		local z = val.Z
		if z == math.huge then
			z = "INF"
		end
		val = {X=x, Y=y, Z=z}
	elseif typeStr == "UDim" then
		val = {Scale=val.Scale, Offset=val.Offset}
	elseif typeStr == "UDim2" then
		val = {X={Scale=val.X.Scale, Offset=val.X.Offset}, Y={Scale=val.Y.Scale, Offset=val.Y.Offset}}
	elseif typeStr == "Rect" then
		val = {Min={X=val.Min.X, Y=val.Min.Y}, Max={X=val.Max.X, Y=val.Max.Y}}
	elseif typeStr == "NumberRange" then
		val = {val.Min, val.Max}
	elseif typeStr == "NumberSequence" then
		local keypoints = val.Keypoints
		val = {}
		for _, keypoint in ipairs(keypoints) do
			val[#val+1] = {Time = keypoint.Time, Value = keypoint.Value, Envelope = keypoint.Envelope}
		end
	elseif typeStr == "ColorSequence" then
		local keypoints = val.Keypoints
		val = {}
		for _, keypoint in ipairs(keypoints) do
			val[#val+1] = {Time = keypoint.Time, Color = keypoint.Value:ToHex()}
		end
	elseif typeStr == "EnumItem" then
		val = val.Value
	elseif typeStr == "Color3" then
		local success = pcall(function()
			val = val:ToHex()
		end)
		if not success then
			val = Color3.new(math.clamp(val.R, 0, 1), math.clamp(val.G, 0, 1), math.clamp(val.B, 0, 1)):ToHex()
		end
	elseif typeStr == "BrickColor" then
		val = val.Number
	elseif typeStr == "CFrame" then
		val = {val:GetComponents()}
	elseif typeStr == "Font" then
		val = {Family = val.Family, Weight = val.Weight.Name, Style = val.Style.Name}
	elseif typeStr == "Instance" then
		val = setGUID(val)
	else
		warn(1, key, typeStr, val)
		return
	end
	data[key] = {
		TypeStr = typeStr,
		Val = val
	}
end

local function saveProperty(chi, data, properties)
	local success, m = pcall(function()
		for _, key in ipairs(properties) do
			saveVal(chi[key], data, key)
		end
	end)
	if not success then
		warn(9, m)
	end
end

local NotPrintClassNameArr = {
	"DataModel", "Player", "PlayerScripts", "PlayerGui", "StarterGear", "Backpack", "ReplicatedFirst", "StarterPlayerScripts", "StarterCharacterScripts"
}
local function initModule(chi, data)
	if chi.ClassName ~= "ModuleScript" then return end

	local source
	local m = AllModuleData[chi]
	if m==nil then
		--print("not require module name:", chi.Name)
		return
	end

	local typeStr = typeof(m)
	if typeStr == "string" then
		if not table.find(IgnoreStrArr, m) and not string.find(m, "lacking capability Unknown") then
			--print("module is string", m)
		end
		source = m
	elseif typeStr == "table" then
		local newTab = initTable(chi.Name, m, chi.Name)
		local success, m = pcall(function()
			return HttpService:JSONEncode(newTab)
		end)
		source = m
		if not success then
			warn("initModule table", m)
		end
	elseif typeStr == "function" then
		--print("function", "module.Name:", chi.Name)
		source = "function"
	elseif typeStr == "boolean" then
		source = m
	elseif typeStr == "Instance" then
		source = "Instance"
	elseif typeStr == "EnumItem" then
		source = m.Name
	else
		warn("module unknow typeof:", typeStr)
		source = "module unknow typeof: "..typeStr
	end
	data.Source = {
		TypeStr = typeStr,
		Val = source,
	}
end

local function saveInstData(chi, data)
	data.Name = chi.Name
	data.ClassName = chi.ClassName
	data.GUID = setGUID(chi)
	local attributes = {}
	local success, m = pcall(function()
		for k, v in chi:GetAttributes() do
			saveVal(v, attributes, k)
		end
	end)
	if not success then
		warn(10, m)
	end
	if next(attributes) ~= nil then
		data.Attributes = attributes
	end

	initModule(chi, data)

	local instData = InstData[chi.ClassName]
	if instData then
		if instData.Properties then
			saveProperty(chi, data, instData.Properties)
		end

		if instData.Inherited then
			for _, inherited in ipairs(instData.Inherited) do
				saveProperty(chi, data, PropertyData[inherited])
			end
		end

		if instData.NotSaveArr then
			for _k, _v in pairs(instData.NotSaveArr) do
				if chi[_k] == _v then
					warn("saveInstData", "not Save Property:", _k, chi.Name)
				end
			end
		end
	else
		if not table.find(NotPrintClassNameArr, chi.ClassName) then
			print("Not Save ClassName:", chi.ClassName)
		end
	end
end

local MeshIdData = {}
local MeshSizeData = {}
local function saveMeshIdData(inst)
	if inst.ClassName == "MeshPart" and inst.MeshId ~= "" then
		if not table.find(MeshIdData, inst.MeshId) then
			MeshIdData[#MeshIdData+1] = inst.MeshId
			MeshSizeData[inst.MeshId] = inst.MeshSize
		end
	end
end

local IgnoreClassNameArr = {
	"Status", "TouchTransmitter", "PackageLink"
}
local function isIgnoreClassName(inst)
	if table.find(IgnoreClassNameArr, inst.ClassName) then
		if #inst:GetChildren() ~= 0 then
			warn("isIgnoreClassName", string.format("IgnoreClassName: %s, #GetChildren:", inst.ClassName), #inst:GetChildren())
		end
		return true
	else
		return false
	end
end

local function saveInstance(inst)
	if isIgnoreClassName(inst) then return nil end

	saveMeshIdData(inst)

	local tempData = {}
	saveInstData(inst, tempData)
	local childrens = nil
	if inst == game then
		childrens = GameChildrens
	else
		childrens = inst:GetChildren()
	end
	for _, chi in ipairs(childrens) do
		local _tempData = saveInstance(chi)
		if _tempData ~= nil then
			if tempData.Childrens == nil then
				tempData.Childrens = {}
			end
			tempData.Childrens[#tempData.Childrens+1] = _tempData
		end
	end
	return tempData
end

local function saveAsset(asset)
	local TempData = saveInstance(asset)
	if TempData == nil then return end
	local success, DataStr = pcall(function()
		return HttpService:JSONEncode(TempData)
	end)
	if not success then
		-- "Can't convert to JSON"
		-- GetAttributes 有问题
		-- "这是因为名字有问题： 文件夹 ？01"
		--for _, chi in ipairs(workspace.Map["World 19"]:GetDescendants()) do
		--	print(chi.Name,chi.ClassName)
		--	chi.Name = "Model"
		--end
		--for _, chi in ipairs(workspace.Map:GetChildren()) do
		--	saveAsset(chi)
		--end
		--for _, chi in ipairs(game:GetDescendants()) do
		--	if string.find(chi.Name, "%[%[") then
		--		print(chi:GetFullName())
		--		chi.Name = string.gsub(chi.Name, "%[", "<<")
		--		print(chi.Name)
		--	end
		--	if string.find(chi.Name, "%]%]") then
		--		print(chi:GetFullName())
		--		chi.Name = string.gsub(chi.Name, "%]", ">>")
		--		print(chi.Name)
		--	end
		--end
		warn("saveAsset", asset.Name, DataStr)
	end
	--local pattern = '{"GUID":'
	--local repl = "\n"..pattern
	--local repNum
	--DataStr, repNum = string.gsub(DataStr, pattern, repl)
	--print(repNum)
	DataStr = "local DataStr = [["..DataStr.."]]"

	DataStr..="\n"
	DataStr..=[[
		local InsertService = game:GetService("InsertService")
		print("Start LoadAsset: DecodeInstance")
		local success, model
		success, model = pcall(function()
			return InsertService:LoadAsset(14632224402) -- 14632224402 16532216346
		end)
		if not success then
			success, model = pcall(function()
				return InsertService:LoadAsset(14779665211)
			end)
		end
		print("End LoadAsset: DecodeInstance")
		require(model.DecodeInstance)(DataStr)
	]]

	writefile(asset.Name..".lua", DataStr)
end

initTabModuleData()
print("Start save assets")
saveAsset(game)
--game.ReplicatedStorage.Assets.Shenron:Destroy()
--for _, chi in ipairs(game.ReplicatedStorage.Assets.Shenron.RootPart:GetChildren()) do
--	saveAsset(chi)
--end

--local SaveNameArr = {
--	workspace, game.ReplicatedStorage,
--	game.Players, game.Lighting,
--	game.ReplicatedFirst, game.StarterGui, game.StarterPlayer, game.SoundService
--}
--for _, chi in ipairs(SaveNameArr) do
--	saveAsset(chi)
--end

--==================
-- Cant convert to JSON 名字有问题
--for _, chi in ipairs(game:GetDescendants()) do
--	local success, messege = pcall(function()
--		return game.HttpService:JSONEncode(chi.Name)
--	end)
--	if not success then
--		print(chi:GetFullName())
--		chi.Name = "NameIsError"
--	end
--	--setclipboard(chi.Name)
--	--chi.Name = "011"
--end

local str_1 = [[
<roblox xmlns:xmime="http://www.w3.org/2005/05/xmlmime" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.roblox.com/roblox.xsd" version="4">
	<Meta name="ExplicitAutoJoints">true</Meta>
	<Item class="Folder">
		<Properties>
			<string name="Name">_Meshes</string>
		</Properties>
		%s
	</Item>
</roblox>
]]
local str_2 = [[
		<Item class="MeshPart">
			<Properties>
				<Content name="MeshId"><url>%s</url></Content>
				<string name="Name">%s</string>
				<Vector3 name="InitialSize">
					<X>%s</X>
					<Y>%s</Y>
					<Z>%s</Z>
				</Vector3>
			</Properties>
		</Item>
]]
local str_3 = ""
for _, meshId in ipairs(MeshIdData) do
	local meshSize = MeshSizeData[meshId]
	local newStr = string.format(str_2, meshId, meshId, tostring(meshSize.X), tostring(meshSize.Y), tostring(meshSize.Z))
	str_3..= newStr
end
writefile("_Meshes.rbxmx", string.format(str_1, str_3))
print("End save assets")