module Util.Transpose where

import Sound.Tidal.Context
import Data.Char (isDigit)

-- Convert tidal note-notation to midi tonality, using 4 as the default octave.
noteToMidi :: String -> Int
noteToMidi note =
    -- TODO Consider break instead of span (not .)
    let (prefix, suffix) = span (not . isDigit) note
        octave = if null suffix then 5 else read suffix + 1
        pitch = case prefix of
                "c"  -> 0;  "cs" -> 1;  "cf" -> 11
                "d"  -> 2;  "ds" -> 3;  "df" -> 1
                "e"  -> 4;  "es" -> 5;  "ef" -> 3
                "f"  -> 5;  "fs" -> 6;  "ff" -> 4
                "g"  -> 7;  "gs" -> 8;  "gf" -> 6
                "a"  -> 9;  "as" -> 10; "af" -> 8
                "b"  -> 11; "bs" -> 0;  "bf" -> 10
                _    -> error ("Unsupported note: " ++ note)
    in pitch + octave * 12

-- Relatively transpose a midi-tonality from the base value to the target value.
transposeMidi :: Int -> Int -> Double
transposeMidi base target =
    2 ** (fromIntegral (target - base) / 12)

-- Produce a transposition from the base note to the given pattern using a speed control.
-- Takes a note and a pattern of notes.
transpose :: String -> Pattern String -> ControlPattern
transpose baseNote targetPattern =
    let baseMidi = noteToMidi baseNote
    in speed (fmap (transposeMidi baseMidi . noteToMidi) targetPattern)
