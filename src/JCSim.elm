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

type alias Model = {
	params: SimParams,
	molecules: List Molecule,
	reactions: List Reaction
	}

initModel : Model = ...

scene : Model -> Element
scene bodies = collage 800 800 <| map drawBody bodies 

type Msg = Tick Time | Reset

subs : Sub Msg
subs = AnimationFrame.diffs Tick

update: Msg -> Model meta -> Model meta
update (Tick dt) bodies = step (0, -0.2) (0,0) bodies

{-| Run the animation started from the initial scene defined as `initModel`.
-}

main : Program Never
main = program { 
  init = (initModel, Cmd.none)
  , update = (\msg bodies -> ( update msg bodies, Cmd.none ))
  , subscriptions = always subs
  , view = scene >> Element.toHtml
  }
