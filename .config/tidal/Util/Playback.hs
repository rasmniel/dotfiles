module Util.Playback where

import Sound.Tidal.Context
import Data.IORef
import Control.Concurrent
import GHC.IO (unsafePerformIO)

defaultCps :: Double
defaultCps = 135 / 60 / 4

-- Declare a global, mutable ref to hold current cps.
-- Initialized as default Tidal cps, which equates to 0.5625 cycles per second or 135 bpm.
{-# NOINLINE cpsRef #-}
cpsRef :: IORef Double
cpsRef = unsafePerformIO (newIORef defaultCps)

-- Play the current cycle of the given ControlPattern once, immediately.
-- This function is useful for playing something in isolation, e.g. when recording the output.
-- However, using this will mess with other playback, because it resets the cycle.
play :: IO() -> (ControlPattern -> IO()) -> ControlPattern -> IO()
play resetCycles once controlPattern =
    do
        resetCycles;
        once controlPattern

-- Hush after the given number of cycles.
-- Takes cps into account if set with cpsCtrl.
hushAfter :: IO() -> Double -> IO ThreadId
hushAfter hush cycles =
    forkIO $ do
        cpsValue <- readIORef cpsRef
        let seconds = cycles / cpsValue
        threadDelay $ round $ seconds * 1000000
        hush

-- Set the cps and remember the value for later use.
-- Similar to setcps, which does not store the value.
cpsCtrl :: (Pattern Double -> IO()) -> Double -> IO()
cpsCtrl setcps value = do
    writeIORef cpsRef value
    setcps (pure value)

-- Set bpm insted of cps.
bpmCtrl :: (Pattern Double -> IO()) -> Double -> IO()
bpmCtrl setcps value =
    cpsCtrl setcps (value / 60 / 4)

-- Reset cps to the default value.
cpsReset :: (Pattern Double -> IO()) -> IO()
cpsReset setcps =
    cpsCtrl setcps defaultCps
