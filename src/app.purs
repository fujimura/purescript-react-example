-- Taken from https://github.com/purescript-contrib/purescript-react/blob/9d93da3a6645be5059c3a499cc71817adfae207e/example/app/app.purs
module Main where

import Control.Monad.Eff
import Debug.Trace
import React
import React.DOM

foreign import interval
  "function interval(ms) { \
  \  return function(action) { \
  \    return function() { return setInterval(action, ms); } \
  \  } \
  \}"
  :: forall eff r. Number -> Eff (trace :: Trace) r -> Eff (eff) Unit

helloInConsole e = do
  props <- getProps
  trace ("Hello, " ++ props.name ++ "!")

hello = mkUI spec do
  props <- getProps
  return $ h1 [
      className "Hello",
      onClick helloInConsole,
      style {background: "gray"}
    ] [
      text "Hello, ",
      text props.name
    ]

incrementCounter e = do
  val <- readState
  writeState (val + 1)

counter = mkUI spec {
    getInitialState = return 0,
    componentDidMount = do
      self <- getSelf
      interval 1000 $ runUI self do
        val <- readState
        print val
  } do
  val <- readState
  return $ p [className "Counter", onClick incrementCounter] [
      text (show val),
      text " Click me to increment!"
    ]

main = do
  let component = div' [hello {name: "World"}, counter {}]
  renderToBody component
