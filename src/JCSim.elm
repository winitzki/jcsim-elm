module JCSim exposing (main)

{-| # Overview
A simulator for Join Calculus concurrent processes.

# Running

@docs main

-}

import Html.App exposing (program)
import BoxesAndBubbles.Bodies exposing (..)
import BoxesAndBubbles exposing (..)
import BoxesAndBubbles.Math2D exposing (mul2)
import List exposing (map)
import Collage exposing (..)
import Element exposing (..)
import Color exposing (..)
import Text exposing (fromString)
import AnimationFrame
import String
import Random
import Time exposing (Time)

type alias MolValue = MolEmpty | MolInt Int | MolString String

type MolName = MolName String
type ReactionName = ReactionName String

type alias Molecule = {
	value: MolValue,
	color: Color,
	size: Float,
	body: Body MolName
	}

type alias ReactionDef = {
	inputs: Set MolName,
	outputs: Set MolName,
	processDef: Set (MolName, MolValue) -> Set (MolName, MolValue)
	}

type alias Reaction = {
	percentDone: Float,
	color: Color,
	size: Float,
	body: Body ReactionName
	}

type alias SimParams = {
	frictionCoeff: Float,
	fps: Float,
	noiseCoeff: Float,
	forceCoeff: Float,
	repulsCoeff: Float
	}

initParams : SimParams = {
	frictionCoeff = 0.3,
	fps = 10.0,
	noiseCoeff = 0.1,
	forceCoeff = 0.1,
	repulsCoeff = 0.1
	}

type alias Model = {
	currentSeed: Random.Seed,
	params: SimParams,
	reactionsDefined: List ReactionDef,
	moleculesPresent: List Molecule,
	reactionsRunning: List Reaction
	}

initModel : Model = {
	currentSeed = Random.initialSeed 12345,
	params = initParams,
	reactionsDefined = [],
	moleculesPresent = [],
	reactionsRunning = []
	}

scene : Model -> Element
scene model = collage 800 600 <| drawModel model

{-
Left to clarify:
- how to map over Set, how to use filter, how to create new data structures functionally? map, map2, etc., filter, foldl, foldr
- how to generate random positions? probably need to use "step" with manual monadic state threading. Keep the current seed in the model! Otherwise, use Cmd.
- how to combine a canvas element with html buttons, sliders, etc.: make an HTML element that contains a canvas that is already converted to HTML.

-}

type Msg = Tick Time | Reset

subs : Sub Msg
subs = AnimationFrame.diffs Tick

update: Msg -> Model -> Model
update (Tick dt) bodies = step (0, -0.2) (0,0) bodies

{-| Run the animation started from the initial scene defined as `initModel`.
-}

main : Program Never
main = program { 
  init = (initModel, Cmd.none)
  , update = (\msg model -> ( update msg model, Cmd.none ))
  , subscriptions = always subs
  , view = scene >> Element.toHtml
  }
